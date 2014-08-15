// constants
// pin numbers:
const byte sensorStart = 2;
const byte sensorEnd = 3;

// variables will change:
byte sensorStartState = 0;
byte sensorEndState = 0;

void setup() {
  pinMode(sensorStart, INPUT);  
  pinMode(sensorEnd, INPUT);
  Serial.begin(9600);
}

void loop(){
  sensorStartState = digitalRead(sensorStart);
  sensorEndState = digitalRead(sensorEnd);
  
  /*
  Serial.print("S");
  Serial.println(sensorStartState);
  Serial.print("E");
  Serial.println(sensorEndState);
  */
  
  // alternative setup
  
  if (sensorStartState == HIGH) {
    Serial.print("1\n");
    delay(5250);
  }
  if (sensorEndState == HIGH) {
    Serial.print("2\n");
    delay(5250);
  }
}
