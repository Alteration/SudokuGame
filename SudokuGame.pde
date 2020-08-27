import java.security.MessageDigest; 

final int SIZE = 9;
ArrayList tiles;
Tile selectedTile;
boolean noteMode;
boolean complete = false;
String uid;

static String[] ColourValues = new String[] { 
        "FF0000", "00FF00", "0000FF", "FFFF00", "FF00FF", "00FFFF", "000000", 
        "800000", "008000", "000080", "808000", "800080", "008080", "808080", 
        "C00000", "00C000", "0000C0", "C0C000", "C000C0", "00C0C0", "C0C0C0", 
        "400000", "004000", "000040", "404000", "400040", "004040", "404040", 
        "200000", "002000", "000020", "202000", "200020", "002020", "202020", 
        "600000", "006000", "000060", "606000", "600060", "006060", "606060", 
        "A00000", "00A000", "0000A0", "A0A000", "A000A0", "00A0A0", "A0A0A0", 
        "E00000", "00E000", "0000E0", "E0E000", "E000E0", "00E0E0", "E0E0E0", 
    };

public void setup() {
  size(510, 560);

  tiles = new ArrayList();
  populateTiles();
}

public void draw() {
  if (complete) {
    background(#00FF00);
    text("Solved!", 510/2, 15);
  }
  else if (noteMode) {
    background(#CB5837);
    text("Note Mode", 510/2, 15);
  } else {
    background(230);
  }

  strokeWeight(1);
  for (int i = tiles.size()-1; i >= 0; i--) {
    Tile temp = (Tile) tiles.get(i);
    temp.draw();
  }

  //Borders
  strokeWeight(3);
  noFill();
  square(30, 30, 50*SIZE);

  square(30, 30, 50*3);
  square(30+(50*3), 30, 50*3);
  square(30+(50*6), 30, 50*3);

  square(30, 30+(50*3), 50*3);
  square(30+(50*3), 30+(50*3), 50*3);
  square(30+(50*6), 30+(50*3), 50*3);

  square(30, 30+(50*6), 50*3);
  square(30+(50*3), 30+(50*6), 50*3);
  square(30+(50*6), 30+(50*6), 50*3);

  //Open Game Button
  strokeWeight(1);
  fill(255, 255, 255);
  rect(30, 490, 100, 30);
  fill(0, 0, 0);
  textAlign(CENTER, CENTER); 
  text("Open File", 80, 505);

  fill(255, 255, 255);
  rect(140, 490, 100, 30);
  fill(0, 0, 0);
  textAlign(CENTER, CENTER); 
  text("Save File", 190, 505);
}

void mouseReleased() {
  if (mouseX > 30 && mouseX < 130 && mouseY > 490 && mouseY < 520) {
    //Open File Pressed
    loadFile();
  }

  if (mouseX > 140 && mouseX < 240 && mouseY > 490 && mouseY < 520) {
    //Save File Pressed
    savePartial();
  }


  for (int i = tiles.size()-1; i >= 0; i--) {
    Tile temp = (Tile) tiles.get(i);
    if (temp.click(mouseX, mouseY) && selectedTile != temp) {
      if (selectedTile != null) {
        selectedTile.deSelect();
      }
      selectedTile = temp;
    }
  }
  
  validate();
}

//#39 = Apostrophe (notes)
//#49 - 57 = 1-9
//#8 or 127 = Delete
void keyPressed() {

  if (selectedTile == null) {
    return;
  }
  
  if (key == 'l') selectedTile.enterNotes(key);

  if (keyCode ==  UP) {
    if (selectedTile.i < 10) {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i+71);
      selectedTile.select();
    } else {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i-10);
      selectedTile.select();
    }
  } else if (keyCode == LEFT) {
    if (selectedTile.i % 9 == 1) {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i+7);
      selectedTile.select();
    } else {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i-2);
      selectedTile.select();
    }
  } else if (keyCode == DOWN) {
    if (selectedTile.i > 72) {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i-73);
      selectedTile.select();
    } else {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i+8);
      selectedTile.select();
    }
  } else if (keyCode == RIGHT) {
    if (selectedTile.i % 9 == 0) {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i-9);
      selectedTile.select();
    } else {
      selectedTile.deSelect();
      selectedTile = (Tile) tiles.get(selectedTile.i);
      selectedTile.select();
    }
  }

  char letter = key;
  if (!((key >= 49 && key <= 57) || key == 39 || key == 8 || key == 127 ) || (noteMode && (key == 8 || key == 127))) {
    return;
  }

  if (key == 39) {
    noteMode = !noteMode;
    return;
  }


  //println("pressed " + int(key));

  if (selectedTile != null) {
    if (noteMode) {
      selectedTile.enterNotes(letter);
    } else {
      complete = false;      
      selectedTile.enterValue(letter);
    }
  }
  validate();
}

void populateTiles() {

  if (tiles.size() > 0) return;
  int counter = 0;
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      tiles.add(new Tile(30 + (50*j), 30 + (50*i), 50, ++counter));
    }
  }
}

void loadFile() {
  selectInput("Select a Sudoku File", "fileSelected");
}

