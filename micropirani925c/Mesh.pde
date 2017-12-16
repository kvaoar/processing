
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
    fill(txt_color, 100);
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