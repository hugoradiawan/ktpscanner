import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/data_extractor.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/wilayah.dart';

class KelDesa extends Wilayah {
  late String kodeKecamatan;

  KelDesa(String kode, this.kodeKecamatan, String nama)
      : super(kode, nama, JenisWilayah.kelDesa, [kodeKecamatan]);

  bool get isDesa => kode.substring(5, 6) == '2';

  Kecamatan? get kecamatan => Get.find<DataExtactor>()
      .kecamatanList
      .firstWhereOrNull((element) => element.kode == kodeKecamatan);

  Map<String, dynamic> get toMap => {
        'kode': kode,
        'nama': nama,
        'kodeKecamatan': kodeKecamatan,
        'jenisWilayah': jenis.toString(),
      };

  @override
  String toString() => toMap.toString();
}
