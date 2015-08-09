import processing.serial.*; 
import java.util.Arrays; 
 
Serial myPort;    // The serial port
PFont myFont;     // The display font
int lf = 10;      // ASCII linefeed 

int[] arr = new int[800];
int pointer = 0;
int trigger = 0;
int periods = 0;
int sync = 0;
 
void setup() { 
 
  size(800,600); 
  frameRate(60);
  
  println(Serial.list()); 
  if(Serial.list().length > 0){
  myPort = new Serial(this, Serial.list()[1], 3600); 
  myPort.bufferUntil(lf); 
  }
} 
 
void draw() { 

 background(0);
  stroke(255,255);
   fill(255);
   smooth();

periods = 0;
for(int i = 1; i <800; i++){
     line(i-1,height-(arr[i-1]/10), i,height-(arr[i]/10));
if((arr[i-1]/10< height-trigger)&&(arr[i]/10 >= height-trigger)) periods++;
}
     
for(int i = 0; i <8; i++) {
  line(i*100, 0, i*100, height);
  text(str(i*100 )+ "mS", i*100,height-20);
}

for(int i = 0; i <= 3; i++) {
line(0,height-i*(4096/33), width, height-i*(4096/33));
text(str(i*1000)+ "mV", 10,height-i*(4096/33));
}

stroke(255,0,0);
line(0,trigger,width,trigger);
     
 // fill(0);
 // stroke(0);
 // rect(0,0,200,20);
 // fill(255);
    text("p "+str( (pointer))+ "num", 20,10);
    text("raw "+str( arr[pointer])+ "adc", 20,30);
    text("synk "+str(sync), 20,40);
    text("freq "+str( (1000*periods/800))+ "Hz", 200,10);
    text("trigg "+str((33000*(height-trigger))/4096 )+ "mV", 400,10);
} 


void mousePressed() {
trigger = mouseY;


}
 
void serialEvent(Serial p) { 
String s = p.readString();
if (s != null) {
if(s.equals("frame\n")) {pointer = 0; sync = 1;}
else{
 arr[pointer] = int(s.trim());
 if(++pointer >= 800) pointer = 0;
}
}
}
