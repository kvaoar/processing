

class Cursor extends GUIobj {
  int text_size;
  float px;
  float py;
  String text;
  color text_color;
  boolean in_dragged;
  float old_x;
  float old_y;
  color selected = #FF0000;
  float val = 0;
  boolean terminate = false;
  Graph par;

  Cursor(Graph parent, int cx, int cy, int cw, int ch, color cc, color txt, int text_sz) {
    super(cx, cy, cw, ch, cc);
    text_color = txt;
    text_size = text_sz;
    in_dragged = false;
    par = parent;
  }

  void plot() {
    strokeWeight(1);
    if (in_dragged)stroke(selected, 200); 
    else stroke(l_col, 200);
    line(px, y, px, y+h);
    line(x, py, x+w, py);
    ellipseMode(CENTER);
    noFill();
    ellipse(px, py, 10, 10);
    if (text!= null) {
      fill(text_color, 200);
      text(text, px- textWidth(text), py+text_size);
    }
    
    if(par.plot_data != null)
    if(px>par.x0)
    if(par.plot_data.size()> (px-par.x0)){
      val = par.filter.v.get(round(px+par.data_offset-par.x0));
         py =  par.y0-abs(par.plot_data.get(round(px-par.x0))*par.m_y.decade_h);
         text = par.label(val);
    } else text = null;
  }

  void move( String val, float set_x, float set_y) {
    px = set_x;
    py = set_y;
    text = val;
  }


  void check_mouseDragged() {

    if (in_dragged) {
      float new_px =  px + mouseX-old_x;
      float new_py = py + mouseY-old_y;
      if ((new_px< x+w)&&(new_px > x)) {
        px = new_px; 
        old_x = mouseX;
      }
      
      if ((new_py< y+h)&&(new_py > y)) { 
        py = new_py; 
        old_y = mouseY;
      }
      old_y = mouseY;
    }
  }

  void check_mousePressed() {
    if (!in_dragged) {
      if (mouseButton == LEFT) {
        if ((mouseX< px+10)&&(mouseX>px-10)&&(mouseY<py+10)&&(mouseY>py-10)) {
          old_x = mouseX;
          old_y = mouseY;
          in_dragged = true;
        }
      }
      if (mouseButton == RIGHT) {
        if ((mouseX< px+10)&&(mouseX>px-10)&&(mouseY<py+10)&&(mouseY>py-10)) {
        terminate = true;
        }
      }
    }
  }

  void check_mouseReleased() {
    in_dragged = false;
  }
}