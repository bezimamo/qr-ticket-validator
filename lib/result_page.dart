import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ResultPage extends StatelessWidget {
  final String ticketData;

const ResultPage({super.key, required this.ticketData});

Future<String> validateTicket(String ticketId, String eventId) async {
  final functions = FirebaseFunctions.instance;

  // Use local emulator at localhost:5001
  functions.useFunctionsEmulator('localhost', 5001);

  final callable = functions.httpsCallable('validateTicket');
  final result = await callable.call({'ticketId': ticketId, 'eventId': eventId});
  return result.data['status'];
}

  @override
  Widget build(BuildContext context) {
    final parts = ticketData.split(':');
    final ticketId = parts[0];
    final eventId = parts.length > 1 ? parts[1] : 'defaultEvent';

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Result')),
      body: FutureBuilder<String>(
        future: validateTicket(ticketId, eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final status = snapshot.data!;
          String message;
          if (status == 'valid') {
            message = '✅ Ticket is Valid!';
          } else if (status == 'used') {
            message = '⚠️ Already Used';
          } else {
            message = '❌ Invalid Ticket';
          }

          return Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}
