/* Written by Tommy Sebesyen
 * Purpose: This class handles the "real" x and y positions of 
 * objects on the playfield.  It uses blockSize, gameWidth, and
 * gameHeight to calculate the real playfield size based on the 
 * window size.
 */

class Field {

  float sizex; // Width of the playfield in blocks.
  float sizey; // Height of the playfield in blocks.
  float sizeb; // Diameter of each block.
  ArrayList<Integer> shapes = new ArrayList<Integer>(); // Array for calculating shapes, to ensure you never get the same shape twice (as per Tetris standard)
  ArrayList<Block> blocks = new ArrayList<Block>(); // Array of Blocks that make up the game field.
  int moveDir; // Direction and distance to move a falling shape
  int linesCleared = 0; // How many lines have been cleared

  float centerx; // Center constants
  float centery; // Center constants

  // Various color constants
  final color purple = color(184, 2, 253);
  final color red = color(254, 16, 60);
  final color green = color(102, 253, 0);
  final color yellow = color(255, 222, 0);
  final color orange = color(255, 115, 8);
  final color dblue = color(24, 1, 255);
  final color lblue = color(0, 230, 254);

  // Default constructor (should not be used)
  Field() {
    sizex = 10;
    sizey = 20;
    sizeb = 5;
    println("ERROR: Something called an uninitialized Field.  This should not happen.");
  }

  // x - the desired playfield width, in blocks
  // y - the desired playfield height, in blocks
  // b - the desired block size, in pixels
  Field(float x, float y, float b) {
    // Set internal fields to constructor parameters
    sizex = x;
    sizey = y;
    sizeb = b;

    // Set the center constants
    centerx = x/2;
    centery = y/2;

    // Log
    println("New Field initialized");
  }

  // Initalize a new arrangement of blocks based on Tetris standards
  // t - the type of formation desired to be created
  void initializeShape(String t) {
    for (int i=blocks.size()-1; i>=0; i--) {
      if (blocks.get(i).bx==centerx && blocks.get(i).by==0) return;
    }

    // Choose between arrangements
    switch(t) {
    default:
    case "t": // T is the default formation
      blocks.add(new Block(purple, centerx, 0));
      blocks.add(new Block(purple, centerx, 1));
      blocks.add(new Block(purple, centerx-1, 1));
      blocks.add(new Block(purple, centerx+1, 1));
      print("T");
      break;
    case "s":
      blocks.add(new Block(red, centerx, 0));
      blocks.add(new Block(red, centerx+1, 0));
      blocks.add(new Block(red, centerx+2, 0));
      blocks.add(new Block(red, centerx-1, 0));
      print("S");
      break;
    case "z":
      blocks.add(new Block(green, centerx, 0));
      blocks.add(new Block(green, centerx, 1));
      blocks.add(new Block(green, centerx+1, 1));
      blocks.add(new Block(green, centerx-1, 0));
      print("Z");
      break;
    case "i":
      blocks.add(new Block(yellow, centerx, 0));
      blocks.add(new Block(yellow, centerx, 1));
      blocks.add(new Block(yellow, centerx, 2));
      blocks.add(new Block(yellow, centerx, 3));
      print("I");
      break;
    case "l":
      blocks.add(new Block(orange, centerx, 0));
      blocks.add(new Block(orange, centerx, 1));
      blocks.add(new Block(orange, centerx, 2));
      blocks.add(new Block(orange, centerx+1, 2));
      print("L");
      break;
    case "j":
      blocks.add(new Block(dblue, centerx, 0));
      blocks.add(new Block(dblue, centerx, 1));
      blocks.add(new Block(dblue, centerx, 2));
      blocks.add(new Block(dblue, centerx-1, 2));
      print("J");
      break;
    case "o":
      blocks.add(new Block(lblue, centerx, 0));
      blocks.add(new Block(lblue, centerx, 1));
      blocks.add(new Block(lblue, centerx+1, 0));
      blocks.add(new Block(lblue, centerx+1, 1));
      print("O");
      break;
    }

    // Log
    println(" Shape created.");
  }

  void display() {
    // Use the CENTER mode for easy calculation
    rectMode(CENTER);

    // Fill colour to white
    fill(color(255, 255, 255));

    // Draw a rectangle
    // The center of the rectangle is in the center of the screen
    // The width is (block size+3)*horizontal size of the board
    // The height is (block size+3)*vertical size of the board
    float w = (sizeb+3)*(sizex+1);
    float h = (sizeb+3)*(sizey+2);
    rect(width/2, height/2, w, h, 5);

    rectMode(CORNER);

    // Iterate through the blocks in the field
    for (int i=0; i<blocks.size(); i++) {
      // Set a few local variables to reduce confusion
      float x = blocks.get(i).bx;
      float y = blocks.get(i).by;
      float s = sizeb;
      color c = blocks.get(i).col;

      // Do some preliminary calculations
      x = ((width/2)-(w/2))+(s+3)*x;
      y = ((height/2)-(h/2))+(s+3)*y;

      fill(c);
      rect(x, y, s, s);
    }
  }

