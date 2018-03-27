import processing.serial.*;

/*
 * Reads data from the gyroscope and displays each axis as a line graph
 */

Serial s;
int c = 0;
//To store last points
PVector lgx, lgy, lgz;
//for thickness of lines and points
int thick = 2;
//Timestamp for folder
String ts;

void setup() {
  
  size(800, 800);
  background(255);
  strokeWeight(thick);
  ts = Integer.toString(year()) + Integer.toString(month()) + Integer.toString(day()) + Integer.toString(hour()) + Integer.toString(minute()) + Integer.toString(second());
  File f = new File(ts);
  f.mkdir();
  //basically establishing the connection to the Arduino
  s = new Serial(this, Serial.list()[0], 9600);
  //defining last points
  lgx = new PVector(-1, height/2);
  lgy = new PVector(-1, height/2 + thick);
  lgz = new PVector(-1, height/2 + 2 * thick);
  
  //to eliminate some buggy values that sometimes are sent by the arduino
  do {
  
    s.readStringUntil(10);
    fill(0);
    rect(width/4, height/4, width/8, height/8);
  } while (s.available() < 1);
  
  background(255);
  s.clear();
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
    
    if (in != null && in.length() > 3) {
    
      Data tmp = format(in);
      float tz;
      
      if (tmp.type.equals("gx")) {
        
        stroke(255, 0, 0);
        point(c, (tz = map(tmp.val, -32768, 32768, 0, height)));
        line(lgx.x, lgx.y, c, tz);
        lgx = new PVector(c, tz);
      }
      
      if (tmp.type.equals("gy")) {

        stroke(0, 255, 0);
        point(c, (tz = map(tmp.val, -32768, 32768, 0, height) + thick));
        line(lgy.x, lgy.y, c, tz);
        lgy = new PVector(c, tz);
      }
      
      if (tmp.type.equals("gz")) {

        stroke(0, 0, 255);
        point(c, (tz = map(tmp.val, -32768, 32768, 0, height) + 2 * thick));
        line(lgz.x, lgz.y, c, tz);
        lgz = new PVector(c, tz);
        c++;
      }
      
      if (c > width) {
      
        saveFrame(ts + "/gyrodat-######.tif");
        background(255);
        c = 0;
        lgx = new PVector(-1, height/2);
        lgy = new PVector(-1, height/2 + thick);
        lgz = new PVector(-1, height/2 + 2 * thick);
      }
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