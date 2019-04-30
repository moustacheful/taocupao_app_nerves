int analogPins[] = {0, 1, 2, 3};
String delimiter = "\r\n";
String separator = ":";
void setup() {
  Serial.begin(115200);
}

void loop() {
  for (int i = 0; i < sizeof(analogPins) / 2; i++) {
    int pin = analogPins[i];
    int val = analogRead(pin);

    Serial.print(pin + separator + val + delimiter);
  }
  delay(1000);
}
