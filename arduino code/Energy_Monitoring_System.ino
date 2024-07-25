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
