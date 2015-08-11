import java.util.Arrays;
float dt = 0.1, D = 0.25, V = 0.05, dl = 0.1;
int tick = 0;
float[][] q, c;
int dx = 0, dy = 0;
float minA = 0, maxA = 0;
int max_x = 640/2, max_y = 480/2;
int power = 10;
int x1 = 0, x2 = 0, y1 = 0, y2 = 0;
  
PFont font ;
PImage img ;
void setup() {
  size(640, 480);
  frameRate(30);
 smooth();
  q = new float[max_x][max_y];
  c = new float[max_x][max_y];
  dx = width/max_x;
  dy = height/max_y;
  println(dx+" "+dy);
  font = createFont("Consolas", 48);
  img = createImage(max_x*dx, max_y*dy, HSB);
//  square = createShape(RECT, 0, 0, dx, dy);
 // for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.2*max_y); j < round(0.3*max_y); j++) q[i][j] = 10;
//  for( int i = round(0.15*max_x); i < round(0.2*max_x); i++) for ( int j = round(0.4*max_y); j < round(0.6*max_y); j++) q[i][j] = 100;
//  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.8*max_y); j < round(0.9*max_y); j++) q[i][j] = 25;


}



void draw() {
  int t1 = millis();
  int t2 = t1;
  if(++tick > 60) {tick = 0;    };
  recalc();
  t2 = millis() - t2;

    colorMode(RGB);
    background(0,0,255);
    stroke(0);
    fill(0,0,255);

img.loadPixels();
colorMode(HSB);
 for(int i = 0; i < max_x; i++){
    for(int j = 0; j < max_y; j++){
      color cc = color(180-map(c[i][j],minA,maxA,0,180),255,255);
      color bb = color(180-map(c[i][j],minA,maxA,0,180),0,0);
      //if((x == 0)&&(y == 0)&&(q[i][j] != 0)) img.pixels[(j*dy+y)*width+(i*dx+x)] = bb;
       /* img.pixels[(j*dy)*width+(i*dx)] = cc;
        img.pixels[(j*dy+1)*width+(i*dx)] = cc;
        img.pixels[(j*dy)*width+(i*dx+1)] = cc;
        img.pixels[(j*dy+1)*width+(i*dx+1)] = cc;*/
      for(int x = 0; x < dx; x++){
        for(int y = 0; y < dy; y++){
        if((x == 0)&&(y == 0)&&(q[i][j] != 0)) img.pixels[(j*dy+y)*width+(i*dx+x)] = bb;
        else img.pixels[(j*dy+y)*width+(i*dx+x)] = cc;
      }
    }
    
  }
 }
img.updatePixels();
image(img, 0, 0);
colorMode(RGB);
t1 = millis() - t1 - t2;

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
*/
  
  if(mousePressed){
  if(((x1 != 0)||(y1 != 0))&&((x2 != 0)||(y2 != 0))&&((y1 != y2)||(x1 != x2))){
      int max_x = max(x1,x2);
      int min_x = min(x1,x2);
      int max_y = max(y1,y2);
      int min_y = min(y1,y2);
      colorMode(RGB);
      fill(255,0,0,abs(power)+10);
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
  text("max: "+round(maxA),300,height-10);
  text("min: "+round(minA),450,height-10);
  text("paint:"+t1+"ms calc:"+t2+ "ms",10,height-30);
  
}



void recalc(){
  minA = -10;
  maxA = 10;
   
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
       if(it >+1000) it = - 0.000001*it*it; //+100;
       if(it <-1000) it =+0.000001*it*it; //-100;
       c[i][j] = it;
      //if (maxA < it) maxA = 0.9*maxA + 0.1*it;
      //if (minA > it) minA = 0.9*maxA + 0.1*it;
    }
  }
 
  
  for(int i = 0; i <= max_x-1; i++){
  for(int j = max_y-1; j >= 0; j--){  
      float l = 0, r = 0, top = 0, bot = 0, it = 0, qs = 0;
      if(i > 0) l = c[i-1][j];
      if(i<max_x-1) r = c[i+1][j];
      if(j>0) bot = c[i][j-1];
      if(j<max_y-1) top = c[i][j+1];
       it = c[i][j];
       qs = q[i][j];

       it += D*(l+r+bot+top-4*it)*dt/dl + V*(it - r)*dt/dl + qs*dt;
       if(it >+1000) it = - 0.000001*it*it; //+100;
       if(it <-1000) it =+0.000001*it*it; //-100;
       c[i][j] = it;

      if (maxA < it) maxA = it;
      if (minA > it) minA = it;

    }
  }
  
  maxA = max(abs(maxA),abs(minA));
  minA = -maxA;
}



void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  int ds = (abs(power)<10)?1:10;
  if(e < 0) {if (power < 250) power+= ds ;  else power = -250;}
  if(e > 0) {if (power > -250) power-= ds;  else power = +250;}
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
