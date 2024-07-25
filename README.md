# Energy Monitoring System

## Description
This project aims to monitor the energy consumption of household appliances and optimize their usage. The system uses an Arduino microcontroller, a current sensor (ACS712), a Wi-Fi module, and a smartphone or web dashboard to visualize the energy consumption data.

## Components Needed
- Arduino
- Current Sensor (ACS712)
- Wi-Fi Module (ESP8266 or similar)
- Smartphone or Web Dashboard
- Breadboard and Jumper Wires
- Resistors and Capacitors (as required)
- Power Supply

## Hardware Setup
1. **Connect the ACS712 Current Sensor to the Arduino:**
   - Vcc to 5V on Arduino
   - GND to GND on Arduino
   - Output to an analog input pin on Arduino (e.g., A0)

2. **Connect the ESP8266 Wi-Fi Module:**
   - Vcc and CH_PD to 3.3V on Arduino
   - GND to GND on Arduino
   - TX to RX (pin 0) on Arduino
   - RX to TX (pin 1) on Arduino

3. **Power the Arduino:**
   - Connect your Arduino to your computer using a USB cable for power and programming.

## Arduino Code
Upload the following code to your Arduino:

```cpp
#include <ESP8266WiFi.h>

const char* ssid = "your_SSID";
const char* password = "your_PASSWORD";
const char* server = "your_server_address";

WiFiClient client;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("WiFi connected");
}

void loop() {
  int sensorValue = analogRead(A0);
  float voltage = sensorValue * (5.0 / 1023.0);
  float current = (voltage - 2.5) / 0.185; // For ACS712 5A model

  if (client.connect(server, 80)) {
    client.print("GET /update?current=");
    client.print(current);
    client.println(" HTTP/1.1");
    client.println("Host: your_server_address");
    client.println("Connection: close");
    client.println();
    client.stop();
  }

  delay(2000);
}
```

## Server Setup
1. **Set Up a Server:**
   - You can use a service like Thingspeak, or set up your own server using a Raspberry Pi, AWS, or any other hosting service.

2. **Create an Endpoint:**
   - Create an endpoint to receive the data sent from the Arduino. Ensure the endpoint processes the incoming data and stores it in a database.

## Dashboard
### Web Dashboard
1. **Create a Web Interface:**
   - Use HTML, CSS, and JavaScript to create a web dashboard.
   - Use a charting library like Chart.js or Google Charts to visualize the data.

2. **Fetch and Display Data:**
   - Fetch the data from your server and display it on the dashboard.

### Smartphone App
1. **Set Up a New Flutter Project:**
   - Use the following code as a starting point for your Flutter app:

```dart
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
```

## Usage
1. **Upload the Arduino Code:**
   - Upload the provided Arduino code to your Arduino board.

2. **Set Up the Server:**
   - Set up and configure your server to receive and store data.

3. **Run the Web Dashboard or Smartphone App:**
   - Access your web dashboard or run your smartphone app to visualize the energy consumption data.

## Contributing
Feel free to submit issues or pull requests if you have any improvements or bug fixes.


---

