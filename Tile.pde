class Tile {
  int x,y,s,i;
  color c;
  char val;
  boolean[] notes;
  boolean l;
  
  Tile(int _x, int _y, int _s, int _i) {
    x = _x;
    y = _y;
    s = _s;
    i = _i;
    l = false;
    c = color(#D8D6D6);
    notes = new boolean[9];
  }
  
  Tile(int _x, int _y, int _s, int _i, char _v) {
    x = _x;
    y = _y;
    s = _s;
    i = _i;
    val = _v;
    l = true;
    if(l) c = color(#BCB6B6);
    if(!l) c = color(#D8D6D6);
    notes = new boolean[9];
  }
  
  void draw(){
    fill(c);
    if(selectedTile != null &&  val == selectedTile.val && val != 0 && selectedTile != this && selectedTile.val != 8 && selectedTile.val != 127) fill (#98B9C1);
    square(x,y,s);
    fill(0,0,0);
    textSize(32);
    textAlign(CENTER,CENTER); 
    if(val >= '1' && val <= '9') text(val, x + (s/2), y + (s/2));
    textSize(12);
    for(int i = 0; i < 9; i++){
      if(notes[i] && !(val >= '1' && val <= '9')){
        text(i+1,
          x + ((s/4) + ((s/4) * (i%3))),
          y + ((s/4) + (i / 3) * (s / 4)));
      }
    }
  }
  
  void select(){
    if(l) c = color(#98B9C1);
    if(!l) c = color(#9DD8E8);
  }
  
  void deSelect(){
    if(l) c = color(#BCB6B6);
    if(!l) c = color(#D8D6D6);
  }
  
  boolean click(int _x, int _y){
    if(_x > x && _y > y && _x < (x+s) && _y < (y+s)){
      select();
      return true;
    }
    
    return false;
  }
  
  void enterNotes(char _n){
    if (!l && _n == 'l') l = true;
    if (l && (_n < '1' || _n > '9')) return;
    notes[Character.getNumericValue(_n)-1] = !notes[Character.getNumericValue(_n)-1];
  }
  
  void enterValue(char _v){
    if (l) return;
    if (val == _v){
      val = 8;
      return;
    }
    val = _v;
  }
  
  String getNotes(){
    String out = "[";
    for (int i = 0; i < 9; i++){
      if(notes[i]) out += '1';
      else out += '0';
      if (i < 8)  out += ","; 
    }
    out += "]";
    return out;
  }
}
