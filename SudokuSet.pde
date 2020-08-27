class SudokuSet {
  boolean one;
  boolean two;
  boolean three;
  boolean four;
  boolean five;
  boolean six;
  boolean seven;
  boolean eight;
  boolean nine;
  
  SudokuSet(){
    clear();
  }
  
  boolean check(char _v){
    boolean badEntry = false;
    switch(_v){
      case '1':
      if(one) badEntry = true;
      one = true; 
      break;
      case '2':
      if(two) badEntry = true;
      two = true; 
      break;
      case '3':
      if(three) badEntry = true;
      three = true; 
      break;
      case '4':
      if(four) badEntry = true;
      four = true; 
      break;
      case '5':
      if(five) badEntry = true;
      five = true; 
      break;
      case '6':
      if(six) badEntry = true;
      six = true; 
      break;
      case '7':
      if(seven) badEntry = true;
      seven = true; 
      break;
      case '8':
      if(eight) badEntry = true;
      eight = true; 
      break;
      case '9':
      if(nine) badEntry = true;
      nine = true; 
      break;
      default:
      badEntry = true;
    }
    if(badEntry) return false;
    return true;
  }
  
  void clear(){
    one = false;
    two = false;
    three = false;
    four = false;
    five = false;
    six = false;
    seven = false;
    eight = false;
    nine = false;
  }
}
