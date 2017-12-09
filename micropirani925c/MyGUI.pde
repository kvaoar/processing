
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

//

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

  int font_size;

  color on;
  color off;

  int round = 1;
  int alpha = 100;
  int text_size = 15;

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
    textAlign(CENTER);
    text(text,x+(w/2), y+((h+(text_size/2))/2));
  }

  void check_click(int cx, int cy) {
    if ((cx>x)&&(cx<x+w)&&(cy>y)&&(cy<y+h)) {
      is_active = true;
      //println(text);
    }
  }
}

class MenuTree {
  String Name;
  ArrayList<MenuTree> Parents;
  ClickCallback clk;


  MenuTree(String name, MenuTree... trees ) {
    Name = name;
    clk = null;
    Parents = new ArrayList<MenuTree>();
    for (MenuTree t : trees) Parents.add(t);
  }

  MenuTree(String name, ClickCallback c, MenuTree... trees ) {
    Name = name;
    clk = c;
    Parents = new ArrayList<MenuTree>();
    for (MenuTree t : trees) Parents.add(t);
  }
}

class Menu extends GUIobj {

  int btn_selected = -1;
  boolean final_btn_selected = true;
  boolean is_vertical = true;
  boolean is_transit = false;
  int font_size = 14;
  int btn_count = 0;

  ArrayList<Button> b;
  //ArrayList<String> s;
  ArrayList<MenuTree> name_map;
  Menu sub_m;

  Menu(MenuTree mpoints, int mx, int my, int mw, int mh, color bcol, boolean vert) {

    super(mx, my, mw, mh, bcol);
    b = new ArrayList<Button>();
    //s = new ArrayList<String>();

    name_map = mpoints.Parents;
    btn_count = mpoints.Parents.size();

    //for (int i = 0; i < btn_count; i++) s.add(mpoints.Parents.get(i).Name);

    is_vertical = vert;
    
    int btn_maxh = 0;
    int btn_maxw = 0;
      for (int i = 0; i < btn_count; i++) {
        Button tmp_b = new Button(name_map.get(i).Name, 0, 0, 0, 0, #FFFF00, #00FF00, #0000FF,font_size);
        if(tmp_b.w>btn_maxw)btn_maxw = tmp_b.w;
        if(tmp_b.h>btn_maxh)btn_maxh = tmp_b.h;
      }
    
    
    if (is_vertical) {
    h = gap + (btn_maxh + gap)*btn_count;
    w = gap +  (btn_maxw + gap)*1;
    for (int i = 0; i < btn_count; i++) b.add(new Button(name_map.get(i).Name, x + gap, y + gap + (gap+btn_maxh)*i, btn_maxw, btn_maxh, #FFFF00, #00FF00, #0000FF,font_size));
        
      
    } else {
    h = gap + (btn_maxh + gap)*1;
    w = gap +  (btn_maxw + gap)*btn_count;
    for (int i = 0; i < btn_count; i++) b.add(new Button(name_map.get(i).Name, x + gap + (btn_maxw + gap)*i , y + gap, btn_maxw, btn_maxh, #FFFF00, #00FF00, #0000FF,font_size));
      //for (int i = 0; i < btn_count; i++) b.add(new Button(name_map.get(i).Name, x+gap+w_step*i, y+gap, w_step-gap, text_size, #FFFF00, #00FF00, #0000FF,text_size));
    }
  }


  boolean TryPlotSubmenu(Button p_btn) {

    MenuTree t = name_map.get(b.indexOf(p_btn));
    println(t.Parents.size());
    if (t.Parents.size()>0)
    {
      if (is_vertical)
        sub_m = new Menu(t, p_btn.x+p_btn.w+2*gap, p_btn.y, 100, 100, l_col, !is_vertical);
      else
        sub_m = new Menu(t, p_btn.x, p_btn.y+p_btn.h+2*gap, 100, 100, l_col, !is_vertical);
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


void reset_buttons(){
    for (Button btn : b) {
      btn.is_light = false;  
      btn.is_active = false;
    }
}
  void reset_menu() {
    sub_m = null; 
    btn_selected = -1;
 
  }


  Button get_clicked_btn() {
    for (Button btn : b) 
      if (btn.is_active) {
        btn.is_active = false;
        return btn;
      }
    return null;
  }

  void ExeCallback() {
    if(btn_selected >= 0){
    MenuTree t = name_map.get(btn_selected);
    if (t.clk != null) t.clk.OnClick(sub_m.btn_selected);
    }
  }

  void check_click(int x, int y) {

    for (Clicable c : b) 
      c.check_click(x, y);
      
    if (sub_m != null) 
    {
      sub_m.check_click(x, y);
      if(sub_m.final_btn_selected)
      {
      ExeCallback();
      final_btn_selected = true;
      reset_menu();
      reset_buttons();
      }
    }
    
    Button pb = get_clicked_btn();
    
    if (pb != null) {
      btn_selected = b.indexOf(pb);
      if (pb.is_light) {//on before
        println("b_light");
        pb.is_light = false;
      
      } else { // off before
      
      pb.is_light = true;
        println("b_not_light");
        if (TryPlotSubmenu(pb)) {//btn with menu
        final_btn_selected = false;
        
          println("b_with_mnu");
        } else {// btn terminal
          println("b_terminal");
          final_btn_selected = true;
          ExeCallback();
           final_btn_selected = true;
        }
      }
      println(pb.text );
    }

  }
}