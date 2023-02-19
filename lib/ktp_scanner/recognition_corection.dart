import 'package:scannerktp/ktp_scanner/models/recognition.dart';

class RecognitionCorection {
  static Map<String, Recognition>? corectionText(
      Map<String, Recognition>? data) {
    if (data == null) return null;
    List<MapEntry<String, Recognition>> temp = data.entries.toList();
    for (int i = 0; i < temp.length; i++) {
      if (temp[i].key == 'NIK') {
        if (temp[i].value.text!.contains('l')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('l', '1'), temp[i].value));
        }
        if (temp[i].value.text!.contains('E')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('E', '6'), temp[i].value));
        }
        if (temp[i].value.text!.contains('J')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('J', '3'), temp[i].value));
        }
        if (temp[i].value.text!.contains('L')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('L', '6'), temp[i].value));
        }
        if (temp[i].value.text!.contains('B')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('B', '3'), temp[i].value));
        }
        if (temp[i].value.text!.contains('b')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('b', '3'), temp[i].value));
        }
        if (temp[i].value.text!.contains('D')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('D', '0'), temp[i].value));
        }
        if (temp[i].value.text!.contains('O')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('O', '0'), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains(' ')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(' ', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'RT/RW') {
        if (temp[i].value.text!.contains('D')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('D', '0'), temp[i].value));
        }
        if (temp[i].value.text!.contains('O')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('O', '0'), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('/')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('/', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'tempatLahir') {
        if (temp[i].value.text!.contains('WONOGIAI')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('WONOGIAI', 'WONOGIRI'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].value.label == 'agama') {
        if (temp[i].value.text!.contains('1')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('1', 'I'), temp[i].value));
        }
        if (temp[i].value.text == 'IS AM') {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key, Recognition.replaceText('ISLAM', temp[i].value));
        }
        if (temp[i].value.text!.contains('SL AM')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('SL AM', 'SLAM'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].value.label == 'kewarganegaraan') {
        if (temp[i].value.text!.contains('E')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('E', 'I'), temp[i].value));
        }
        if (temp[i].value.text!.contains('II')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('II', 'I'), temp[i].value));
        }

        if (temp[i].value.text == 'WN' || temp[i].value.text == 'NI') {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key, Recognition.replaceText('WNI', temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].value.label == 'kecamatan') {
        if (temp[i].value.text!.contains('KIATEN')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('KIATEN', 'KLATEN'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains('KL ATEN')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('KL ATEN', 'KLATEN'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('CPUTAT')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('CPUTAT', 'CIPUTAT'),
                  temp[i].value));
        }
      }
      if (temp[i].value.label == 'tanggalLahir') {
        if (temp[i].value.text!.contains(' ')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(' ', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('-')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('-', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('H')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('H', '1'), temp[i].value));
        }
        if (temp[i].value.text!.contains('.')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('.', ''), temp[i].value));
        }
      }

      if (temp[i].value.label == 'TanggalDibuat') {
        if (temp[i].value.text!.contains(' ')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(' ', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('-')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('-', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('.')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('.', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('e')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('e', '0'), temp[i].value));
        }
      }
      if (temp[i].key == 'kelamin') {
        if (temp[i].value.text!.contains('LAK') ||
            temp[i].value.text!.contains('LAKL') ||
            temp[i].value.text!.contains('LAKA') ||
            temp[i].value.text!.contains('AKI')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key, Recognition.replaceText('LAKI-LAKI', temp[i].value));
        }
        if (temp[i].value.text!.contains('L')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key, Recognition.replaceText('LAKI-LAKI', temp[i].value));
        }
        if ('K'.allMatches(temp[i].value.text!).length == 2) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key, Recognition.replaceText('LAKI-LAKI', temp[i].value));
        }
        if (temp[i].value.text!.contains('P')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key, Recognition.replaceText('PEREMPUAN', temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'RT/RW') {
        if (temp[i].value.text!.contains('O')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('O', '0'), temp[i].value));
        }
        if (temp[i].value.text!.contains('D')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('D', '0'), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('-')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('-', ''), temp[i].value));
        }
        if (temp[i].value.text!.contains('/')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('/', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'Berlaku') {
        if (temp[i].value.text!.contains('HIDUF')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('HIDUF', 'HIDUP'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains('HIDUP')) {
          temp[i] = MapEntry<String, Recognition>(temp[i].key,
              Recognition.replaceText('SEUMUR HIDUP', temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'pekerjaan') {
        if (temp[i].value.text!.contains('JARMAHA')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('JARMAHA', 'JAR/MAHA'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains('MAHASISWA')) {
          temp[i] = MapEntry<String, Recognition>(temp[i].key,
              Recognition.replaceText('PELAJAR/MAHASISWA', temp[i].value));
        }
        if (temp[i].value.text!.contains('PELAJAR')) {
          temp[i] = MapEntry<String, Recognition>(temp[i].key,
              Recognition.replaceText('PELAJAR/MAHASISWA', temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'namaLengkap') {
        if (temp[i].value.text!.contains('SATRA')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('SATRA', 'SATRIA'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains('Ų')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('Ų', 'U'), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'alamat') {
        if (!temp[i].value.text!.contains('JL.')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('JL', 'JL.'), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'judul2') {
        if (temp[i].value.text!.contains('SEL ATAN')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('SEL ATAN', 'SELATAN'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains('KABUPATLN')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('KABUPATLN', 'KABUPATEN'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'judul1') {
        if (temp[i].value.text!.contains('BAN TEN')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('BAN TEN', 'BANTEN'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
      if (temp[i].key == 'Status') {
        if (temp[i].value.text!.contains('UMK')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('UMK', 'UM K'),
                  temp[i].value));
        }
        if (temp[i].value.text!.contains('AVW')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll('AVW', 'AW'), temp[i].value));
        }
        if (temp[i].value.text!.contains(':')) {
          temp[i] = MapEntry<String, Recognition>(
              temp[i].key,
              Recognition.replaceText(
                  temp[i].value.text!.replaceAll(':', ''), temp[i].value));
        }
      }
    }
    return Map<String, Recognition>.fromEntries(temp);
  }
}
