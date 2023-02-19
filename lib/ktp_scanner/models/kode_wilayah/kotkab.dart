import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/data_extractor.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/wilayah.dart';

class KotKab extends Wilayah {
  late String kodeProvinsi;

  KotKab(String kode, String kodeProvinsi, String nama)
      : super(kode, nama, JenisWilayah.kotKab, [kodeProvinsi]);

  bool get isKota => int.parse(kode.substring(2, 3)) > 6;

  Provinsi? get provinsi => Get.find<DataExtactor>()
      .provinsiList
      .firstWhereOrNull((element) => element.kode == kodeProvinsi);

  Map<String, dynamic> get toMap => {
        'kode': kode,
        'nama': nama,
        //'kodeProvinsi': kodeProvinsi,
        'jenisWilayah': jenis.toString(),
      };

  @override
  String toString() => toMap.toString();
}
