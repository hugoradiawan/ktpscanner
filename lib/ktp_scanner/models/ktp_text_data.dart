import 'dart:convert';
import 'dart:typed_data';

import 'package:change_case/change_case.dart';
import 'package:scannerktp/ktp_scanner/models/kode_pos.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kecamatan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/keldesa.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kepulauan.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/kotkab.dart';
import 'package:scannerktp/ktp_scanner/models/kode_wilayah/provinsi.dart';

class KTPTextData {
  late String? nik,
      agama,
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
  late Provinsi? provinsi;
  late KotKab? kotKab, kotaDibuat, tempatLahir;
  late Kecamatan? kecamatan;
  late KelDesa? kelDesa;
  late KodePos? kodePos;
  late DateTime? tanggalLahir, tanggalDibuat;
  late Uint8List? photo, ttd;
  late bool? isLaki;

  KTPTextData({
    required this.nik,
    required this.nama,
    required this.tempatLahir,
    required this.golDarah,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.status,
    required this.pekerjaan,
    required this.kewarganegaraan,
    required this.kotaDibuat,
    required this.noUrut,
    required this.kepulauan,
    required this.provinsi,
    required this.kotKab,
    required this.kecamatan,
    required this.kelDesa,
    required this.kodePos,
    required this.tanggalLahir,
    required this.tanggalDibuat,
    required this.photo,
    required this.ttd,
    required this.isLaki,
    required this.agama,
    required this.berlaku,
  });

  Map<String, dynamic> get toMap => {
        'nik': nik,
        'noU': noUrut,
        'nama': nama?.toCapitalCase(),
        'temLhr': tempatLahir?.nama,
        'tglLhr': tanggalLahir?.toString(),
        'golDrh': golDarah,
        'sta': status,
        'kerja': pekerjaan,
        'warga': kewarganegaraan,
        'klm': isLaki,
        'agm': agama,
        'laku': berlaku,
        'photo': photo != null ? base64Encode(photo!) : null,
        'ttd': ttd != null ? base64Encode(ttd!) : null,
        'buatDi': kotaDibuat?.nama,
        'isDibuatKota': kotaDibuat?.isKota,
        'tglbuat': tanggalDibuat?.toString(),
        'almt': alamat,
        'pulau': kepulauan?.nama,
        'prov': provinsi?.nama,
        'kota': kotKab?.nama,
        'isKota': kotKab?.isKota,
        'camat': kecamatan?.nama,
        'desa': kelDesa?.nama,
        'isDesa': kelDesa?.isDesa,
        'rt': rt != null ? int.tryParse(rt!).toString() : null,
        'rw': rw != null ? int.tryParse(rw!).toString() : null,
        'pos': kodePos?.kodePos,
      };
}

/* (alamat ?? '').toCapitalCase() +
            ', RT.' +
            int.tryParse(rt!).toString() +
            '/RW.' +
            int.tryParse(rw!).toString() +
            ', ' +
            (kelDesa!.isDesa ? 'Desa ' : 'Kelurahan ') +
            (kelDesa?.nama ?? '') +
            ', Kec. ' +
            (kecamatan?.nama ?? '') +
            ', ' +
            (kotKab!.isKota ? 'Kota ' : 'Kabupaten ') +
            (kotKab?.nama ?? '') +
            ', ' +
            (provinsi?.nama ?? '') +
            ' ' +
            (kodePos?.kodePos ?? '') */