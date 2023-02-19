import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scannerktp/ktp_scanner/camera_getcontroller.dart';
import 'package:scannerktp/ktp_scanner/constants/agama.dart';
import 'package:scannerktp/ktp_scanner/constants/golongan_darah.dart';
import 'package:scannerktp/ktp_scanner/constants/kewarganegaraan.dart';
import 'package:scannerktp/ktp_scanner/constants/pekerjaan.dart';
import 'package:scannerktp/ktp_scanner/constants/status_perkawinan.dart';
import 'package:scannerktp/ktp_scanner/ktp_scanner_screen.dart';
import 'package:scannerktp/ktp_scanner/models/kode_pos.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/keldesa.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';
import 'package:scannerktp/ktp_scanner/models/ktp.dart';
import 'package:scannerktp/ktp_scanner/models/ktp_text_data.dart';
import 'package:scannerktp/ktp_scanner/models/nik_data.dart';
import 'package:scannerktp/ktp_scanner/models/recognition.dart';
import 'package:scannerktp/ktp_scanner/recognition_corection.dart';
import 'package:scannerktp/ktp_scanner/utils.dart';
import 'package:change_case/change_case.dart';
import 'package:image/image.dart' as img;

import 'data_extractor.dart';

class KtpScanner extends GetxService {
  late List<String> _labels;
  late String modelPath, labelsPath;
  final Rxn<File> imageFile = Rxn<File>();
  final Rxn<img.Image> image = Rxn<img.Image>();
  final Stopwatch stopwatch = Stopwatch();
  late DataExtactor dataExtactor;

  KtpScanner({required this.modelPath, required this.labelsPath});

  static Future<void> init() async {
    initializeDateFormatting('id');
    Get.lazyPut(() => CameraGetController());
    await Get.putAsync(() => DataExtactor().init());
    Get.lazyPut(
      () => KtpScanner(
        modelPath: "assets/model.tflite",
        labelsPath: "assets/labels.txt",
      ),
      fenix: true,
    );
  }

  Future<void> takePicture() async {
    final String path =
        (await Get.find<CameraGetController>().cameraController.takePicture())
            .path;
    image.value = await Utils.preProcessingImageHorizontal(path);
    imageFile.value =
        await File(path).writeAsBytes(img.encodeJpg(image.value!));
  }

  Future<void> scan() async {
    stopwatch.start();
    if (imageFile.value != null && image.value != null) {
      final Map<String, Recognition> temp = <String, Recognition>{};
      late Rect rect, rectOCR;
      final List responses = await Future.wait([
        Utils.firebaseMLKitCloudOcr(imageFile.value!),
        Tflite.detectObjectOnImage(
          path: imageFile.value!.path,
          threshold: 0.2,
          numResultsPerClass: 1,
          asynch: true,
        )
      ]);

      final List ocrText = responses[0];
      final List recognitions = responses[1];

      for (var i = 0; i < recognitions.length; i++) {
        if (recognitions[i]['detectedClass'] == _labels[23] ||
            recognitions[i]['detectedClass'] == _labels[12]) {
          continue;
        }
        rect = Utils.mapToRect(
          map: recognitions[i],
          offsetDx: image.value!.width,
          offsetDy: image.value!.height,
        );
        for (var j = 0; j < ocrText.length; j++) {
          rectOCR = Utils.mapToRect(map: ocrText[j]);
          if (rect.contains(rectOCR.center)) {
            if (recognitions[i]['text'] == null) {
              recognitions[i]['text'] = ocrText[j]['text'];
            } else {
              recognitions[i]['text'] += (' ${ocrText[j]['text']}');
            }
          }
        }
        temp.putIfAbsent(
            recognitions[i]['detectedClass'],
            () => Recognition.fromModelAndOcr(
                  recognitions[i],
                  image.value!,
                  _labels,
                ));
      }
      final Map<String, Recognition>? corrected =
          await Future(() => RecognitionCorection.corectionText(temp));
      final List results = await Future.wait(
        [getNikData(corrected), getKtptextData(corrected)],
      );
      Get.back<KTP>(
          result: KTP(
        nikdata: results[0],
        ktpTextData: results[1],
      ));
    }
    stopwatch.stop();
    stopwatch.reset();
  }

