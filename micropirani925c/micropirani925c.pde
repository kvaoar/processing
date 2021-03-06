import hypermedia.net.*;
import java.net.NetworkInterface;
import java.util.Enumeration;
import java.util.List;
import java.util.Collections;
UDP udp; 

DataStorage values;

DifferentialFilter pfilter;
DifferentialFilter dfilter;

ArrayList<GUIobj> GUIList;
Ticker reg_ask;

float  touchX, touchY;
int  sw = 1900;
int  sh = 900;
int decades = 8;
int start_decade = 3;



int pressure_x = 5;
int pressure_y = (sh/2)+5;
int pressure_h = (sh/2)-10;
int pressure_w = sw-10;



int dpressure_x = 5;
int dpressure_y = 45;
int dpressure_h = sh/2 -5-40;
int dpressure_w = sw - 10;


FloatList s;
int time = 0;
float interval = 1;
int pow = 1;
boolean no_answ = true;

String receivedFromUDP = "";

String message = "@253PR1?;FF"; // the message to send
String ESP_ip = "192.168.1.1"; // the remote IP address
int ESP_port = 8888; // the destination port


void setup() {

  size(1900, 900, P3D);
  println(displayWidth);
  println(displayHeight);

  GUIList = new ArrayList<GUIobj> ();
  values = new DataStorage("Torr",interval);

  
  dfilter = new DifferentialFilter(values,true,true,true);
  pfilter = new DifferentialFilter(values,false,false,true);
  
  reg_ask = new Ticker(interval);

  GUIList.add(new Graph(pressure_x, pressure_y, pressure_w, pressure_h,#7F7F00, decades, start_decade, true, "Torr",interval, pfilter));
  GUIList.add(new Graph(dpressure_x, dpressure_y, dpressure_w, dpressure_h,#7F7F00, decades, start_decade, false, "Torr/s",interval, dfilter));
  GUIList.add(new Button("Start",5 , 10, 90, 16+10, #FFFF00, #00FF00, #0000FF,16, reg_ask));

  MenuTree m1 = new MenuTree("menu", 
    new MenuTree("Settings", 
      new MenuTree("Gas Type",new DiscreteCommand("Change gas type", "GT", "NITROGEN", "ARGON", "HELIUM", "HYDROGEN", "H2O", "NEON", "CO2", "XENON" ),
          new MenuTree("Nitrogen"), 
          new MenuTree("Argon"), 
          new MenuTree("Helium"),
          new MenuTree("Hydrogen"),
          new MenuTree("H2O"),
          new MenuTree("Neon"),
          new MenuTree("CO2"),
          new MenuTree("Xenon")
      ), 
      new MenuTree("Units",new DiscreteCommand("Change units", "U", "TORR", "MBAR", "PASCAL" ),
          new MenuTree("Torr"), 
          new MenuTree("mBar"), 
          new MenuTree("Pascal")
      ), 
      new MenuTree("menuA3")), 
    new MenuTree("menuB"), 
    new MenuTree("menuC"));


  GUIList.add(new Menu(m1, 100, 5, 100, 40, #FFFF00, false));
  /*
  Enumeration<NetworkInterface> nif ;
   try{
   nif = NetworkInterface.getNetworkInterfaces();
   for(NetworkInterface n: Collections.list(nif))
   println(n.getInterfaceAddresses());
   }catch(Throwable t){};
   */
  udp = new UDP( this, 6000);

  // udp.log( true );
  udp.listen( true );
  udp.broadcast( true );


  // println("port: "+udp.port());
  // println(udp.isBroadcast ());
  // println(udp.address());
  // println(receivedFromUDP);

  
}




void draw() 
{

  background(0);
  smooth();
text("FPS: " + frameRate, 1800, 20);

  for (Plottable p : GUIList) p.plot();
  reg_ask.upd();
 
}


void receive(byte[] data, String ip, int port)
{
  receivedFromUDP = new String(data);
 println(receivedFromUDP);
  no_answ = false;
  ESP_ip = ip;
  data = subset(data, 0, data.length);
  String s = new String( data );
  String[] res = match(s, "ACK(.*?);FF");
  if ( res != null) {
    values.add( Float.parseFloat(res[1]));
    pfilter.upd();
    dfilter.upd();
  }
}

void mouseClicked() {
  touchX = mouseX;
  touchY = mouseY;
  for (Clicable c : GUIList) c.check_click(mouseX, mouseY);
}


void mousePressed() {
 for (Clicable c : GUIList) c.check_mousePressed();


}

void mouseDragged() {
for (Clicable c : GUIList) c.check_mouseDragged();

}

void mouseReleased() {
  for (Clicable c : GUIList) c.check_mouseReleased();

}