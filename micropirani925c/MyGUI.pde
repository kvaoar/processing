
class GUIobj implements Plottable, Clicable{
  int x;
  int y;
  int h;
  int w;
  int gap;
  color l_col;

  GUIobj(int ox, int oy, int ow, int oh, color line_col) {
    gap = 5;
    x = ox;
    y = oy;
    w = ow;
    h = oh;
    l_col = line_col;
  }

  void plot() {
    rect(x, y, w, h, #000000);
  };

  void check_click(int x, int y) {
  };
  
  void check_mouseDragged(){};
  void check_mousePressed() {};
  void check_mouseReleased() {};
}

//

// for list plotting
interface Plottable {
  void plot();
}

//for list clicking
interface Clicable {
  void check_click(int x, int y);
  void check_mouseDragged();
  void check_mousePressed() ;
  void check_mouseReleased() ;
}