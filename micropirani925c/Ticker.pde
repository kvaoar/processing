class Ticker implements ClickCallback{
  boolean is_run;
  int interval_ms;
  int time;
  Ticker(int ms){
   is_run = false;
  interval_ms = ms;
  time = millis();//store the current time
  }
  
    Ticker(float s){
   is_run = false;
  interval_ms = round(s*1000);
  time = millis();//store the current time
  }
  
 void OnClick(int parent){
 
 
 };
 
  void OnClick(Button parent){
  is_run = !is_run;
  parent.is_light = is_run;
  }
 
 void upd(){
 if(is_run)
  if (millis() - time >= interval_ms)
  {
    udp.send( message, ESP_ip, ESP_port );
    no_answ = true;
    time = millis();
  }
 }
} 