#define WAIT_TIME 1042
#define COM_PIN 2

void setup() {
  // put your setup code here, to run once:
  pinMode(COM_PIN, INPUT);
  Serial.begin(9600);
}



uint32_t readNum() {
  while (digitalRead(COM_PIN)) {}
  int num = 0;

  while (!digitalRead(COM_PIN)) {}
  for (int i = 0; i < 32; i++) {
    long c = micros();
    while (digitalRead(COM_PIN)) {}
    long c2 = micros();

    if (c2 - c < 75) {
      num |= 1 << i;
    }
    c = micros();
    while (!digitalRead(COM_PIN)) {}
    c2 = micros();
    if (c2 - c > 1000) break;
  }
  return num;
}

void loop() {
  // put your main code here, to run repeatedly:
  if (digitalRead(COM_PIN)) {
    int num = readNum();
    Serial.println(num);
  }
  // Serial.println(digitalRead(COM_PIN));
}
