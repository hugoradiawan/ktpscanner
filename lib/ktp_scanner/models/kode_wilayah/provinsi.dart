import 'package:scannerktp/ktp_scanner/constants/kepulauan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kepulauan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/wilayah.dart';

class Provinsi extends Wilayah {
  Provinsi(String kode, String nama)
      : super(kode, nama, JenisWilayah.provinsi, getKepulauan(kode)?.kode);

  Map<String, dynamic> get toMap => {
        'kode': kode,
        'nama': nama,
        'jenisWilayah': jenis.toString(),
      };

  @override
  String toString() => toMap.toString();
}

Kepulauan? getKepulauan(String? kode) {
  if (kode == null) return null;
  for (var i = 0; i < kepulauanList.length; i++) {
    for (var j = 0; j < kepulauanList[i].kode.length; j++) {
      if (kepulauanList[i].kode[j] == kode.substring(0, 1)) {
        return kepulauanList[i];
      }
    }
  }
  return null;
}
