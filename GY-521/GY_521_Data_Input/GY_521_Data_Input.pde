import processing.serial.*;

Serial s;

void setup() {
  
  //basically establishing the connection to the Arduino
  s = new Serial(this, Serial.list()[0], 9600);
}

/*
 * Converts data from serial input to a Data object
 */

Data format(String s) {
  
  char[] str = s.toCharArray();
  String tt = Character.toString(str[0]) + Character.toString(str[1]);
  
  String tv = "";
  
  for (int i = 2; i < str.length - 1; i++) {
    
    tv += Character.toString(str[i]);
  }
  
  return new Data(Float.parseFloat(tv), tt);
}

void draw() {
  
  //if connection is working
  if (s.available() > 0) {
  
    //10 is ASCII for \n, reads until newline and stores this
    String in = s.readStringUntil(10);
    
    if (in != null) {
    
      println(format(in).toString());
    }
  }
}

class Data {

  float val;
  String type;
  
  Data(float v, String t) {
  
    val = v;
    type = t;
  }
  
  String toString() {
  
    return ("\n\ntype: " + type + "\nvalue: " + val);
  }
}