import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status = ""; // valid, used, wrong_event, invalid_format
  String resultMessage = "";

  // Simulating a result (you can replace this with your scanner result later)
  void simulateResult(String newStatus, String message) {
    setState(() {
      status = newStatus;
      resultMessage = message;
    });
  }

  void resetScanner() {
    setState(() {
      status = "";
      resultMessage = "";
    });
  }

  Color getAlertColor(String status) {
    switch (status) {
      case 'valid':
        return Colors.green.shade50;
      case 'used':
        return Colors.yellow.shade50;
      case 'wrong_event':
      case 'invalid_format':
        return Colors.red.shade50;
      default:
        return Colors.transparent;
    }
  }

  Color getBorderColor(String status) {
    switch (status) {
      case 'valid':
        return Colors.green;
      case 'used':
        return Colors.orange;
      case 'wrong_event':
      case 'invalid_format':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  IconData getIcon(String status) {
    switch (status) {
      case 'valid':
        return Icons.check_circle_outline;
      case 'used':
        return Icons.warning_amber_outlined;
      case 'wrong_event':
      case 'invalid_format':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2FE),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎟️ Scan Ticket',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 📸 Scanner Area
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '📷 QR Scanner View',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔔 Result Message Alert
              if (resultMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: getAlertColor(status),
                    border: Border.all(color: getBorderColor(status), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        getIcon(status),
                        color: getBorderColor(status),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Result',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              resultMessage,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // 🔁 Scan Again Button
              if (resultMessage.isNotEmpty)
                ElevatedButton(
                  onPressed: resetScanner,
                  child: const Text('🔁 Scan Again'),
                ),

              const SizedBox(height: 16),

              // 🔁 Simulate Result Buttons (for testing)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        simulateResult('valid', '✅ Ticket is valid'),
                    child: const Text('Valid'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        simulateResult('used', '⚠️ Ticket already used'),
                    child: const Text('Used'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        simulateResult('wrong_event', '❌ Wrong event'),
                    child: const Text('Wrong Event'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        simulateResult('invalid_format', '❌ Invalid QR code format'),
                    child: const Text('Invalid Format'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
