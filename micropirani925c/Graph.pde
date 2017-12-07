class Graph extends GUIobj {
  boolean is_bar;
  String unit = "torr";
  int text_size = 16;
  int left_label = 100;
  DataStorage d;

  int decades;
  int start_decade;
  float decade_h ;

  Graph(int graph_x, int graph_y, int graph_w, int graph_h, int graph_decades, int graph_start_decade, boolean bars, DataStorage data) {
    super(graph_x, graph_y, graph_w, graph_h, #FFFF00);

    decades = graph_decades;
    start_decade = graph_start_decade;
    decade_h = h/decades;
    d = data;
    is_bar = bars;
  }

  float log10 (float x)
  {
    return (log(x) / log(10));
  }

  float delta (float y0, float y1)
  {
    float result;

    float r = y1 - y0;

    if (r>0)
    {
      result = 5+log10(y1-y0);
    } else if (r<0)
    {
      result = 0 - (5+log10( y0-y1));
    } else 
    {
      result = 0;
    }

    return result;
  }

  float LogScale(float p) {
    return 5+log10(p);
  }
  
  
  void plot_area() {
    strokeWeight(1);
    stroke(250, 250, 0, 100 );


    line(x, y, x+w, y); 
    line(x, y, x, y+h);
    line(x+w, y, x+w, y+h); 
    line(x, y+h, x+w, y+h);

    strokeWeight(1);
    stroke(250, 250, 0, 100 );
    fill(0, 200, 0);
    line(left_label, y, left_label, y+h); 


    textSize(text_size );
    textAlign(LEFT);


    for (int i = 0; i < decades; i++)
    {
      line(x, y+decade_h*i, x+w, y+decade_h*i);
      text("10^"+((start_decade-i-1)), 4, y+(decade_h*i)-text_size+decade_h);
    }
  }

  void plot() {
    if (is_bar) plot_graph_bars();
    else plot_graph_log();
  }

  void plot_graph_bars() {
    plot_area();



    if (d.size() > w-left_label) d.clear();
    if (d.size() > 1)
    {
      strokeWeight(1);

      float p0 =d.get(d.size()-2);
      float p1 =d.get(d.size()-1);
      text((p1-p0)+" "+unit, x+(left_label/2), y+text_size);
      for (int i = 1; i < (d.size()); i++)
      {

        p0 =d.get(i-1);
        p1 =d.get(i);

        float dp = delta(p1, p0);


        if (abs(dp)>(p0/100)) {
          if (dp>0) {
            stroke(255, 0, 0, 255);
            fill(255, 0, 0, 255);
            line( x+i+left_label, y+h, x+i+left_label, y+h-decade_h*dp);
          }
          if (dp<0) {
            stroke(0, 0, 255, 255);
            fill(0, 0, 255, 255);

            line( x+i+left_label, y+h, x+i+left_label, y+h+decade_h*dp);
          }
        }
      }
    }
  }

  void plot_graph_log() {
    plot_area();

    if (d.size()>0) {
      float val = d.get_last();

      text(val+" "+unit, x+(left_label/2), y+h-decade_h*LogScale(val)+text_size); 
      line(x+left_label, y+h-decade_h*LogScale(val), x+w, y+h-decade_h*LogScale(val));
    }


    if (d.size() > w-left_label) d.clear();
    if (d.size() > 3)
    {
      strokeWeight(1);
      stroke(255, 0, 0, 255);
      for (int i = 1; i < d.size(); i++)
      {

        float p0 =d.get(i-1);
        float y0 = LogScale(p0);
        float p1 =d.get(i);
        float y1 = LogScale(p1);


        line(x+(i-1)+left_label, y+h-decade_h*y0, x+i+left_label, y+h-decade_h*y1);
      }
    }
  }
}