#include "Wire.h"

//Variables
int16_t ax, ay, az, t, gx, gy, gz;
char tmp[7];
const int ADDR = 0x68;

//converts values to string
String con(int16_t i) {

  sprintf(tmp, "%d", i);
  return String(tmp); 
}

void setup() {
  
  Serial.begin(9600);
  Wire.begin();
  //Starting transmission to slave with given address (sensor)
  Wire.beginTransmission(ADDR);
  //Selects register
  Wire.write(0x6B);
  //Writes 0 to the register to wake up the sensor
  Wire.write(0);
  Wire.endTransmission(true);
}

void loop() {
  
  Wire.beginTransmission(ADDR);
  //Selecting first register with values we want to read
  Wire.write(0x3B);
  //something like a restart
  Wire.endTransmission(false);
  //requesting 14 registers (2 for each value)
  Wire.requestFrom(ADDR, 14, true);

  //Basically reads two registers and stores them in the same variable (high and low byte)
  ax = Wire.read()<<8 | Wire.read();
  ay = Wire.read()<<8 | Wire.read();
  az = Wire.read()<<8 | Wire.read();
  t = Wire.read()<<8 | Wire.read();
  gx = Wire.read()<<8 | Wire.read();
  gy = Wire.read()<<8 | Wire.read();
  gz = Wire.read()<<8 | Wire.read();

  //Printing values to serial monitor
  Serial.print("ax");
  Serial.println(con(ax));
  Serial.print("ay");
  Serial.println(con(ay));
  Serial.print("az");
  Serial.println(con(az));
  Serial.print("tm");
  Serial.println(t / 340.00 + 36.53);
  Serial.print("gx");
  Serial.println(con(gx));
  Serial.print("gy");
  Serial.println(con(gy));
  Serial.print("gz");
  Serial.println(con(gz));
  delay(500);
}
