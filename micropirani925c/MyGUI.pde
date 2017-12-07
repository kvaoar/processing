
class GUIobj implements Plottable, Clicable {
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
}


// for list plotting
interface Plottable {
  void plot();
}

//for list clicking
interface Clicable {
  void check_click(int x, int y);
}


class Button extends GUIobj {
  boolean is_active = false; //pressed or press and fix
  boolean is_light = false;

  color on;
  color off;

  int round = 1;
  int alpha = 100;
  int text_size = 14;

  GUIobj parent;

  String text;

  Button(String txt, int b_x, int b_y, int b_w, int b_h, color border, color on_fill, color off_fill) {
    super(b_x, b_y, b_w, b_h, border);

    on = on_fill;
    off = off_fill;

    text = txt;
    textSize(text_size );
    w = max(ceil(textWidth(text))+gap*2, b_w);
    h = max(h, (text_size+gap*2));
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
    textSize(text_size );

    text(text, x+gap, y+text_size);
  }

  void check_click(int cx, int cy) {
    if ((cx>x)&&(cx<x+w)&&(cy>y)&&(cy<y+h)) {
      is_active = true;
      println(text);
    }
  }
}

class StringTree {
  String Name;
  ArrayList<StringTree> Parents;
  StringTree(String name, StringTree... trees ) {
    Name = name;
    Parents = new ArrayList<StringTree>();
    for (StringTree t : trees) Parents.add(t);
  }
}

class Menu extends GUIobj {

  int btn_selected = -1;
  boolean final_btn_selected = true;
  boolean is_vertical = true;
  boolean is_transit = false;
  int text_size = 18;
  int btn_count = 0;

  ArrayList<Button> b;
  //ArrayList<String> s;
  ArrayList<StringTree> name_map;
  Menu sub_m;

  Menu(StringTree mpoints, int mx, int my, int mw, int mh, color bcol, boolean vert) {

    super(mx, my, mw, mh, bcol);
    b = new ArrayList<Button>();
    //s = new ArrayList<String>();

    name_map = mpoints.Parents;
    btn_count = mpoints.Parents.size();

    //for (int i = 0; i < btn_count; i++) s.add(mpoints.Parents.get(i).Name);

    is_vertical = vert;
    textSize(text_size );
    int mlen = maxlen();
    if (is_vertical) {
      int h_step = gap+text_size;
      w = max(w, (mlen +4*gap));
      h = btn_count *h_step + 2*gap;

      for (int i = 0; i < btn_count; i++) b.add(new Button(name_map.get(i).Name, x+gap, y+h_step*i+gap, w-2*gap, text_size+gap, #FFFF00, #00FF00, #0000FF));
    } else {
      int w_step = mlen + gap;
      w = btn_count*w_step + gap;
      h = 3*gap + text_size;

      for (int i = 0; i < btn_count; i++) b.add(new Button(name_map.get(i).Name, x+gap+w_step*i, y+gap, w_step-gap, text_size, #FFFF00, #00FF00, #0000FF));
    }
  }


  boolean SearchSubmenu(Button p_btn) {

    StringTree t = name_map.get(b.indexOf(p_btn));
    println(t.Parents.size());
    if (t.Parents.size()>0)
    {
      if (is_vertical)
        sub_m = new Menu(t, p_btn.x+p_btn.w, p_btn.y, 100, 100, l_col, !is_vertical);
      else
        sub_m = new Menu(t, p_btn.x, p_btn.y+p_btn.h, 100, 100, l_col, !is_vertical);
      return true;
    } else {
      sub_m = null;
      return false;
    }
  }

  int maxlen() {
    //mpoints.Parents.get(i).Name
    int maxlen = 0;
    int m_index = 0;
    for (int i = 0; i < name_map.size(); i++)
      if (name_map.get(i).Name.length()>maxlen) {
        maxlen = name_map.get(i).Name.length(); 
        m_index = i;
      }

    return ceil(textWidth(name_map.get(m_index).Name));
  }



  void plot() {
    stroke(l_col);
    fill(0);
    rect(x, y, w, h);
    for (Plottable p : b) p.plot();
    if (sub_m != null)sub_m.plot();
  }

  void reset_menu() {
    sub_m = null; 
    btn_selected = -1;
    for (Button btn : b) {
      btn.is_light = false;  
      btn.is_active = false;
    }
  }

  int get_clicked() {
    for (Button btn : b) 
      if (btn.is_active) {
        btn.is_active = false;
        return b.indexOf(btn);
      }
    return -1;
  }

  void check_click(int x, int y) {

    for (Clicable c : b) 
      c.check_click(x, y);

    if (sub_m != null) {
      sub_m.check_click(x, y);
      if (sub_m.final_btn_selected) {
        final_btn_selected = true;

        reset_menu();
      }
    }

    for (Button btn : b) 
      if (btn.is_active) {
        int clk = get_clicked();
        if (clk>=0) // pressed button
          if (!btn.is_light) { // off before
            if (SearchSubmenu(btn)) // contain menu
            {
              btn.is_light = true;
              btn_selected = clk;
              final_btn_selected = false;
            } else
              final_btn_selected = true;
          } else { // on before
            reset_menu();
          }
      }
  }
}