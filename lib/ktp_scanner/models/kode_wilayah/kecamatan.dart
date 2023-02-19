import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/data_extractor.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/wilayah.dart';

class Kecamatan extends Wilayah {
  late String kodeKotKab;

  Kecamatan(String kode, this.kodeKotKab, String nama)
      : super(kode, nama, JenisWilayah.kecamatan, [kodeKotKab]);

  KotKab? get kotKab => Get.find<DataExtactor>()
      .kotKabList
      .firstWhereOrNull((element) => element.kode == kodeKotKab);

  Map<String, dynamic> get toMap => {
        'kode': kode,
        'nama': nama,
        'kodeKotKab': kodeKotKab,
        'jenisWilayah': jenis.toString(),
      };

  @override
  String toString() => toMap.toString();
}
