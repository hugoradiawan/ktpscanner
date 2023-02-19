import 'dart:typed_data';

import 'package:change_case/change_case.dart';
import 'package:scannerktp/ktp_scanner/models/kode_pos.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/keldesa.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kepulauan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';
import 'package:scannerktp/ktp_scanner/models/ktp_text_data.dart';
import 'package:scannerktp/ktp_scanner/models/nik_data.dart';

class KTP {
  late String? agama,
      status,
      berlaku,
      kewarganegaraan,
      rt,
      noUrut,
      nama,
      golDarah,
      alamat,
      pekerjaan,
      rw;
  late Kepulauan? kepulauan;
  late KotKab? kotaDibuat, tempatLahir;
  late DateTime? tanggalDibuat;
  late Uint8List? photo, ttd;
  late List<String?> nik;
  late List<bool?> isLaki;
  late List<Provinsi?> provinsi;
  late List<KotKab?> kotKab;
  late List<Kecamatan?> kecamatan;
  late List<KelDesa?> kelDesa;
  late List<KodePos?> kodePos;
  late List<DateTime?> tanggalLahir;

  KTP({required NIKdata? nikdata, required KTPTextData? ktpTextData}) {
    nik = [nikdata?.nik, ktpTextData?.nik];
    nama = ktpTextData?.nama;
    tempatLahir = ktpTextData?.tempatLahir;
    golDarah = ktpTextData?.golDarah;
    alamat = ktpTextData?.alamat;
    rt = ktpTextData?.rt;
    rw = ktpTextData?.rw;
    status = ktpTextData?.status;
    pekerjaan = ktpTextData?.pekerjaan;
    kewarganegaraan = ktpTextData?.kewarganegaraan;
    kotaDibuat = ktpTextData?.kotaDibuat;
    noUrut = nikdata?.noUrut;
    kepulauan = ktpTextData?.kepulauan;
    provinsi = [nikdata?.provinsi, ktpTextData?.provinsi];
    kotKab = [nikdata?.kotKab, ktpTextData?.kotKab];
    kecamatan = [nikdata?.kecamatan, ktpTextData?.kecamatan];
    kelDesa = [nikdata?.kelDesa, ktpTextData?.kelDesa];
    kodePos = [nikdata?.kodePos, ktpTextData?.kodePos];
    tanggalLahir = [nikdata?.tanggalLahir, ktpTextData?.tanggalLahir];
    tanggalDibuat = ktpTextData?.tanggalDibuat;
    photo = ktpTextData?.photo;
    ttd = ktpTextData?.ttd;
    isLaki = [nikdata?.isLaki, ktpTextData?.isLaki];
    agama = ktpTextData?.agama;
    berlaku = ktpTextData?.berlaku;
  }

  Map<String, dynamic> get toMap => {
        'nik': nik,
        'noU': noUrut,
        'nama': nama?.toCapitalCase(),
        'temLhr': tempatLahir?.nama,
        'tglLhr': tanggalLahir.map((e) => e.toString()).toList(),
        'golDrh': golDarah,
        'sta': status,
        'kerja': pekerjaan,
        'warga': kewarganegaraan,
        'klm': isLaki,
        'agm': agama,
        'laku': berlaku,
        //'photo': photo != null ? base64Encode(photo!) : null,
        //'ttd': ttd != null ? base64Encode(ttd!) : null,
        'buatDi': kotaDibuat?.nama,
        'isDibuatKota': kotaDibuat?.isKota,
        'tglbuat': tanggalDibuat?.toString(),
        'almt': alamat,
        'pulau': kepulauan?.nama,
        'prov': provinsi.map((e) => e?.nama).toList(),
        'kotKab': kotKab.map((e) => e?.nama).toList(),
        'isKota': kotKab.map((e) => e?.isKota).toList(),
        'camat': kecamatan.map((e) => e?.nama).toList(),
        'kelDesa': kelDesa.map((e) => e?.nama).toList(),
        'isDesa': kelDesa.map((e) => e?.isDesa).toList(),
        'rt': rt != null ? int.tryParse(rt!).toString() : null,
        'rw': rw != null ? int.tryParse(rw!).toString() : null,
        'pos': kodePos.map((e) => e?.kodePos).toList(),
      };

  @override
  String toString() => toMap.toString();
}
