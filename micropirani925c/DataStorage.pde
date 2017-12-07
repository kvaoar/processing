
class DataStorage {
  FloatList data;
  DataStorage() {
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
  
 float get_last() {
    if (data.size()>0)
      return data.get(data.size()-1);
    else return 0;
  }
}