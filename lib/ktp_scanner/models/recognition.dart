import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class Recognition {
  late Rect rect;
  String? text, label;
  double? rectConfidence;
  Uint8List? croppedElement;

  Recognition(this.rect, this.text, this.label, this.rectConfidence,
      this.croppedElement);

  Uint8List _getCroppedElement(img.Image image, Rect rect) =>
      img.writeJpg(img.copyCrop(
        image,
        (rect.topLeft.dx * image.width).toInt(),
        (rect.topLeft.dy * image.height).toInt(),
        (rect.width * image.width).toInt(),
        (rect.height * image.height).toInt(),
      )) as Uint8List;

  static Recognition replaceText(String text, Recognition reg) {
    return Recognition(
        reg.rect, text, reg.label, reg.rectConfidence, reg.croppedElement);
  }

  Recognition.fromModelAndOcr(
      dynamic data, img.Image image, List<String> labels) {
    Rect detectedRect = Rect.fromLTWH(data["rect"]["x"], data["rect"]["y"],
        data["rect"]["w"], data["rect"]["h"]);
    croppedElement = data['detectedClass'].toString().trim() == 'Photo' ||
            data['detectedClass'].toString().trim() == 'TTD'
        ? _getCroppedElement(image, detectedRect)
        : null;
    rect = detectedRect;
    rectConfidence = data['confidenceInClass'];
    label = data['detectedClass'].toString();
    text = data['text'].toString();
  }
}
