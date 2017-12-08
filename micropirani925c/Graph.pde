class Graph extends GUIobj {
  boolean is_bar;

  int text_size = 16;
  int left_label = 100;
  int bot_label = 30;
  int start_index;
  
  int x0;
  int y0;

  DataStorage d;
  Mesh m_y;
  Mesh m_x;
  Cursor c_current;

  color plus = #FF0000;
  color minus = #0000FF;
  color txt_col = #00FF00;
  color cursor_col = #005F5F;

  Graph(int graph_x, int graph_y, int graph_w, int graph_h, color gcol, int graph_decades, int graph_start_decade, boolean bars, DataStorage data) {
    super(graph_x, graph_y, graph_w, graph_h, gcol);
    x0 = x+left_label;
    y0 = y+h-bot_label;
    m_y = new Mesh(x, y, w, h-bot_label, l_col, txt_col, graph_decades, graph_start_decade, data.unit, text_size);
    m_x = new Mesh(x+left_label-gap, y, w, h, l_col, txt_col, true, 60*5, 5, "min", text_size);
    c_current = new Cursor(x, y, w, h, cursor_col,txt_col);
    d = data;
    is_bar = bars;
    start_index = 1;
  }


  void plot_area() {
    strokeWeight(2);
    stroke(l_col, 255);
    fill(0, 0, 0, 255);
    rect(x, y, w, h);

    strokeWeight(1);
    stroke(l_col, 255 );
    fill(txt_col);
    line(left_label, y, left_label, y+h); 
    line(x, y0, x+w, y0); 

    textSize(text_size );
    textAlign(LEFT);
    m_x.plot();
    m_y.plot();
    c_current.plot();
  }


  String label(float val) {

    String label = "";
    if (abs(val)>=1) {
      label = round(val)+" "+d.unit;
    } else 
    if (abs(val)>=1e-3) {
      label = round(val*1e3)+" "+d.pps+d.unit;
    } else
    { 
      label = round(val*1e6)+" "+d.ppm+d.unit;
    }
    return label;
  }

  void plot() {

    plot_area();

    if (d.size() > 1)
    {
      fill(txt_col, 255);
      if (is_bar) c_current.move(label(d.now), x+left_label+d.size(), y0-abs(m_y.decade_h*d.get_last()));
      else text(label(d.now), x+left_label, y+gap+text_size);
    }

    if (d.size() > w-left_label) d.clear();

int capacity = w-left_label;
if(d.size()> capacity) start_index = (d.size()-1-capacity);


    strokeWeight(2);
    stroke(plus, 255);
    noFill();
    beginShape();
    
    for (int i = start_index; i < d.size(); i++) {
      int plot_x = x0+i - start_index;
      float point0 = d.get(i-1);
      float point1 = d.get(i);
      if (point0>0) {
        stroke(plus, 255);
        curveVertex(plot_x, y0-abs(point0*m_y.decade_h));
        curveVertex(plot_x, y0-abs(point1*m_y.decade_h));
      } else {
        stroke(minus, 255);
        curveVertex(plot_x, y0-abs(point0*m_y.decade_h));
        curveVertex(plot_x, y0-abs(point1*m_y.decade_h));
      }
    }
    endShape();
  }
}



class Cursor extends GUIobj {
  float px;
  float py;
  String text;
  color text_color;
  Cursor(int cx, int cy, int cw, int ch, color cc, color txt) {
    super(cx, cy, cw, ch, cc);
    text_color = txt;
  }
  void plot() {
    strokeWeight(1);
    stroke(l_col, 200);
    line(px, y, px, y+h);
    line(x, py, x+w, py);
    ellipseMode(CENTER);
    noFill();
    ellipse(px, py, 10, 10);
    if (text!= null) {
      fill(text_color,200);
      text(text, px+10, py+10);
    }
  }

  void move( String val, float set_x, float set_y) {
    px = set_x;
    py = set_y;
    text = val;
  }
}


class MeshLine {
  String text;
  float text_pos;
  float pos;
  MeshLine(String s, float ml_text_pos, float ml_pos) {
    text=s; 
    text_pos = ml_text_pos; 
    pos = ml_pos;
  }
}

class Mesh extends GUIobj {
  boolean is_horisontal;
  boolean is_linear;
  String unit;
  int step;
  float step_nom;
  int decades;
  int start_decade;
  int neg_decade;
  float decade_h;
  int text_size;
  ArrayList<MeshLine> lines;
  color txt_color;
  
  Mesh (int x, int y, int w, int h, color c, color txt, boolean horisontal, int m_step_size, float m_step_nom, String m_unit, int m_text_size  ) {
   super(x, y, w, h, c);
   is_horisontal = horisontal;
   is_linear = true;
   step = m_step_size;
   step_nom = m_step_nom;
   unit = m_unit;
   text_size = m_text_size;
   txt_color = txt;
   
   int step_cnt = w/step;
    lines = new ArrayList<MeshLine>();
    for (int i = 0; i < step_cnt; i++)
      lines.add(new MeshLine(i*step_nom+" "+unit, i*step, i*step));
   }

  Mesh(int x, int y, int w, int h, color c, color txt, int m_decades, int m_start_decade, String m_unit, int m_text_size ) {
    super(x, y, w, h, c);
    is_horisontal = false;
    is_linear = false;
    decades = m_decades;
    start_decade = m_start_decade;
    neg_decade = decades - start_decade;
    decade_h = h/decades;
    unit = m_unit;
    text_size = m_text_size;
    txt_color = txt;

    lines = new ArrayList<MeshLine>();
    for (int i = 0; i < decades; i++)
      lines.add(new MeshLine("10^"+((start_decade-i-1)), decade_h*(i+1)-text_size, decade_h*i));
  }

  float log10 (float x)
  {
    return (log(x) / log(10));
  }

  float LogScale(float p) {
    return neg_decade+log10(p);
  }

  void plot() {
    strokeWeight(1);
    stroke(l_col, 100);
    fill(txt_color,100);
    if (lines != null) {
      for (MeshLine l : lines) 
        if (!is_horisontal) {
          text(l.text, x+ 2*gap, y+l.text_pos);
          line(x, y+l.pos, x+w, y+l.pos);
        } else {
          text(l.text, x+l.text_pos+2*gap, y+h-2*gap);
          line(x+l.pos, y, x+l.pos, y+h);
        }
    }
  }
}