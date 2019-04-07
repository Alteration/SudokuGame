import java.security.MessageDigest; 

final int SIZE = 9;
ArrayList tiles;
Tile selectedTile;
boolean noteMode;
String uid;

public void setup() {
  size(510, 560);

  tiles = new ArrayList();
  populateTiles();
}

public void draw() {
  if (noteMode) {
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


  println("pressed " + int(key));

  if (selectedTile != null) {
    if (noteMode) {
      selectedTile.enterNotes(letter);
    } else {
      selectedTile.enterValue(letter);
    }
  }
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

    if (_f.getAbsolutePath().endsWith(".psud")) {
      loadPartial(_f);
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
