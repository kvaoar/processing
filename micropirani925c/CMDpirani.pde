interface ClickCallback {
  void OnClick(int parent);
   void OnClick(Button parent);
}


class Command {
  String description;
  String prefix;

  Command(String descr, String pref) {
    description = descr;
    prefix = pref;
  }
}

class DiscreteCommand extends Command implements ClickCallback{
  ArrayList<String> values;

  DiscreteCommand(String descr, String pref, String... vars) {
        super(descr, pref);
    values = new ArrayList<String>();

    for (String s : vars) values.add(s);
  }


  void OnClick(int parent) {
    println("CMD="+parent);
    if ((parent>0)&&(parent < values.size())) {
      
    } 
    

  }
  
       void OnClick(Button parent){}
}

class CMDpirani {
  ArrayList<Command> cmd_list;

  CMDpirani() {
    cmd_list = new ArrayList<Command>();

    add_commands(
      new DiscreteCommand("Change gas type", "GT", "NITROGEN", "ARGON", "HELIUM", "HYDROGEN", "H2O", "NEON", "CO2", "XENON" ), 
      new DiscreteCommand("Change units", "U", "TORR", "MBAR", "PASCAL" ), 
      new Command("Zero pressure", "VAC"), 
      new Command("Full 760 torr pressure", "ATM"), 
      new Command("Zero pressure", "VAC")
      );
  }

  void add_commands(Command... vals) {
    for (Command c : vals) cmd_list.add(c);
  }
}