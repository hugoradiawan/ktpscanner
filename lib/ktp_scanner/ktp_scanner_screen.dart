import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/camera_getcontroller.dart';
import 'package:scannerktp/ktp_scanner/ktp_scanner.dart';

class KTPScannerScreen extends GetView<KtpScanner> {
  const KTPScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.grey[200],
        systemNavigationBarColor: Colors.grey[200],
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey[200],
        systemNavigationBarIconBrightness: Brightness.dark));
    final CameraGetController cameraGetController =
        Get.find<CameraGetController>();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Row(children: [
          Flexible(
            flex: 3,
            child: Center(
              child: Obx(
                () => controller.imageFile.value == null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          child: cameraGetController.isCameraReady.value
                              ? Stack(alignment: Alignment.center, children: [
                                  InkWell(
                                    onTap: () => controller.takePicture(),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        heightFactor: 1,
                                        widthFactor: 0.92,
                                        child: CameraPreview(
                                          cameraGetController.cameraController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ])
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 1,
                          widthFactor: 0.92,
                          child: Image.file(controller.imageFile.value!),
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        InkWell(
                          onTap: () async {
                            await controller.takePicture();
                            return controller.scan();
                          },
                          child: const SizedBox(
                            width: 70,
                            height: 70,
                            child: CircleAvatar(
                              child: Icon(
                                Icons.send_to_mobile,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Scan KTP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            'Contoh Pegambilan foto KTP\n'
                            'Pastikan untuk memberikan sedikit ruang pada saat memfoto KTP dan Semua tulisan terbaca jelas',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              child: Image.asset('assets/ck.png'),
                            ),
                          ),
                        )
                      ]),
                    ),
                  )
                ]),
          )
        ]),
      ),
    );
  }
}
