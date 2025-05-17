import 'package:data_forms/core/form_style.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  final ValueSetter<Barcode> callback;

  const QrScannerScreen({required this.callback, super.key});

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('QR scanner', style: FormStyle().titleTextStyle),
        leading: SizedBox(
          width: 20,
          height: 20,
          child: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black54),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Expanded(
        flex: 4,
        child: MobileScanner(
          onDetect: (barcodeCapture) {
            final List<Barcode> barcodes = barcodeCapture.barcodes;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
              setState(() {
                qrText = barcode.rawValue ?? 'Failed to scan';
                widget.callback(barcode);
              });
            }
          },
        ),
      ),
    );
  }
}
