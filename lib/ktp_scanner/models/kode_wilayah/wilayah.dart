class Wilayah {
  final String nama, kode;
  final List<String>? ibuKode;
  final JenisWilayah jenis;

  Wilayah(this.kode, this.nama, this.jenis, [this.ibuKode]);
}

enum JenisWilayah { provinsi, kotKab, kecamatan, kelDesa }
