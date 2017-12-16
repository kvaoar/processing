

class Button extends GUIobj {
  boolean is_active = false; //pressed or press and fix
  boolean is_light = false;

  int font_size;

  color on;
  color off;

  int round = 0;
  int alpha = 100;
  int text_size = 15;

ClickCallback call;

  GUIobj parent;

  String text;

  Button(String txt, int b_x, int b_y, int b_w, int b_h, color border, color on_fill, color off_fill, int txt_siz) {
    super(b_x, b_y, b_w, b_h, border);

    on = on_fill;
    off = off_fill;
    text_size = txt_siz;
    text = txt;
    textSize(text_size );
    w = max(ceil(textWidth(text))+2*gap, b_w);
    h = max(h, (text_size+2*gap));
    is_active = false;
  }
  
  
  Button(String txt, int b_x, int b_y, int b_w, int b_h, color border, color on_fill, color off_fill, int txt_siz, ClickCallback c) {
    super(b_x, b_y, b_w, b_h, border);
    call = c;
    on = on_fill;
    off = off_fill;
    text_size = txt_siz;
    text = txt;
    textSize(text_size );
    w = max(ceil(textWidth(text))+2*gap, b_w);
    h = max(h, (text_size+2*gap));
    is_active = false;
  }


  void plot() {
    strokeWeight(1);
    stroke(l_col);

    if (is_light)
      fill(on, alpha); 
    else 
    fill(off, alpha);

    rect(x, y, w, h, round);

    fill(l_col);
    noStroke();
    textSize(text_size );
    textAlign(CENTER);
    text(text,x+(w/2), y+((h+(text_size/2))/2));
  }

  void check_click(int cx, int cy) {
    if ((cx>x)&&(cx<x+w)&&(cy>y)&&(cy<y+h)) {
      is_active = true;
      //println(text);
      if(call != null) call.OnClick(this);
    }
  }
}