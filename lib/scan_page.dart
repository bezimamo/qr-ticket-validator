import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String result = '';
  String status = '';
  bool scanning = true;

  final Map<String, Color> alertColors = {
    'valid': Colors.green,
    'used': Colors.orange,
    'wrong_event': Colors.red,
    'invalid_format': Colors.red,
  };

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!scanning) return;
      setState(() {
        scanning = false;
      });

      final decodedText = scanData.code;
      final parts = decodedText?.split(":");

      if (parts == null || parts.length != 2) {
        setState(() {
          result = "❌ Invalid QR code format";
          status = "invalid_format";
        });
        return;
      }

      final ticketId = parts[0];
      final eventId = parts[1];

      try {
        final response = await http.get(
          Uri.parse(
              'https://eventify-pi.vercel.app/api/validate?ticketId=$ticketId&eventId=$eventId'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final respStatus = data['status'];

          setState(() {
            status = respStatus;
            if (respStatus == "valid") {
              result = "✅ Ticket is valid";
            } else if (respStatus == "used") {
              result = "⚠️ Ticket already used";
            } else if (respStatus == "wrong_event") {
              result = "❌ Wrong event";
            } else {
              result = "❌ Invalid ticket";
              status = "invalid_format";
            }
          });
        } else {
          setState(() {
            result = "❌ Server error: ${response.statusCode}";
            status = "invalid_format";
          });
        }
      } catch (e) {
        setState(() {
          result = "❌ Error: $e";
          status = "invalid_format";
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void restartScan() {
    setState(() {
      scanning = true;
      result = '';
      status = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "🎟️ Scan Ticket",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (result.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: alertColors[status]?.withOpacity(0.1),
                          border: Border.all(color: alertColors[status]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                result,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: alertColors[status],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!scanning)
                      ElevatedButton.icon(
                        onPressed: restartScan,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text("Scan Again"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
