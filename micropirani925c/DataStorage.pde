
class DataStorage {
  FloatList data;
  String unit;
  String pps = "m";
  String ppm = "u";
  float now;
  float timestep;
  
  DataStorage(String s_unit, float timestep) {
    unit = s_unit;
    data = new FloatList();
  }
  void add(float value) {
    data.append(value);
  }

  int size() {
    return data.size();
  }

  float get(int i) {
    return data.get(i);
  }

  void clear() {
    data.clear();
  }
  
  FloatList getSubset(int from){
    
  return data.getSubset(from);
  }
  
 float get_last() {
    if (data.size()>0)
      return data.get(data.size()-1);
    else return 0;
  }
}