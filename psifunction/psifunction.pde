
import java.util.Collections;
import java.util.List;
float U1 = 0;
float U2 = 100;
float E = 0;
float Efind = 0;
float h2m = 0.00001;
float a = 600;
float b = 200;
float dE = 0.001;
int z1 = 0, z2 = 600;

ArrayList<Float> a_fi ;
ArrayList<Float>  a_U ;
ArrayList<Float> a_Elvl;
ArrayList<Float> a_Eteo;

float min_U = 0, max_U = 0;
float min_fi = 0, max_fi = 0, abs_dif = 0;
float min_fi2 = 0, max_fi2 = 0;
boolean process = false;

void setup() {
  size(800,600);
  noFill();
  stroke(255);
  frameRate(60);
  a_fi  = new ArrayList<Float>();
  a_U   = new ArrayList<Float> ();
  a_Elvl = new ArrayList<Float>();
  a_Eteo = new ArrayList<Float>();
  back();
  upd_Eteo();
}

void draw() {
background(0);



stroke(255,0,0);
strokeWeight(2);

beginShape();
fill(255,0,0,100);
vertex(0,height);
for(int i = 0; i < a_U.size(); i++) vertex(i, height-round(map(a_U.get(i)  , min_U,  max_U,   10, height-10)) );
vertex(width,height);
endShape(CLOSE);
noFill();

stroke(0,255,0);
line(z1-5,height/2,z1+5,height/2);
line(z2-5,height/2,z2+5,height/2);
line(z1,0,z1,height);
line(z2,0,z2,height);

beginShape();
fill(0,255,0,50);
vertex(0,height);
for(int i = 0; i < a_fi.size(); i++) vertex(i, height-round(map(a_fi.get(i) , -abs_dif, +abs_dif,  100, height-100)) );
vertex(width,height);
endShape(CLOSE);
noFill();

stroke(255,255,0);
beginShape();
fill(0,0,255,50);
vertex(0,height);
for(int i = 0; i < a_fi.size(); i++) vertex(i, height-round(map(a_fi.get(i)*a_fi.get(i), 0, max_fi2, 0, height/2)) );  
vertex(width,height);
endShape(CLOSE);

float Edisc = 0;

for(int n = 0; n < a_Elvl.size(); n++){
if(a_Elvl.get(n) >0){
    int l = round(height - map(a_Elvl.get(n), min_U, max_U, 10, height-10));
    fill(255);
    text("Ef"+(n+1)+" = "+ nf(a_Elvl.get(n),1,4),120,l+20);
    stroke(0,255,255);
    line(0,l,width,l);
  }
}

for(int n = 0; n < a_Eteo.size(); n++){
    int l = round(height - map(a_Eteo.get(n), min_U, max_U, 10, height-10));
    fill(255);
    text("Et"+(n+1)+" = "+ nf(a_Eteo.get(n),1,4),width-120,l-20);
    stroke(255,0,255);
    line(0,l,width,l);

}

if(process){
   
   int lineE = round(height - map(Efind, min_U, max_U, 10, height-10));
   stroke(255);
   fill(255,0);
   line(0,lineE,width,lineE);
   //text("Ef"+(n+1)+"="+ nf(a_Elvl.get(n),1,4),120,l+15);
   rect(115, lineE+5, 120,20);
}
   
   int lineE = round(height - map(E, min_U, max_U, 10, height-10));

   stroke(255);
   fill(255);
triangle(10, lineE, 1,lineE+5, 1, lineE-5);
line(0,lineE,width,lineE);
   
   
stroke(255);
fill(255,255,255,200);
rect(5,5,230,125);
fill(0);
textSize(14);
text("E = "+ nf(E,1,4) , 10, 20);
text("f["+ nf(min_fi,1,2)+"..."+ nf(max_fi,1,2)+"]", 10, 40);
text("f2["+ nf(min_fi2,1,2)+"..."+ nf(max_fi2,1,2)+"]", 10, 60);
text("U["+ min_U +"..."+ max_U+"]", 10, 80);
text("a="+ a + " b="+ b, 10, 100);
text("z2-z1="+ (z2-z1), 10, 120);
fill(255);
  
  if (keyPressed){
    if(key == '+') E += dE;
    if(key == '-') E -= dE;
    if(key == '6') { a += 1; back(); }
    if(key == '4') { a -= 1; back(); }
    if(key == '9') { b += 1; back(); }
    if(key == '7') { b -= 1; back(); }
    recalc(E);
}


}


void mouseDragged(){

    if((abs(mouseX - z1) < 20)&&(mouseX>0)&&(mouseX<width)) {z1 =  mouseX; upd_Eteo(); upd_scale();}
    else
    if((abs(mouseX - z2) < 20)&&(mouseX>0)&&(mouseX<width)) {z2 = mouseX; upd_Eteo(); upd_scale();}
    else
    if(abs(mouseY - (height-map(E, min_U, max_U, 10, height-10))) < 20)
    {
      E = map(height- mouseY, 10, height-10, min_U, max_U); 
      upd_Eteo();
      back();
      recalc(E);
    }
 
}