  Future<NIKdata?> getNikData(Map<String, Recognition>? data) async {
    if (data == null) return null;
    final String? nomorNIK = data['NIK']?.text;
    if (nomorNIK == null) return null;
    if (nomorNIK.length != 16) return null;
    final List<Object?> response = await Future.wait([
      dataExtactor.getWilayahByKode<Provinsi>(nomorNIK.substring(0, 2)), //0
      dataExtactor.getWilayahByKode<KotKab>(nomorNIK.substring(0, 4)), //1
      dataExtactor.getWilayahByKode<Kecamatan>(nomorNIK.substring(0, 6)), //2
      dataExtactor.getKelDesaByKodeKecamatanAndNama(
          nomorNIK.substring(0, 6), data['kelDesa']?.text?.toCapitalCase()) //3
    ]);
    final KodePos? kodePos = (response[3] as KelDesa?) != null &&
            (response[0] as Provinsi?) != null &&
            (response[1] as KotKab?) != null &&
            (response[2] as Kecamatan?) != null
        ? await dataExtactor.getKodePos(
            namaProvinsi: (response[0] as Provinsi?)!.nama,
            namaKotKab: (response[1] as KotKab?)!.nama,
            namaKecamatan: (response[2] as Kecamatan?)!.nama,
            namaKelDesa: (response[3] as KelDesa?)!.nama,
          )
        : null;

    int? year = int.tryParse('19${nomorNIK.substring(10, 12)}'),
        month = int.tryParse(nomorNIK.substring(8, 10)),
        days = int.tryParse(nomorNIK.substring(6, 8));
    final bool? isLaki;
    final DateTime? tanggalLahir;
    if (year != null && month != null && days != null) {
      if (DateTime.now().year - year > 90) {
        year = (year - 1900) + 2000;
      }
      if (DateTime.now().year < year) {
        year = (year - 2000) + 1900;
      }

      if (DateTime.now().year - year < 17) {
        year = null;
      }

      if (month > 12) {
        month = null;
      }

      if (days > 40) {
        days = days - 40;
        if (days > 31) {
          isLaki = null;
          days = null;
        } else {
          isLaki = false;
        }
      } else {
        if (days > 31) {
          isLaki = null;
          days = null;
        } else {
          isLaki = true;
        }
      }
      if (year != null && month != null && days != null) {
        tanggalLahir = DateTime(year, month, days);
      } else {
        tanggalLahir = null;
      }
    } else {
      isLaki = null;
      tanggalLahir = null;
    }
    return NIKdata(
      nik: nomorNIK,
      provinsi: response[0] as Provinsi?,
      kotKab: response[1] as KotKab?,
      kecamatan: response[2] as Kecamatan?,
      kelDesa: response[3] as KelDesa?,
      kodePos: kodePos,
      tanggalLahir: tanggalLahir,
      isLaki: isLaki,
      noUrut: nomorNIK.substring(nomorNIK.length - 4, nomorNIK.length),
    );
  }

