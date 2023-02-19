import 'package:scannerktp/ktp_scanner/models/kode_pos.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/keldesa.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';

class NIKdata {
  late Provinsi? provinsi;
  late KotKab? kotKab;
  late Kecamatan? kecamatan;
  late KelDesa? kelDesa;
  late KodePos? kodePos;
  late DateTime? tanggalLahir;
  late bool? isLaki;
  late String noUrut, nik;

  NIKdata(
      {required this.provinsi,
      required this.kotKab,
      required this.kecamatan,
      required this.kelDesa,
      required this.kodePos,
      required this.tanggalLahir,
      required this.isLaki,
      required this.noUrut,
      required this.nik});
}