void keyReleased() {
  if(key == ENTER){ if(!process) thread("find_lvl"); }
  if(key == BACKSPACE) {if(!process)  a_Elvl.clear();}
    if (key == CODED) {
    
    if(keyCode == UP)  {  
    for(int i = 0; i < a_Elvl.size(); i++){
    if(E < a_Elvl.get(i)) {
      E = a_Elvl.get(i); 
      break;
      } 
    }; 
    recalc(E);
    }
    if(keyCode == DOWN){  
      for(int i = a_Elvl.size()-1; i >= 0; i--){ 
        if(E > a_Elvl.get(i)) {
          E = a_Elvl.get(i); 
          break;
          } 
        }; 
      recalc(E);
    }
    
        if(keyCode == RIGHT)  {  
    for(int i = 0; i < a_Eteo.size(); i++){
    if(E < a_Eteo.get(i)) {
      E = a_Eteo.get(i); 
      break;
      } 
    }; 
    recalc(E);
    }
    if(keyCode == LEFT){  
      for(int i = a_Eteo.size()-1; i >= 0; i--){ 
        if(E > a_Eteo.get(i)) {
          E = a_Eteo.get(i); 
          break;
          } 
        }; 
      recalc(E);
    }
    
    }
}


void upd_Eteo(){
a_Eteo.clear();
float e = 0;
int n = 1;
while(e < max_U){
e = (PI*PI/(h2m*z2*z2))*(n*n);
if(e < max_U) a_Eteo.add(e);
n++;
}
};

void recalc(float e){
a_fi.clear();
float fi2  = 0;
float fi1 = 0.001;
float fi = -0.001;
int tsteps = 100;
float u = 0;
for(int step = 0; step < width; step++){
  u = a_U.get(round(step));
  for(int tst = 0; tst < tsteps; tst++){
   fi2 = -h2m*(e-u)*fi;
   fi1 += fi2/tsteps;
   fi  += fi1/tsteps;
  }
a_fi.add(round(step),fi);
} 


upd_scale();
}

void upd_scale(){
 int tmp = max(z1,z2);
 z1 = min(z1,z2);
 z2 = tmp;
if(a_fi.size() > z2 ){
List<Float> sub = a_fi.subList(z1,z2);
  if(sub.size() > 0){
    max_fi = Collections.max(sub);
    min_fi = Collections.min(sub);
    abs_dif = max(abs(max_fi), abs(min_fi));
    max_fi2 = max_fi*max_fi;
    min_fi2 = 0;
    }
  }
}


// get psi-func value in x = pos with energy = e and potential = u
float calc(int pos, float e, ArrayList<Float> Ux){ 
float fi2  = 0;
float fi1 = 1;
float fi = -1;
int tsteps = 500;
float u = 0;
  for(int step = 0; step < pos; step++){
     u = Ux.get(step);
     for(int i = 0; i < tsteps; i++){
     fi2 = -h2m*(e-u)*fi;
     fi1 += fi2/tsteps;
     fi  += fi1/tsteps;
     }
  } 
return fi;
}



void find_lvl(){
 process = true;
a_Elvl.clear();
int zoom = 100;
float dE0 = max_U/zoom;
find0(0, max_U, dE0, (z2));
find(4, dE0, 50,  (z2));
process = false;
}


void find0(float E1, Float E2, float dE, int x){
float e = E1;
float f = 0, old_f = 0;
    while ( e < E2 )
    {
      f = calc(x,e,a_U);
      if(old_f*f < 0) {a_Elvl.add(e);}
       old_f = f;
       e += dE;
      Efind = e;
    }
    Efind = 0;

}

void find(int step, float dE, int zoom, int xmax){
//if (step <5) println("=======================");
//if (step <5) println("STEP #" + step);
for(int i = 0; i < a_Elvl.size(); i++) {
float f = 0, old_f = 0;
float E1 = a_Elvl.get(i)-dE;
float E2 = a_Elvl.get(i)+dE;
//if (step <5) println("set zone "+E1 + " - " + E2 );
float e = E1;
    while ( e < E2 )
    {
      Efind = e;
      f = calc(xmax,e, a_U);
//if (step <5)      println(dE/zoom+ " f "+f+ " of "+ old_f);
      if(old_f*f < 0) {
        a_Elvl.set(i,e); 
//if (step <5)         println("!!!!!!!!"+i+" - "+e); 
        break;
      }
       old_f = f;       
       e += dE/zoom;
       if(e + dE/zoom == e) break;
    }
  }
Efind = 0;



  step--;
  if ((step == 0)||(1 + dE/zoom == 1))return;
  else find(step, dE/zoom, zoom,  xmax);
}


void back(){
  if(!process){
  a_U.clear();
  for(int i = 0; i < width; i++)
      if((i % (a + b)) > a) 
        a_U.add(i,U2); else a_U.add(i,U1);
  min_U    = 0;//min(a_U);
  max_U    = Collections.max(a_U);
  }
}