  // Update the position of any blocks that need their position updated
  void update() {
    // Logic for dropping blocks ------------------------
    // Amount of blocks that are falling
    int falling=0;
    boolean clearingLine=false;

    // Iterate through the blocks in the field
    for (int i=blocks.size()-1; i>=0; i--) {
      print("Block #"+i+" ");
      print("x-"+blocks.get(i).bx+" y-"+blocks.get(i).by+" ");
      // Whether to stop the block
      boolean stop = false;

      // If the block is falling
      if (blocks.get(i).fall) {

        // Add 1 to our falling counter
        falling++;
        print("falling ");

        // Check if the block is below the end of the screen
        if (blocks.get(i).by>=sizey) stop=true;

        // Check if the block has a block below it
        // Iterate through all blocks
        for (int j=blocks.size()-1; j>=0; j--) {
          // If the y value of j is below i
          if (blocks.get(j).by==blocks.get(i).by+1) {
            // If the x values are the same
            if (blocks.get(j).bx==blocks.get(i).bx) {
              // If j is not falling
              if (!blocks.get(j).fall) {
                // Stop i from falling
                stop=true;
                print("below ");
                break;
              }
            }
          }
        }

        // Stop falling if stop is true
        if (stop) blocks.get(i).fall = false;

        // Push the block's position down
        if (!stop) blocks.get(i).by++;
      }
      println("");
    }
    moveDir = 0;

    // Check for lines to be cleared
    if (falling>0) 
      clearingLine=true;

    // Logic for clearing lines --------------------
    // If no blocks are falling
    if (clearingLine) {
      // Iterate through each line
      for (int i=int(sizey); i>0; i--) {
        print("Line #"+i+" ");
        // How many blocks are on this line
        int howMany=0;

        // Iterate through the blocks on the field
        for (int j=0; j<blocks.size(); j++) {
          // If the block is at this line, count it
          if (blocks.get(j).by==i) howMany++;
        }
        print(howMany+" ");
        // If there are more blocks on this line than the width of the field, clear this line
        if (howMany>sizex) {
          removeLine(i);
          print("removed #"+i+" ");
        }
        //else if (falling==0) clearingLine = false;
        println("");
      }
    }
    // If no blocks are falling and we aren't clearing a line, add a new shape
    if (!clearingLine && falling==0) initializeShape(calculateNextShape());
  }

  // Remove a line of blocks from the field and update the blocks above to fall.
  void removeLine(float line) {
    linesCleared++;
    // Iterate through all lines before the one to be removed
    for (int i=0; i<line; i++) {
      print("Line #"+i+" ");
      // Iterate through the blocks on the field
      for (int j=blocks.size()-1; j>=0; j--) {
        // If the block is at the current line
        if (blocks.get(j).by==i) {
          int under=0;
          // Iterate through the blocks on the field
          for (int k=blocks.size()-1; k>=0; k--) {
            under=0;
            // If there is a block under this one
            if (blocks.get(j).bx==blocks.get(k).bx &&
              blocks.get(j).by==blocks.get(k).by-1) under++;
          }
          // If there are no blocks under this one, drop it
          if (under<=0) blocks.get(j).fall=true;
          print("drop #"+j+" ");
        }
      }
      println("");
    }

    // Iterate through the blocks on the field
    for (int i=blocks.size()-1; i>=0; i--) {
      // Remove blocks on the line to be removed
      if (blocks.get(i).by==line) blocks.remove(i);
    }
  }

  // Select a random shape out of the available shapes.
  String calculateNextShape() {
    float chosenShape=0;
    // If there are no shapes left in the array, re-initialize it
    if (shapes.size()<=0) {
      for (int i=1; i<=7; i++) {
        shapes.add(i);
      }
    }
    // Choose a random index in the array
    chosenShape = random(float(shapes.size()-1));

    // What to return based on the shape chosen
    switch(shapes.get(int(chosenShape))) {
    case 1:
      return "t";
    case 2:
      return "s";
    case 3:
      return "z";
    case 4:
      return "i";
    case 5:
      return "l";
    case 6:
      return "j";
    case 7:
      return "o";
    default:
      return "";
    }
  }

  // Move the shape formation
  // dir - the direction the shape should move
  void moveShape(int dir) {
    // Amount of blocks that are falling
    int falling=0;
    
    // Iterate through the blocks in the field
    for (int i=blocks.size()-1; i>=0; i--) {

      // If the block is falling, increment the counter
      if (blocks.get(i).fall) falling++;
    }

    // If there are 4 blocks falling (i.e a shape)
    if (falling==4) {
      // Iterate through the blocks in the field
      for (int i=blocks.size()-1; i>=0; i--) {
        // If the block is falling
        if (blocks.get(i).fall) {
          // If the block is outside the field
          if (blocks.get(i).bx>=sizex) {
            // Stop moving the block
            moveDir=-1;
          }
          if (blocks.get(i).bx<=0) {
            // Stop moving the block
            moveDir=1;
          }
        }
      }
      // Move the falling blocks on the field
      moveDir+=dir;
      for (int i=blocks.size()-1; i>=0; i--) {
        // If the block should move horizontally, move it
        if (moveDir!=0 && blocks.get(i).fall) blocks.get(i).bx+=moveDir;
      }
    }
  }
}
