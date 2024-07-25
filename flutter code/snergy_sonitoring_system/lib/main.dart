import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EnergyMonitor(),
    );
  }
}

class EnergyMonitor extends StatefulWidget {
  @override
  _EnergyMonitorState createState() => _EnergyMonitorState();
}

class _EnergyMonitorState extends State<EnergyMonitor> {
  double current = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final response = await http.get(Uri.parse('http://your_server_address/data'));
    if (response.statusCode == 200) {
      setState(() {
        current = json.decode(response.body)['current'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Monitoring System'),
      ),
      body: Center(
        child: Text(
          'Current Consumption: $current A',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
