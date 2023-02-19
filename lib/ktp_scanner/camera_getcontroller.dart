import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CameraGetController extends GetxController {
  late CameraController cameraController;
  late List<CameraDescription> cameraDescriptionList;
  final RxBool isCameraReady = RxBool(false);

  @override
  Future<void> onReady() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    cameraDescriptionList = await availableCameras();
    cameraController = CameraController(cameraDescriptionList[0], ResolutionPreset.max,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
    await cameraController.initialize();
    isCameraReady.value = true;
    super.onReady();
  }

  @override
  void onClose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    cameraController.dispose();
    super.onClose();
  }
}
