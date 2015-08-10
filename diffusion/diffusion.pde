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
  size(600, 480);
  frameRate(10);
 //smooth();
  q = new float[max_x][max_y];
  c = new float[max_x][max_y];
  dx = width/max_x;
  dy = height/max_y;
  println(dx+" "+dy);
  font = createFont("Consolas", 48);
  
 // for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.2*max_y); j < round(0.3*max_y); j++) q[i][j] = 10;
//  for( int i = round(0.15*max_x); i < round(0.2*max_x); i++) for ( int j = round(0.4*max_y); j < round(0.6*max_y); j++) q[i][j] = 100;
//  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.8*max_y); j < round(0.9*max_y); j++) q[i][j] = 25;
}

void draw() {
  if(++tick > 60) {tick = 0;    };
  recalc();
    colorMode(RGB);
    background(0,0,255);
    stroke(0);
    fill(0,0,255);

 for(int i = 0; i < max_x; i++){
    for(int j = 0; j < max_y; j++){
       
       colorMode(HSB);
       fill(180-map(c[i][j],0,A,0,180),255,255);
       stroke(180-map(c[i][j],0,A,0,180),255,255);
       rect(i*dx,j*dy,dx,dy);
       
      
      if(q[i][j] >0){
       colorMode(RGB);
       stroke(255,0,0,255);
       point(i*dx+dx/2, j*dy+dy/2);
       }
       
       if(q[i][j] <0){
       colorMode(RGB);
       stroke(0,0,0,255);
       point(i*dx+dx/2, j*dy+dy/2);
       }
       
    }
  }
  
  

/*  colorMode(RGB);
  rect(10,height-40,180,10);
  for(int i = 0; i < 180; i++){
    colorMode(HSB);
    stroke(i,255,200);
    line(10+i,height-40,10+i,height-30);
  }
  colorMode(RGB);
  textFont(font, 16);
  stroke(0);
  fill(0);
  text(A,20,20);
  text(0,20,190);*/
  
  if(mousePressed){
  if(((x1 != 0)||(y1 != 0))&&((x2 != 0)||(y2 != 0))&&((y1 != y2)||(x1 != x2))){
      int max_x = max(x1,x2);
      int min_x = min(x1,x2);
      int max_y = max(y1,y2);
      int min_y = min(y1,y2);
      colorMode(RGB);
      fill(255,0,0,abs(power));
      rect(min_x,min_y,max_x-min_x,max_y-min_y);
    }
  }
  
      
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
  A = 1;
 
   
  for(int i = 0; i < max_x; i++){
    for(int j = 0; j < max_y; j++){
      float l = 0, r = 0, top = 0, bot = 0, it = 0, qs = 0;
      if(i > 0) l = c[i-1][j];
      if(i<max_x-1) r = c[i+1][j];
      if(j>0) bot = c[i][j-1];
      if(j<max_y-1) top = c[i][j+1];
       it = c[i][j];
       qs = q[i][j];
       it += D*(l+r+bot+top-4*it)*dt/dl + V*(it - r)*dt/dl + qs*dt;
       if(it>1000) it -= (it-1000);
       if(it <0 ) it = 0;
       c[i][j] = it;
      if (A < it) A = it;
      
    }
  }
  

  
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e <0) if (power < 250) {power+=10; }
  if(e >0) if (power > -250)  { power-=10;}
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
