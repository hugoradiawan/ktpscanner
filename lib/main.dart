import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scannerktp/ktp_scanner/ktp_scanner.dart';
import 'package:scannerktp/ktp_scanner/models/ktp.dart';

Future<void> main() async {
  KtpScanner.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KTP Scanner Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final KTP? result = await KtpScanner.open(
              onNotReady: () => print('KTP Scanner is Not Ready'),
            );
            print(result);
          },
          child: const Text('Open Scanner'),
        ),
      ),
    );
  }
}
