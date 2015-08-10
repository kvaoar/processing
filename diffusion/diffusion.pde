import java.util.Arrays;
float dt = 1, D = 3, V = 1, dl = 10;
int tick = 0;
float[][] q, c;
int dx = 0, dy = 0;
float A = 0;
int max_x = 120, max_y = 100;
int power = 10;
int x1 = 0, x2 = 0, y1 = 0, y2 = 0;
  
PFont font ;

void setup() {
  size(600, 420);
  frameRate(10);
 //smooth();
  q = new float[max_x][max_y];
  c = new float[max_x][max_y];
  dx = width/max_x;
  dy = height/max_y;
  println(dx+" "+dy);
  font = createFont("Consolas", 48);
  
  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.2*max_y); j < round(0.25*max_y); j++) q[i][j] = 10;
//  for( int i = round(0.15*max_x); i < round(0.2*max_x); i++) for ( int j = round(0.4*max_y); j < round(0.6*max_y); j++) q[i][j] = 100;
  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.8*max_y); j < round(0.85*max_y); j++) q[i][j] = 25;
}

void draw() {
  if(++tick > 60) {tick = 0;    };
  recalc();
    colorMode(RGB);
    background(0,0,255);
    stroke(0);
    fill(0,0,255);

 for(int i = 1; i < max_x-1; i++){
    for(int j = 1; j < max_y-1; j++){
       
       colorMode(HSB);
       fill(180-map(c[i][j],0,A,0,180),255,255);
       stroke(180-map(c[i][j],0,A,0,180),200,255);
       rect(i*dx,j*dy,dx,dy);
       
      
      if(q[i][j] >0){
       colorMode(RGB);
       stroke(255,0,0,255);
       point(i*dx+dx/2, j*dy+dy/2);
       }
       
    }
  }
  
  

 /* colorMode(RGB);
  rect(10,10,10,180);
  for(int i = 0; i < 180; i++){
    colorMode(HSB);
    stroke(i,255,200);
    line(10,10+i,20,10+i);
  }
  colorMode(RGB);
  textFont(font, 16);
  stroke(0);
  fill(0);
  text(A,20,20);
  text(0,20,190);*/
  /*
  if(((x1 != 0)||(y1 != 0))&&((y1 != y2)||(x1 != x2))){
      int max_x = max(x1,x2);
      int min_x = min(x1,x2);
      int max_y = max(y1,y2);
      int min_y = min(y1,y2);
      fill(255,0,0,power);
      rect(min_x,min_y,max_x-min_x,max_y-min_y);
    }
  */
  
      
   /*   fill(255,0,0,power);
      rect(mouseX,mouseY,dx,dy);
  */
    stroke(255);
  fill(0);
  textFont(font, 20);
  text("timer: "+tick,10,height-10);
  text("power: "+power,150,height-10);
    text("max val: "+A,300,height-10);

}



void recalc(){
  A = 0;
  
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
  int maxx = min(max(x1,x2),max_x*dx-1)/dx ;
  int minx = max(min(x1,x2), 1)/dx;
  int maxy = min(max(y1,y2),max_y*dy-1)/dy;
  int miny = max(min(y1,y2), 1)/dy;
  for( int i = minx; i < maxx; i++) for ( int j = miny; j < maxy; j++) q[i][j] = power;
  x1 = 0; x2 = 0; y1 = 0; y2 = 0;
}
