class DifferentialFilter {
  DataStorage v;
  DataStorage r;
  
  boolean diff_on = false;
  boolean filter_exp_on = false;
  boolean log_on = false;

  float last_val = 0;
  boolean first_init = true;
  
  float sym_f_a;
  float sym_f_b;
  
  
  

  DifferentialFilter(DataStorage val, boolean diff, boolean exp_filter, boolean log) {
    diff_on = diff;
    filter_exp_on = exp_filter;
    log_on = log;
    v = val;
   // r = res;
  }
  
  void set_reciever(DataStorage reciever){
  r = reciever;
  }


  float log10 (float x)
  {
    return (log(x) / log(10));
  }

  float delta (float y0, float y1)
  {
   
    return y0 - y1;

  }


  float LogScale(float p) {
    float result  = 0;
    if (p>0)
    {
      result = 5+log10(p);
    } else if (p<0)
    {
      result = 0 - (5+log10(-p));
    } else 
    {
      result = 0;
    }
    return result;
  }

  float exp_filtr(float a) {
    if (!first_init) {
      last_val = 0.8*last_val + 0.2*a;
      return last_val;
    }
    return 0;
  }
  
  float symmetric_filter(float c){
    if(first_init) return 0;
    float res = 0.2*sym_f_a+0.6*sym_f_b+0.2*c;
    sym_f_a = sym_f_b;
    sym_f_b =c;
    return res;
   }

  float delta_i( int pos) {
    return delta(v.get(pos), v.get(pos-1));
  }

  void upd() {
    
    if(r != null){
    if (first_init) {
      if (v.size()>3) {
        last_val = delta_i(1);
        
        sym_f_a = delta_i(1);
        sym_f_b = delta_i(2);
        first_init = false;
      }
    } else {
      int frame = v.size();
      for (int i = r.size()+3; i < frame; i++) {
        float res = 0;
        
        
        if(diff_on)
          res = delta_i(i);
          else
          res = v.get(i);
          
          r.now = res;
          
        if(log_on)
          res = LogScale(res);
          
        if(filter_exp_on)
        res = symmetric_filter(res);
          //res = exp_filtr(res); 
        
      r.add( res);
    }
      
    }
  }
}
}