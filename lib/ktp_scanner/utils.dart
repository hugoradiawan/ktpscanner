import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

class Utils {
  static DateTime stringToDateTime(String date) {
    final List<String> temp = date.split(" ");
    const List<String> monthNames = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return DateTime(
        int.parse(temp[2]),
        monthNames.indexWhere((element) => element == temp[1]) + 1,
        int.parse(temp[0]));
  }

  static Rect mapToRect(
      {required dynamic map, int offsetDx = 1, int offsetDy = 1}) {
    return Rect.fromLTWH(
      map["rect"]["x"] * offsetDx,
      map["rect"]["y"] * offsetDy,
      map["rect"]["w"] * offsetDx,
      map["rect"]["h"] * offsetDy,
    );
  }

  static Future<List> firebaseMLKitCloudOcr(File file) async {
    final List ocrText = [];
    final InputImage visionImage = InputImage.fromFile(file);
    final TextRecognizer textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText visionText =
        await textRecognizer.processImage(visionImage);
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          if (element.text.isEmpty ||
              element.text == '' ||
              element.text == ' ' ||
              element.text == 'null') continue;
          final Rect boundingBox = element.boundingBox;
          String text = element.text.trim().startsWith(':')
              ? element.text.replaceAll(':', '')
              : element.text;
          text = element.text.trim().endsWith(',')
              ? element.text.replaceAll(',', '')
              : text;
          Map<String, Object> data = {
            "rect": {
              "x": boundingBox.topLeft.dx,
              "y": boundingBox.topLeft.dy,
              "w": boundingBox.width,
              "h": boundingBox.height
            },
            "text": text,
          };
          ocrText.add(data);
        }
      }
    }
    return ocrText;
  }

  static Future<img.Image> preProcessingImageHorizontal(String path) async {
    final File rotatedImage = await FlutterExifRotation.rotateImage(path: path);
    final Uint8List data = await rotatedImage.readAsBytes();
    final img.Image image = img.decodeJpg(data)!;
    final int xCoordinate = ((image.width - (image.width * 0.92)) / 2).round();
    return img.copyCrop(
      image,
      xCoordinate,
      0,
      (image.width * 0.92).round(),
      image.height,
    );
  }
}
