import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CallLogsPage(),
    );
  }
}

class CallLogsPage extends StatefulWidget {
  const CallLogsPage({super.key});

  @override
  _CallLogsPageState createState() => _CallLogsPageState();
}

class _CallLogsPageState extends State<CallLogsPage> {
  static const platform = MethodChannel('com.example.call_logs/call_logs');

  List<Object?> _callLogsList = [];

  void _getCallLogs() async {
    try {
      final List<Object?> result = await platform.invokeMethod('getCallLogs');
      setState(() {
        _callLogsList = result;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logs retrieved"),
            backgroundColor: Colors.red,
          ),
        );
      });
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCallLogs();
  }

  String _formatCallLog(String d) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(d));
    String formattedDate =
        '${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Logs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Padding for the whole body
        child: ListView(
          children: _callLogsList.map((e) {
            return Card(
              elevation: 4, // Add a shadow effect to the card
              margin: const EdgeInsets.symmetric(
                  vertical: 8), // Margin between items
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)), // Rounded corners
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number: ${(e as Map)['number']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Name: ${(e)['name']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Location: ${(e)['location']}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6), // Space between Text widgets
                    Text(
                      'Type: ${e['type']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Date: ${_formatCallLog(e['date'])}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Duration: ${e['duration']} seconds',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12), // Extra space before Divider
                    Divider(), // Divider between each call log
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
