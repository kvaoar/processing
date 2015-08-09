import java.util.Arrays;
float dt = 1, D = 2, V = 1;
int tick = 0;
int[][] q, c;
int dx = 0, dy = 0;
int A = 0;

void setup() {
  size(600, 400);
  frameRate(10);
  
  q = new int[100][100];
  c = new int[100][100];
  dx = width/100;
  dy = height/100;
  println(dx+" "+dy);
  
  
  for( int i = 10; i < 15; i++) for ( int j = 45; j < 48; j++) q[i][j] = 50;
  for( int i = 15; i < 25; i++) for ( int j = 48; j < 52; j++) q[i][j] = 55;
  for( int i = 10; i < 15; i++) for ( int j = 52; j < 55; j++) q[i][j] = 50;
}

void draw() {
  background(0);
  stroke(255);
  fill(255);
  if(++tick > 100) {tick = 0; };

  recalc();
 for(int i = 0; i < 100; i++){
    for(int j = 0; j < 100; j++){
      
     fill(map(c[i][j],0,A,0,255));
     stroke(0);
     rect(i*dx,j*dy,dx,dy);
     }
  }
    stroke(255);
  fill(255);
  textSize(18);
  text(tick,10,height);
  text(A,50,height);
  
}

void recalc(){
  
  
  for(int i = 1; i < 100-1; i++){
    for(int j = 1; j < 100-1; j++){
      c[i][j] += (D*(c[i-1][j]+c[i+1][j]+c[i][j-1]+c[i][j+1]-4*c[i][j])*dt/dx + V*(c[i][j] - c[i+1][j])*dt/dx + q[i][j]*dt);
      if (A < c[i][j]) A = c[i][j];
    }
  }
  

}

void mouseDragged(){

q[round(mouseX/dx)][round(mouseY/dy)] = 100;
}
