class Graph extends GUIobj { //<>//
  boolean is_bar;

  int text_size = 18;
  int left_label = 100;
  int bot_label = 30;
  ///int start_index;

  int x0;
  int y0;
  int capacity;
  int data_offset;
  DataStorage d;
  DifferentialFilter filter;
  FloatList plot_data;
  Mesh m_y;
  Mesh m_x;

  ArrayList<Cursor> user_cursors;

  color plus = #FF0000;
  color minus = #0000FF;
  color txt_col = #00FF00;
  color cursor_col = #005F5F;

  Graph(int graph_x, int graph_y, int graph_w, int graph_h, color gcol, int graph_decades, int graph_start_decade, boolean bars, String unit, float interval, DifferentialFilter f) {
    super(graph_x, graph_y, graph_w, graph_h, gcol);
    user_cursors = new ArrayList<Cursor>();
    x0 = x+left_label;
    y0 = y+h-bot_label;
    
    m_y = new Mesh(x, y, w, h-bot_label, l_col, txt_col, graph_decades, graph_start_decade, unit, text_size);
    m_x = new Mesh(x+left_label-gap, y, w, h, l_col, txt_col, true, 60*5, 5, "min", text_size);
   
    d =  new DataStorage(unit,interval);
    
    capacity = w-left_label-2*gap;
    is_bar = bars;
    filter = f;
    f.set_reciever(d);

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

    if (user_cursors.size()>0) {
      
      for(int i = 0; i < user_cursors.size(); i++)if (user_cursors.get(i).terminate) {user_cursors.remove(i); println( user_cursors.size());}

      for (Cursor c : user_cursors)  c.plot();
      
      if(user_cursors.size()>=2){
      Cursor a = user_cursors.get(0);
      Cursor b = user_cursors.get(1);
      text(label(b.val-a.val), 550, 10);
      }
      
    }
  }


  String label(float val) {

    String label = "";
    if (abs(val)>=1) {
      label = String.format("%.02f",val)+" "+d.unit;
    } else 
    if (abs(val)>=1e-3) {
      label = String.format("%.2f",val*1e3)+" "+d.pps+d.unit;
    } else
    { 
      label = String.format("%.2f",val*1e6)+" "+d.ppm+d.unit;
    }
    return label;
  }

  void plot() {


    if (d.size()> capacity)
    data_offset = d.size()-capacity;
    else
    data_offset = 0;
    
    plot_data = d.getSubset(data_offset);
    
    plot_area();

    

    if (d.size() > 1)
    {

      strokeWeight(2);
      stroke(plus, 255);
      fill(txt_col, 255);
      textAlign(LEFT);
      textSize(text_size );

      text(label(d.now), x+left_label, y+gap+text_size);
    }




    strokeWeight(2);
    stroke(plus, 255);
    noFill();
    beginShape();
    

    for (int i = 1; i < plot_data.size(); i++) {
      int plot_x = x0+i;
      float point0 = plot_data.get(i-1);
      float point1 = plot_data.get(i);
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


void reset_all_cursors(){
user_cursors.clear();
}


  void check_click(int px, int py) {

    if ((px< x+w)&&(px>x)&&(py<y+h)&&(py>y)&&(mouseButton == LEFT)) {
      Cursor u = new Cursor(this,x+left_label, y, w-left_label, h-bot_label, l_col, txt_col, text_size);
      u.move(null, px, py);
      user_cursors.add(u);
    }
  }


  void check_mouseDragged() {
    if (user_cursors.size()>0) for (Cursor c : user_cursors) c.check_mouseDragged();
  };

  void check_mousePressed() {
    if (user_cursors.size()>0) for (Cursor c : user_cursors) c.check_mousePressed();
  };

  void check_mouseReleased() {
    if (user_cursors.size()>0) for (Cursor c : user_cursors) c.check_mouseReleased();
  };
}