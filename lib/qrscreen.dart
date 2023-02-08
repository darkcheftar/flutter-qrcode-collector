import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QRScanner extends StatelessWidget {
  const QRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: MobileScanner(
        allowDuplicates: false,
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (barcode, args) {
          try {
            if (barcode.rawValue == null) {
              Navigator.pop(context, 'Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              Navigator.pop(context, code);
            }
          } on Exception catch (e) {
            Navigator.pop(context, 'Some error occured');
          }
        },
      ),
    );
  }
}

