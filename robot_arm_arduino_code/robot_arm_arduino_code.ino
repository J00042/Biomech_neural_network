#include <Servo.h>
#include <String.h>

Servo thumb, pointer, middle, ring, little, wristUD, wristLR, wristRot;
int start = 1;
String serialStringIn;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("setup");
  thumb.attach(2);    //0 = fully open (i.e. wave), 180 = fully closed (i.e. fist)
  pointer.attach(3);  //0 = fully open (i.e. wave), 180 = fully closed (i.e. fist)
  middle.attach(4);   //0 = fully open (i.e. wave), 180 = fully closed (i.e. fist)
  ring.attach(5);     //0 = fully open (i.e. wave), 180 = fully closed (i.e. fist)
  little.attach(6);   //0 = fully open (i.e. wave), 180 = fully closed (i.e. fist)
  wristUD.attach(7);  //90 = straight, 0 = tilt back/down, 180 = tilt forwards (i.e. palm towards lower side of wrist)
  wristLR.attach(8);  //90 = stright, 0 = tilt left (where palm faces up), 180 = tilt right.
  wristRot.attach(9); //90 = sideways, 0 = palm facing down, 180 = back facing down.
}
       //180045045045045090090090
//string 000000000000000090090090
//means  000 000 000 000 000 090 090
//means thumb(0) pointer(0) middle(0) ring(0) little(0) wristUD(90) wristLR(90) wristRot(90)
void loop() {
  // put your main code here, to run repeatedly:
  if(start){ 
    Serial.println("loop");
    start = 0;
  }
  if (Serial.available() > 0) {
    serialStringIn = Serial.readString();
    Serial.setTimeout(10);
    thumb.write(180-serialStringIn.substring(0,3).toInt());
    pointer.write(serialStringIn.substring(3,6).toInt());
    middle.write(serialStringIn.substring(6,9).toInt());
    ring.write(serialStringIn.substring(9,12).toInt());
    little.write(serialStringIn.substring(12,15).toInt());
    wristUD.write(serialStringIn.substring(15,18).toInt());
    wristLR.write(serialStringIn.substring(18,21).toInt());
    wristRot.write(serialStringIn.substring(21,24).toInt());
    Serial.println("r");
  }
}
