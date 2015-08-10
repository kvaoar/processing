import java.util.Arrays;
float dt = 1, D = 3, V = 1, dl = 10;
int tick = 0;
int[][] q, c;
int dx = 0, dy = 0;
int A = 0;
int max_x = 100, max_y = 100;
int power = 10;
int x1 = 0, x2 = 0, y1 = 0, y2 = 0;

void setup() {
  size(600, 400);
  frameRate(60);
  
  q = new int[max_x][max_y];
  c = new int[max_x][max_y];
  dx = width/max_x;
  dy = height/max_y;
  println(dx+" "+dy);
  
  
  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.2*max_y); j < round(0.25*max_y); j++) q[i][j] = 10;
//  for( int i = round(0.15*max_x); i < round(0.2*max_x); i++) for ( int j = round(0.4*max_y); j < round(0.6*max_y); j++) q[i][j] = 100;
  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.8*max_y); j < round(0.85*max_y); j++) q[i][j] = 25;
}

void draw() {
  background(0);
  stroke(255);
  fill(255);
  if(++tick > 10) {tick = 0;};



   recalc();
 for(int i = 0; i < max_x; i++){
    for(int j = 0; j < max_y; j++){
     colorMode(HSB);
     int tmp = round(map(c[i][j], 0,A, 0,180));
     fill(180-tmp,255,255);
     stroke(180-tmp,255,200);
     rect(i*dx,j*dy,dx,dy);
     
      if(q[i][j] >0){
       colorMode(RGB);
       stroke(255,0,0,255);
       point(i*dx+dx/2, j*dy+dy/2);
       }
       
     }
  }
  
  colorMode(RGB);
  
  
  rect(10,10,10,180);
  for(int i = 0; i < 180; i++){
    colorMode(HSB);
    stroke(i,255,200);
    line(10,10+i,20,10+i);
  }
  colorMode(RGB);
  textSize(10);
  stroke(0);
  fill(0);
  text(A,20,20);
  text(0,20,190);
  if(((x1 != 0)||(y1 != 0))&&((y1 != y2)||(x1 != x2))){
      int max_x = max(x1,x2);
      int min_x = min(x1,x2);
      int max_y = max(y1,y2);
      int min_y = min(y1,y2);
      fill(255,0,0,power);
      rect(min_x,min_y,max_x-min_x,max_y-min_y);
    }
  
  
      
      fill(255,0,0,power);
      rect(mouseX,mouseY,dx,dy);
  
    stroke(255);
  fill(255);
  textSize(14);
  text("timer: "+tick,10,height-10);
 // text("max val: "+A,150,height);
  text("power: "+power,150,height-10);
  
}

void recalc(){
  
  
  for(int i = 1; i < max_x-1; i++){
    for(int j = 1; j < max_y-1; j++){
      c[i][j] += (D*(c[i-1][j]+c[i+1][j]+c[i][j-1]+c[i][j+1]-4*c[i][j])*dt/dl + V*(c[i][j] - c[i+1][j])*dt/dl + q[i][j]*dt);
      if (A < c[i][j]) A = c[i][j];
    }
  }
  

}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e <0) if (power < 250) {power+=10; }
  if(e >0) if (power > 0)  { power-=10;}
}


void mousePressed(){
  x1 = mouseX;
  y1 = mouseY;
}

void mouseDragged(){
  x2 = mouseX;
  y2 = mouseY;
}

void mouseReleased(){
  x2 = mouseX;
  y2 = mouseY;
  
  int max_x = max(x1,x2);
  int min_x = min(x1,x2);
  int max_y = max(y1,y2);
  int min_y = min(y1,y2);
  
    for( int i = round(min_x/dx); i < round(max_x/dx); i++) for ( int j = round(min_y/dy); j < round(max_y/dy); j++) q[i][j] = power;
  
  
x1 = 0; x2 = 0; y1 = 0; y2 = 0;
}