  Future<KTPTextData?> getKtptextData(Map<String, Recognition>? data) async {
    if (data == null) return null;
    final DataExtactor dataExtactor = Get.find<DataExtactor>();
    final List<Object?> response = await Future.wait([
      dataExtactor.getWilayahFromQuery<KotKab>(data['tempatLahir']?.text), //0
      dataExtactor.getBestMatch(
          data['GolDarah']?.text, golDarahList, Case.upper), // 1
      dataExtactor.getBestMatch(
          data['Status']?.text, statusList, Case.capital), //2
      dataExtactor.getWilayahFromQuery<KotKab>(data['kotaDibuat']?.text), //3
      dataExtactor.getWilayahFromQuery<Provinsi>(data['judul1']?.text), //4
      dataExtactor.getWilayahFromQuery<KotKab>(data['judul2']?.text), //5
      dataExtactor.getWilayahFromQuery<Kecamatan>(data['kecamatan']?.text), //6
      dataExtactor.getWilayahFromQuery<KelDesa>(data['kelDesa']?.text), //7
      dataExtactor.getJenisKelamin(data['kelamin']?.text), //8
      dataExtactor.getBestMatch(data['agama']?.text, agamaList, Case.upper), //9
      dataExtactor.getBestMatch(
          data['kewarganegaraan']?.text, kewarganegaraanList, Case.upper), //10
      getDateTimebyRecognition(data['tanggalLahir']?.text), //11
      getDateTimebyRecognition(data['TanggalDibuat']?.text), //12
      dataExtactor.getBestMatch(
          data['pekerjaan']?.text, pekerjaanList, Case.upper) //13
    ]);

    final KodePos? kodePos = await dataExtactor.getKodePos(
      namaProvinsi: (response[4] as Provinsi?)?.nama,
      namaKotKab: (response[5] as KotKab?)?.nama,
      namaKecamatan: (response[6] as Kecamatan?)?.nama,
      namaKelDesa: (response[7] as KelDesa?)?.nama,
    );

    final String? detectedNIK = data['NIK']?.text,
        noUrut =
            detectedNIK?.substring(detectedNIK.length - 4, detectedNIK.length);

    final String? nik = await Future<String?>(() {
      if (response[4] != null &&
          response[5] != null &&
          response[6] != null &&
          response[11] != null &&
          noUrut != null) {
        final int x = (response[11] as DateTime?)!.day +
            ((response[8] as bool?)! ? 0 : 40);
        final String d = x < 10 ? '0$x' : x.toString();
        final String m = (response[11] as DateTime?)!.month < 10
            ? '0${(response[11] as DateTime?)!.month}'
            : (response[11] as DateTime?)!.month.toString();
        final String y =
            (response[11] as DateTime?)!.year.toString().substring(2, 4);
        return (response[4] as Provinsi?)!.kode +
            (response[5] as KotKab?)!.kode.substring(2, 4) +
            (response[6] as Kecamatan?)!.kode.substring(4, 6) +
            d +
            m +
            y +
            noUrut;
      } else {
        return null;
      }
    });
    late String rt, rw;
    String? rtrw = data['RT/RW']?.text;
    if (rtrw != null) {
      if (rtrw == "null") {
        rt = "";
        rw = "";
      } else {
        try {
          if (rtrw.length >= 3) {
            rt = rtrw.substring(0, 3);
            rw = rtrw.substring(rt.length, rtrw.length);
          } else {
            rt = '';
            rw = '';
          }
        } catch (e) {
          rt = '';
        }
      }
    } else {
      rt = '';
      rw = '';
    }
    return KTPTextData(
      nik: nik,
      nama: data['namaLengkap']?.text ?? '',
      tempatLahir: response[0] as KotKab?,
      golDarah: response[1] as String? ?? '',
      alamat: data['alamat']?.text ?? '',
      rt: rt,
      rw: rw,
      status: response[2] as String?,
      pekerjaan: response[13] as String?,
      kewarganegaraan: response[10] as String?,
      kotaDibuat: response[3] as KotKab?,
      noUrut: noUrut,
      kepulauan: getKepulauan((response[4] as Provinsi?)?.kode),
      provinsi: response[4] as Provinsi?,
      kotKab: response[5] as KotKab?,
      kecamatan: response[6] as Kecamatan?,
      kelDesa: response[7] as KelDesa?,
      kodePos: kodePos,
      tanggalLahir: response[11] as DateTime?,
      tanggalDibuat: response[12] as DateTime?,
      photo: data['Photo']?.croppedElement,
      ttd: data['TTD']?.croppedElement,
      isLaki: response[8] as bool?,
      agama: response[9] as String? ?? '',
      berlaku: data['Berlaku']?.text,
    );
  }

  static Future<KTP?> open({required VoidCallback onNotReady}) {
    if (Get.find<DataExtactor>().isReady) {
      return Get.to<KTP>(() => const KTPScannerScreen())!;
    } else {
      onNotReady();
      return Future.value(null);
    }
  }

  Future<DateTime?> getDateTimebyRecognition(String? value) {
    DateTime? dateTime;
    if (value != null) {
      try {
        dateTime = DateTime(
          int.parse(value.substring(4, 8)),
          int.parse(value.substring(2, 4)),
          int.parse(value.substring(0, 2)),
        );
      } catch (e) {
        dateTime = null;
      }
    } else {
      dateTime = null;
    }
    return Future.value(dateTime);
  }

  @override
  Future<void> onReady() async {
    final List response = await Future.wait([
      Tflite.loadModel(model: modelPath, labels: labelsPath),
      rootBundle.loadString(labelsPath)
    ]);
    _labels = response[1].split('\n');
    super.onReady();
  }

  @override
  void onInit() {
    dataExtactor = !Get.isRegistered<DataExtactor>()
        ? Get.put(DataExtactor(), permanent: true)
        : Get.find<DataExtactor>();
    super.onInit();
  }
}
