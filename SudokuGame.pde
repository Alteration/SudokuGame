final int SIZE = 9;
ArrayList tiles;
Tile selectedTile;
boolean noteMode;

public void setup() {
  size(510, 510);

  tiles = new ArrayList();
  loadFile();
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
}

void mouseClicked() {
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
  if (!((key >= 49 && key <= 57) || key == 39 || key == 8 || key == 127)) {
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

void loadFile() {
  selectInput("Select a Sudoku File", "fileSelected");
}

void fileSelected(File _f) {
  if (_f == null) {
    println("Window was closed or the user hit cancel.");
    int counter = 0;
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        tiles.add(new Tile(30 + (50*j), 30 + (50*i), 50, ++counter));
      }
    }
  } else {
    BufferedReader reader = createReader(_f.getAbsolutePath());
    String line = null;
    try {
      line = reader.readLine();
      if(line.length() == 81){
        println("single line file");
        inputLine81(line);
      } else if (line.length() == 18){
        String newLine;
        newLine = line;
        while((line = reader.readLine()) != null){
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
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      char w = _l.charAt(counter);
      if(w != '0'){
        tiles.add(new Tile(30 + (50*j), 30 + (50*i), 50, ++counter, w));
      }else{
        tiles.add(new Tile(30 + (50*j), 30 + (50*i), 50, ++counter));
      }
    }
  }
}
