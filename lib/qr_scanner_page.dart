import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'result_page.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool _isProcessing = false;  // Flag to prevent multiple navigations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          if (_isProcessing) return;  // Skip if already navigating

          final barcode = barcodeCapture.barcodes.first;
          final code = barcode.rawValue;

          if (code != null) {
            _isProcessing = true; // Set flag

            // Navigate and after return reset the flag
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(ticketData: code),
              ),
            ).then((_) {
              // Reset flag to allow scanning again when back
              _isProcessing = false;
            });
          }
        },
      ),
    );
  }
}
