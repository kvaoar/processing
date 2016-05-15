import java.util.Arrays;
float dt = 0.05, D = 0.99, V = 0.01, dl = 0.1, temp0 = 25, power0 = 1, Rair = 0.001;
int tick = 0;
float[][] q, c;
int dx = 0, dy = 0;
float minA = -1, maxA = +1;
int max_x = 1024, max_y = 768;
float power = 10;
int x1 = 0, x2 = 0, y1 = 0, y2 = 0;

boolean sources = false, speed = false, pause = false;

PFont font ;
PImage img ;
void setup() {
  size(1024, 768);
  frameRate(30);
  smooth();
  q = new float[max_x][max_y]; //<>//
  c = new float[max_x][max_y];
for(int i = 0; i < max_x; i++)for (int j = 0; j < max_y; j++) c[i][j] = temp0;
  dx = width/max_x;
  dy = height/max_y;
  println(dx+" "+dy);
  font = createFont("Consolas", 14);
  img = createImage(max_x*dx, max_y*dy, HSB);
  //  square = createShape(RECT, 0, 0, dx, dy);
  for ( int i = round(max_x/2 - 0.1*max_x); i < round(max_x/2 + 0.1*max_x); i++) for ( int j = round(max_y/2 - 0.1*max_y); j < round(max_y/2 + 0.1*max_y); j++) q[i][j] = power0;
  //  for( int i = round(0.15*max_x); i < round(0.2*max_x); i++) for ( int j = round(0.4*max_y); j < round(0.6*max_y); j++) q[i][j] = 100;
  //  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.8*max_y); j < round(0.9*max_y); j++) q[i][j] = 25;
  }



