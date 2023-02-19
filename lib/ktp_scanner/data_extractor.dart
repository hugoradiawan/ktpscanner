import 'dart:async';

import 'package:change_case/change_case.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/constants/jenis_kelamin.dart';
import 'package:scannerktp/ktp_scanner/models/kode_pos.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/keldesa.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/wilayah.dart';
import 'package:string_similarity/string_similarity.dart';

enum Case { upper, capital }

class DataExtactor extends GetxController {
  final List<Provinsi> provinsiList = <Provinsi>[];
  final List<Kecamatan> kecamatanList = <Kecamatan>[];
  final List<KotKab> kotKabList = <KotKab>[];
  final List<KelDesa> kelDesaList = <KelDesa>[];
  final List<KodePos> kodePosList = <KodePos>[];
  bool isReady = false;

  Future<T?> getWilayahByKode<T extends Wilayah>(String? kode) => kode == null
      ? Future.value(null)
      : Future(() {
          final List<T>? targetList = getWilayahList<T>();
          return targetList
              ?.firstWhereOrNull((element) => element.kode == kode);
        });

  Future<T?> getWilayahFromQuery<T extends Wilayah>(String? query) async {
    if (query == null) return null;
    return Future(() {
      final List<T>? targetList = getWilayahList<T>();
      try {
        return targetList == null
            ? null
            : targetList[StringSimilarity.findBestMatch(query.toCapitalCase(),
                    targetList.map((element) => element.nama).toList())
                .bestMatchIndex];
      } catch (e) {
        return null;
      }
    });
  }

  Future<bool?> getJenisKelamin(String? query) async {
    if (query == null) return null;
    final BestMatch bestMatch = await Future(() =>
        StringSimilarity.findBestMatch(query.toUpperCase(), jenisKelaminList));
    return bestMatch.bestMatchIndex == 0;
  }

  List<T>? getWilayahList<T extends Wilayah>() {
    if (T == Provinsi) {
      return provinsiList as List<T>;
    } else if (T == KotKab) {
      return kotKabList as List<T>;
    } else if (T == Kecamatan) {
      return kecamatanList as List<T>;
    } else if (T == KelDesa) {
      return kelDesaList as List<T>;
    } else {
      return null;
    }
  }

  Future<String?> getBestMatch(
      String? query, List<String?> targetList, Case textCase) async {
    if (query == null) return null;
    final BestMatch bestMatch = await Future(() =>
        StringSimilarity.findBestMatch(query.textCase(textCase), targetList));
    return targetList[bestMatch.bestMatchIndex];
  }

  Future<KodePos?> getKodePos(
      {required String? namaProvinsi,
      required String? namaKotKab,
      required String? namaKecamatan,
      required String? namaKelDesa}) {
    if (namaProvinsi == null &&
        namaKotKab == null &&
        namaKecamatan == null &&
        namaKelDesa == null) {
      return Future.value(null);
    }
    return Future(() => kodePosList.firstWhereOrNull((e) {
          return e.namaProvinsi == namaProvinsi &&
              e.namaKotKab == namaKotKab &&
              e.namaKecamatan == namaKecamatan &&
              e.namaKelDesa == namaKelDesa;
        }));
  }

  Future<KelDesa?> getKelDesaByKodeKecamatanAndNama(
      String? kodeKecamatan, String? nama) async {
    if (kodeKecamatan == null) return null;
    if (nama == null) return null;
    final List<KelDesa> resultList =
        kelDesaList.where((e) => e.kodeKecamatan == kodeKecamatan).toList();
    if (resultList.isEmpty) return null;
    final BestMatch bestMatch = await Future(() =>
        StringSimilarity.findBestMatch(
            nama, resultList.map((e) => e.nama).toList()));
    return resultList[bestMatch.bestMatchIndex];
  }

  Future<void> _loadKodePos() async {
    final String assetKodeposCsv = await rootBundle.loadString(
      'assets/kodepos.csv',
    );
    final List<List> dataKodeposData =
        const CsvToListConverter(fieldDelimiter: ',', eol: '\n')
            .convert(assetKodeposCsv);
    for (int i = 1; i < dataKodeposData.length; i++) {
      kodePosList.add(
        KodePos(
          dataKodeposData[i][0],
          dataKodeposData[i][1],
          dataKodeposData[i][2],
          dataKodeposData[i][3],
          dataKodeposData[i][4].toString(),
        ),
      );
    }
  }

  Future<void> _loadKelDesaData() async {
    final String assetKelDesaCsv =
        await rootBundle.loadString('assets/villages.csv');
    final List<List> dataKelDesaData =
        const CsvToListConverter(fieldDelimiter: ';', eol: '\n')
            .convert(assetKelDesaCsv);
    for (int i = 1; i < dataKelDesaData.length; i++) {
      try {
        kelDesaList.add(
          KelDesa(
            dataKelDesaData[i][0].toString(),
            dataKelDesaData[i][1].toString(),
            dataKelDesaData[i][2].toString().toCapitalCase(),
          ),
        );
      } catch (e) {
        kelDesaList.add(
          KelDesa(
            dataKelDesaData[i][0].toString(),
            dataKelDesaData[i][1].toString(),
            dataKelDesaData[i][2].toString(),
          ),
        );
      }
    }
  }

  Future<void> _loadKecamatanData() async {
    final String assetKecamatanCsv =
        await rootBundle.loadString('assets/districts.csv');
    final List<List> dataKecamatanList =
        const CsvToListConverter(fieldDelimiter: ';', eol: '\n')
            .convert(assetKecamatanCsv);
    for (int i = 1; i < dataKecamatanList.length; i++) {
      kecamatanList.add(
        Kecamatan(
          dataKecamatanList[i][0].toString(),
          dataKecamatanList[i][1].toString(),
          dataKecamatanList[i][2].toString().toCapitalCase(),
        ),
      );
    }
  }

  Future<void> _loadKotKabData() async {
    final String assetKotKabCsv =
        await rootBundle.loadString('assets/regencies.csv');
    final List<List> dataKotKabList =
        const CsvToListConverter(fieldDelimiter: ';', eol: '\n')
            .convert(assetKotKabCsv);
    for (int i = 1; i < dataKotKabList.length; i++) {
      kotKabList.add(
        KotKab(
          dataKotKabList[i][0].toString(),
          dataKotKabList[i][1].toString(),
          dataKotKabList[i][2].toString().toCapitalCase(),
        ),
      );
    }
  }

  Future<void> _loadProvinceData() async {
    final String assetProvicesCsv =
        await rootBundle.loadString('assets/provinces.csv');
    final List<List> dataProvinsiList =
        const CsvToListConverter(fieldDelimiter: ';', eol: '\n')
            .convert(assetProvicesCsv);
    for (int i = 1; i < dataProvinsiList.length; i++) {
      provinsiList.add(
        Provinsi(
          dataProvinsiList[i][0].toString(),
          dataProvinsiList[i][1].toString().toCapitalCase(),
        ),
      );
    }
  }

  Future<DataExtactor> init() async {
    await Future.wait([
      _loadProvinceData(),
      _loadKotKabData(),
      _loadKecamatanData(),
      _loadKelDesaData(),
      _loadKodePos()
    ]);
    isReady = true;
    return this;
  }
}

extension TCase on String? {
  String? textCase(Case value) {
    if (this == null) return null;
    if (value == Case.upper) {
      return this?.toUpperCase();
    } else {
      return this?.toCapitalCase();
    }
  }
}
