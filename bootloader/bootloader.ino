
uint32_t numbers[] = {792725503,402653186,687865856,692060161,402653210,687865857,402653210,687865858,402653210,687865859,402653210,687865860,692060160,402653210,687865861,402653210,687865856,692060161,402653212,687865857,402653212,687865858,402653212,687865859,402653212,134217753,961032192,666894336,961024000,666894336,};

#define PIN_WRITE 6
#define PIN_DATA 7
#define PIN_START 8

void setup() {
  // put your setup code here, to run once:
  pinMode(PIN_WRITE, OUTPUT);
  pinMode(PIN_DATA, OUTPUT);
  pinMode(PIN_START, INPUT);
  digitalWrite(PIN_WRITE, LOW);
  digitalWrite(PIN_DATA, LOW);
  digitalWrite(LED_BUILTIN, LOW);
  Serial.begin(9600);
  Serial.println("hello");
}

void sendNumber(uint32_t num){
  for (int i = 0; i < 32; i++){
    digitalWrite(PIN_DATA, num & 1);
    digitalWrite(PIN_WRITE, HIGH);
    delayMicroseconds(10);
    // delay(50);
    digitalWrite(PIN_WRITE, LOW);
    // delay(50);
    delayMicroseconds(10);
    num >>= 1;
  }
  // delay(1000);
}

bool did = false;

void loop() {
  // put your main code here, to run repeatedly:
  if (digitalRead(PIN_START) && !did){
    did = true;
    Serial.println("Starting");
    digitalWrite(LED_BUILTIN, HIGH);
    int count = 0;
    for (int32_t num : numbers){
      if (!digitalRead(PIN_START)) break;
      sendNumber(num);
      count++;
    }
    while (count < 4096){
      if (!digitalRead(PIN_START)) break;
      sendNumber(0);
      count++;
    }
    
    digitalWrite(LED_BUILTIN, LOW);
    Serial.println("Done");
  }
  else if (!digitalRead(PIN_START)) {
    did = false;
  }
}