void draw() {
  int t1 = millis();
  int t2 = t1;
  if (++tick > 60) {
    tick = 0;
  };
  if (!pause) recalc();
  t2 = millis() - t2;


  img.loadPixels();
  colorMode(HSB);
  for (int i = 0; i < max_x; i++) {
    for (int j = 0; j < max_y; j++) {
      color cc = color(180-map(c[i][j], minA, maxA, 0, 180), 255, 255);
      color bb = color(180-map(c[i][j], minA, maxA, 0, 180), 0, 0);
      // if((img.pixels[(j*dy+1)*width+(i*dx+1)] != cc)){
      for (int x = 0; x < dx; x++) {
        for (int y = 0; y < dy; y++) {
          img.pixels[(j*dy+y)*width+(i*dx+x)] = cc;
          if (sources)if ((x == 0)&&(y == 0)&&(q[i][j] != 0)) img.pixels[(j*dy+y)*width+(i*dx+x)] = bb;
           
        }
      }
      // }
      
    }
  }
  img.updatePixels();
  image(img, 0, 0);
  colorMode(RGB);
  line(max_x/2, max_y/2 - 0.1*max_y,  max_x/2 , max_y/2 + 0.1*max_y);
  line(max_x/2 - 0.1*max_x, max_y/2 ,  max_x/2 + 0.1*max_x, max_y/2);

for ( int i = 0; i < round(max_x/2); i++){
            float t_1 = c[i*2][round(max_y/2)];
            float t_2 = c[i*2+1][round(max_y/2)];
            line(2*i, map(t_1, minA, maxA, 0.8*max_y, 0.1*max_y),2*i+1, map(t_2, minA, maxA, 0.8*max_y, 0.1*max_y));
           }
           
for( int i = 0; i < 11; i++){
float t = (minA + (i*(maxA - minA)/10));
float y = map(t, minA, maxA, 0.8*max_y, 0.1*max_y);
line(0, y, 10,y);
 text( round(t), 10,y+4);
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
   */

  if (mousePressed) {
    if (((x1 != 0)||(y1 != 0))&&((x2 != 0)||(y2 != 0))&&((y1 != y2)||(x1 != x2))) {
      int max_x = max(x1, x2);
      int min_x = min(x1, x2);
      int max_y = max(y1, y2);
      int min_y = min(y1, y2);
      colorMode(RGB);
      fill(255, 0, 0, abs(power)+10);
      rect(min_x, min_y, max_x-min_x, max_y-min_y);
    }
  }


  /*   fill(255,0,0,power);
   rect(mouseX,mouseY,dx,dy);
   */
  t1 = millis() - t1 - t2;
  fill(0);
  textFont(font);
  text( "[([) v="+nf(V, 1, 3)+" (])]" , 30, 20);
  text( "[(o) d="+nf(D, 1, 3)+" (p)]" , 30, 40);
  text( "[(k) temp0 = " + nf(temp0,1,1) + " (l)]" , 30, 60);
  text( "[(n) Rair = " + nf(Rair,1,6) + " (m)]" , 30, 80);
  text("Sources  (q):"+onoff(sources), 480, 20);
  text("Flow     (s):"+onoff(speed), 480, 40);
  text("Pause(space):"+onoff(pause), 480, 60);

  text("timer: "+tick, 10, height-10);
  text("power: "+nf(power, 1, 3), 150, height-10);
  text("max: "+round(maxA), 300, height-10);
  text("min: "+round(minA), 450, height-10);
  text("delta : "+(round(maxA)-round(minA)), 550, height-10);
  text("paint:"+t1+"ms calc:"+t2+ "ms ", 10, height-30);
}

String onoff( boolean b) {
  return b?"on":"off";
}

void recalc() {
  minA = Float.POSITIVE_INFINITY;
  maxA = Float.NEGATIVE_INFINITY;

  for (int i = 0; i < max_x; i++)     for (int j = 0; j < max_y; j++) d_recalc(i, j); //left top
    for (int i = max_x-1; i >=0; i--)   for (int j = max_y-1; j >=0; j--)d_recalc(i, j);  //right bot
  for (int i = max_x-1; i >=0; i--)   for (int j = 0; j < max_y; j++) d_recalc(i, j);   //right top

  for (int i = 0; i < max_x; i++)     for (int j = max_y-1; j >=0; j--) d_recalc(i, j); //left bot

  /* for(int i = 0; i < max_x; i++)     for(int j = 0; j < max_y; j++) d_recalc(i,j); //left top
   for(int i = 0; i < max_x; i++)     for(int j = max_y-1; j >=0; j--) d_recalc(i,j); //left bot
   for(int i = max_x-1; i >=0; i--)   for(int j = 0; j < max_y; j++) d_recalc(i,j);   //right top
   for(int i = max_x-1; i >=0; i--)   for(int j = max_y-1; j >=0; j--)d_recalc(i,j);  //right bot
   */

  //maxA = max(abs(maxA), abs(minA));
  //minA = -maxA;
}


void d_recalc(int i, int j) {
  float l = temp0, r = temp0, top = temp0, bot = temp0, it = 0, qs = 0, v = 0;

  if (i > 0) l = c[i-1][j];
  if (i<max_x-1) r = c[i+1][j];
  if (j>0) bot = c[i][j-1];
  if (j<max_y-1) top = c[i][j+1];

  it = c[i][j];
  qs = q[i][j];
  if (speed) v = V;

  it += D*(l+r+bot+top-4*it)*dt/dl + v*(it - r)*dt/dl + qs*dt;
  it -= (it-temp0)*Rair;
//  if (it >+1000) it = - 0.000*it; //+100;
//  if (it <-1000) it = +0.0001*it; //-100;

  c[i][j] = it;

  if (maxA < it) maxA = it;
  if (minA > it) minA = it;
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
float ds = (abs(power)<=1)?0.1:1;

  if (e < 0) {
    if (power < 250) power+= ds ;  
    else power = -250;
  }
  if (e > 0) {
    if (power > -250) power-= ds;  
    else power = +250;
  }
}


void mousePressed() {
  x1 = mouseX;
  y1 = mouseY;
}

void mouseDragged() {
  x2 = mouseX;
  y2 = mouseY;
}

void mouseReleased() {
  x2 = mouseX;
  y2 = mouseY;
  int maxx = min(max(x1, x2), max_x*dx-1)/dx ;
  int minx = max(min(x1, x2), 1)/dx;
  int maxy = min(max(y1, y2), max_y*dy-1)/dy;
  int miny = max(min(y1, y2), 1)/dy;
  for ( int i = minx; i < maxx; i++) for ( int j = miny; j < maxy; j++) q[i][j] = power;
  x1 = 0; 
  x2 = 0; 
  y1 = 0; 
  y2 = 0;
}

void keyPressed() {
  if (key == 'q') sources = ! sources;
  if (key == 's') speed = ! speed;
  if (key == ' ') pause = ! pause;
  if (key == '[') V -= 0.001;
  if (key == ']') V += 0.001;
  if (key == 'o') D -= 0.001; 
  if (key == 'p') D += 0.001; 
  if (key == 'k') temp0 -= 1; 
  if (key == 'l') temp0 += 1; 
  if (key == 'n') Rair -= 0.00001; 
  if (key == 'm') Rair += 0.00001; 
  if (keyCode == BACKSPACE) {
    for (float[] f : c) Arrays.fill(f, 0);
  }
}