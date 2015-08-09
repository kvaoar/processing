import java.util.Arrays;
float dt = 1, D = 3, V = 1, dl = 10;
int tick = 0;
int[][] q, c;
int dx = 0, dy = 0;
int A = 0;
int max_x = 100, max_y = 100;

void setup() {
  size(600, 400);
  frameRate(60);
  
  q = new int[max_x][max_y];
  c = new int[max_x][max_y];
  dx = width/max_x;
  dy = height/max_y;
  println(dx+" "+dy);
  
  
  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.2*max_y); j < round(0.25*max_y); j++) q[i][j] = 100;
  for( int i = round(0.15*max_x); i < round(0.2*max_x); i++) for ( int j = round(0.4*max_y); j < round(0.6*max_y); j++) q[i][j] = 100;
  for( int i = round(0.1*max_x); i < round(0.15*max_x); i++) for ( int j = round(0.8*max_y); j < round(0.85*max_y); j++) q[i][j] = 100;
}

void draw() {
  background(0);
  stroke(255);
  fill(255);
  if(++tick > 10) {tick = 0;};

   recalc();
 for(int i = 0; i < max_x; i++){
    for(int j = 0; j < max_y; j++){
      
     fill(map(c[i][j], 0,A, 0,255));
     stroke(0);
     rect(i*dx,j*dy,dx,dy);
     
      if(q[i][j] >0){
       fill(255,0,0,100);
       stroke(0);
       rect(i*dx,j*dy,dx,dy);
       }
     }
  }
  
  
    stroke(255);
  fill(255);
  textSize(18);
  text(tick,10,height);
  text(A,50,height);
  
}

void recalc(){
  
  
  for(int i = 1; i < max_x-1; i++){
    for(int j = 1; j < max_y-1; j++){
      c[i][j] += (D*(c[i-1][j]+c[i+1][j]+c[i][j-1]+c[i][j+1]-4*c[i][j])*dt/dl + V*(c[i][j] - c[i+1][j])*dt/dl + q[i][j]*dt);
      if (A < c[i][j]) A = c[i][j];
    }
  }
  

}

void mouseDragged(){

q[round(mouseX/dx)][round(mouseY/dy)] = 100;
}
