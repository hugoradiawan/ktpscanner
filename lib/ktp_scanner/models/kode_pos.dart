import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/data_extractor.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/keldesa.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';

class KodePos {
  final String namaProvinsi, namaKotKab, namaKecamatan, namaKelDesa, kodePos;

  KodePos(this.namaProvinsi, this.namaKotKab, this.namaKecamatan,
      this.namaKelDesa, this.kodePos);

  Provinsi? get provinsi => Get.find<DataExtactor>()
      .provinsiList
      .firstWhereOrNull((element) => element.nama == namaProvinsi);

  KotKab? get kotKab => Get.find<DataExtactor>()
      .kotKabList
      .firstWhereOrNull((element) => element.nama == namaKotKab);

  Kecamatan? get kecamatan => Get.find<DataExtactor>()
      .kecamatanList
      .firstWhereOrNull((element) => element.nama == namaKecamatan);

  KelDesa? get kelDesa => Get.find<DataExtactor>()
      .kelDesaList
      .firstWhereOrNull((element) => element.nama == namaKelDesa);

  Map<String, dynamic> get toMap => {
        'provinsi': namaProvinsi,
        'kotKab': namaKotKab,
        'kecamatan': namaKecamatan,
        'kelDesa': namaKelDesa,
        'kodePos': kodePos,
      };

  @override
  String toString() => toMap.toString();
}