void savePartial() {
  PrintWriter writer;
  String temp = "";
  for (int i = 0; i < tiles.size(); i++) {
    char val = ((Tile) tiles.get(i)).val;
    if (val == 0 || val == 8 || val == 127) val = '0';
    temp += val;
  }

  if (uid == null) {
    try {
      MessageDigest digester = MessageDigest.getInstance("SHA-512");
      byte[] digested = digester.digest(temp.getBytes());
      StringBuilder buff = new StringBuilder();

      for (byte b : digested) {
        String conv = Integer.toString(b & 0xFF, 16);
        while (conv.length() < 2) {
          conv = "0" + conv;
        }
        buff.append(conv);
      }

      uid = buff.toString();
    }
    catch(Exception ex) {
      println("Missing SHA-512 Algorithm");
    }
  }

  writer = createWriter(uid + ".psud");

  //values
  writer.println(temp);
  //notes
  temp = "";
  for (int i = 0; i < tiles.size(); i++) {
    temp += ((Tile) tiles.get(i)).getNotes();
    if (i < tiles.size()-1) temp += ".";
  }
  writer.println(temp);
  //options
  temp = "";
  for (int i = 0; i < tiles.size(); i++) {
    if (((Tile) tiles.get(i)).l) temp += "1";
    else temp+= 0;
  }
  writer.println(temp);

  writer.flush();
  writer.close();
}

void fileSelected(File _f) {
  if (_f == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    complete = false;
    if (_f.getAbsolutePath().endsWith(".psud")) {
      loadPartial(_f);
      validate();
      return;
    }

    if (tiles.size() > 0) tiles.clear();
    BufferedReader reader = createReader(_f.getAbsolutePath());
    String line = null;
    try {
      line = reader.readLine();
      if (line.length() == 81) {
        println("single line file");
        inputLine81(line);
      } else if (line.length() == 18) {
        String newLine;
        newLine = line;
        while ((line = reader.readLine()) != null) {
          newLine += line;
        }
        newLine = newLine.replaceAll("\\s+", "");
        inputLine81(newLine);
      }
      reader.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    validate();
  }
}

void inputLine81(String _l) {
  int counter = 0;
  try {
    MessageDigest digester = MessageDigest.getInstance("SHA-512");
    byte[] digested = digester.digest(_l.getBytes());
    StringBuilder buff = new StringBuilder();

    for (byte b : digested) {
      String conv = Integer.toString(b & 0xFF, 16);
      while (conv.length() < 2) {
        conv = "0" + conv;
      }
      buff.append(conv);
    }

    uid = buff.toString();
  }
  catch(Exception ex) {
    println("Missing SHA-512 Algorithm");
  }

  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      char w = _l.charAt(counter);
      if (w != '0') {
        tiles.add(new Tile(30 + (50*j), 30 + (50*i), 50, ++counter, w));
      } else {
        tiles.add(new Tile(30 + (50*j), 30 + (50*i), 50, ++counter));
      }
    }
  }
}

void loadPartial(File _f) {

  if (tiles.size() > 0) tiles.clear();
  BufferedReader reader = createReader(_f.getAbsolutePath());
  String line = null;
  try {
    //Get layout
    line = reader.readLine();
    inputLine81(line);

    //Get Notes
    line = reader. readLine();
    String[] splitLine = line.split("\\.");
    for (int i = 0; i < 81; i++) {
      String[] splitNotes = splitLine[i].split(",");
      for (int j = 0; j < 9; j++) {
        String note = splitNotes[j];

        if (j == 0) note = note.substring(1, 2);
        else if (j == 8) note = note.substring(0, 1);

        if (note.equals("1")) {
          ((Tile) tiles.get(i)).notes[j] = true;
        } else {
          ((Tile) tiles.get(i)).notes[j] = false;
        }
      }
    }

    //Set Locks
    line = reader. readLine();
    for (int i = 0; i < line.length()-1; i++) {
      if (line.substring(i, i+1).equals("0")){
        ((Tile) tiles.get(i)).l = false;
      } else {
        ((Tile) tiles.get(i)).l = true;
      }
      
      ((Tile) tiles.get(i)).deSelect();
    }
    
    uid = _f.getName().substring(0, _f.getName().length() - 5);
    
    reader.close();
    draw();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

boolean validate() {
  boolean solutionValid = true;
  
  //row check
  for(int row = 0; row < SIZE; row++){
    SudokuSet validator = new SudokuSet();
    boolean containsInvalid = false;
    int rowStart = 0+(SIZE * row);
    for(int column = 0; column < SIZE; column++){
      int currentIndex = rowStart+column;
      if(!validator.check(((Tile) tiles.get(currentIndex)).val)){
        //((Tile) tiles.get(currentIndex)).c = #FF0000;
        return false;
      }
    }
    //if(!containsInvalid) println("Row Valid");
  }
  //println("rowcheck Complete");
  
  //column check
  for(int column = 0; column < SIZE; column++){
    SudokuSet validator = new SudokuSet();
    boolean containsInvalid = false;
    int columnStart = column;
    for(int row = 0; row < SIZE; row++){
      int currentIndex = columnStart+(SIZE * row);
      if(!validator.check(((Tile) tiles.get(currentIndex)).val)){
        //((Tile) tiles.get(currentIndex)).c = #FF0000;
        return false;
      }
    }
    //if(!containsInvalid) println("Column Valid");
  }
  
  //grid check
  /*
  0,1,2
  9,10,11
  18,19,20
  */
  int state = 0;
  //substr(md5($number),6)
  for(int columnOffset = 0; columnOffset < 3; columnOffset++){
    state++;
    for(int offset = 0; offset < 3; offset++){
      state++;
      SudokuSet validator = new SudokuSet();
      for(int rowStep = 3*columnOffset; rowStep < 3+(3*columnOffset); rowStep++){
        for(int columnStep = 3*offset; columnStep < 3+(3*offset); columnStep++){
          int currentIndex = (SIZE * rowStep)+columnStep;
          if(!validator.check(((Tile) tiles.get(currentIndex)).val)){
            //((Tile) tiles.get(currentIndex)).c = #FF0000;
            return false;
          }
          //((Tile) tiles.get(currentIndex)).c = color(unhex("FF" + ColourValues[state]));
          //println(currentIndex);
        }
      }
    }
  }
  
  //return false;
  //println("Solution Valid");
  complete = true;
  return true;
}
