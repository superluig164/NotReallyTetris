import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class NotReallyTetris extends PApplet {

/* Written by Tommy Sebestyen
 * Purpose: Play Not Really Tetris
 * Not Really Tetris is derived from Tetris, but isn't Tetris.
 * Blocks cascade downward rather than stopping in midair, 
 * allowing for nasty combos.  That is, if it wasn't so buggy.
 * Ah well, I can only blame myself.  At least it's commented
 * to oblivion.
 */
// Standard Tetris board is 10w 20h
// ArrayList<Object> name = new ArrayList<Object>();

float gameWidth = 10; // Width of the game field block wise
float gameHeight = 20; // Height of the game field block wise
float blockSize = 23; // Size of each block, square
boolean log = false; // if true, logging will be verbose.  Only for debugging.
int updateInterval = 15; // How often the game should update, in frames.
int upTime = 0; // How long the game has been running, in updates
int score = 0; // How many lines the player has cleared
Field game = new Field(gameWidth, gameHeight, blockSize);
String state = "title"; // The state of the game
PImage bg; // Background image

public void setup() {
  // Log
  println("Initializing Tetris...");
   // Size of the window
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  // Log
  println("OK");
  bg = loadImage("bg.jpg"); // Background image
  noStroke();
}

public void draw() {
  if (state.equals("title")) drawTitleScreen(); // If we're on the title screen, display the title screen
  if (state.equals("game")) drawGame(); // If we are in the game, display the game
  if (state.equals("pause")) drawPauseScreen(); // If we are paused, display the pause screen
  // NOTE: This doesn't work.  I don't know why.  If you start this game,
  // you'd better be committed, because you can't pause.
}

public void keyPressed() {
  // If on the title screen
  if (state.equals("title")) {
    // Start the game when the ENTER/RETURN key is pressed.
    if (keyCode == ENTER || keyCode==RETURN) state="game";
  }
  // If in the game
  if (state.equals("game")) {
    // Move the shape over when LEFT is pressed
    if (keyCode == LEFT) game.moveShape(-1);
    
    // Move the shape over when RIGHT is pressed
    if (keyCode == RIGHT) game.moveShape(1);
    
    // Pause when P is pressed (doesn't work)
    if (key == 'p' || key == 'P') state="pause";
  }
  // If we are paused (which we never will be)
  if (state.equals("pause")) {
    // Resume the game when P is pressed
    if (key == 'p' || key == 'P') state="game";
  }
}

public void mousePressed() {
  // If on the title screen
  if (state.equals("title")) {
    // Start the game when the mouse is clicked within this box
    if (mouseX > (width/2)-100 && 
      mouseX < (width/2)+100 &&
      mouseY > (height/2)-50 &&
      mouseY < (height/2)+50)
      state="game";
  }
}

// Draws the background. (I am not 100% sure why I needed a method for this)
public void drawBG(int BG) {
  background(BG);
}

// Draw the title screen.
public void drawTitleScreen() {
  // Display the background image
  imageMode(CENTER);
  tint(255, 255, 255, 50);
  image(bg, width/2, height/2);

  // Display the title
  textAlign(CENTER, TOP);
  textSize(30);
  fill(255, 255, 255);
  text("Not Really Tetris", width/2, height/6);

  // Draw the button
  rectMode(CENTER);
  fill(200, 200, 200);
  rect(width/2, height/2, 200, 100, 5);
  rectMode(CORNER);

  // Draw the text in the button
  textSize(18);
  fill(0, 0, 0);
  text("Start [Enter]", width/2, (height/2)-15);

  // Draw the controls
  fill(255, 255, 255);
  text("Use the arrow keys to move left and right", width/2, height-100);
}

// Draw the pause screen.  (this doesn't work)
public void drawPauseScreen() {
  // Draw a gray rectangle
  fill(128, 128, 128, 128);
  rect(0, 0, width, height);
  
  // Write PAUSE in the middle
  fill(255, 255, 255);
  textSize(18);
  text("PAUSE", width/2, height/2);
}

// Draw/update the game.  This is the meaty part.
public void drawGame() {
  // Make the game update faster if DOWN is held.  
  if (keyCode == DOWN && keyPressed) updateInterval=5;
  else updateInterval=15;

  // Draw the background image.
  drawBG(color(100, 100, 100));
  imageMode(CENTER);
  tint(255, 255, 255, 50);
  image(bg, width/2, height/2);

  // If we are on a multiple of the update interval
  if (frameCount % updateInterval == 0) {
    game.update(); // Update the game
    upTime++; // Log the uptime
    score=game.linesCleared; // Set the score to be displayed
  }
  game.display(); // Draw the game

  // Draw the score counter in the top left
  fill(255, 255, 255);
  textSize(18);
  textAlign(LEFT, TOP);
  text("SCORE: "+score, 10, 10);
}
/* Written by Tommy Sebestyen
 * Purpose: This class handles the individual blocks
 * that make up the Tetris shapes.
 */

class Block {

  float bx; // x location in the field
  float by; // y location in the field
  int col; // Block's color
  boolean fall; // Whether the block is falling or not

  // Default constructor (should not be used)
  Block() {
    col=color(0, 0, 0);
    bx=0;
    by=0;
    fall=true;
    println("ERROR: Something called an uninitialized Block.  This should not happen.");
  }

  // Constructor
  // c - the colour of the block
  // x - the position of the block horizontally
  // y - the position of the block vertically
  Block(int c, float x, float y) {
    // Set internal fields to constructor parameters
    col=c;
    bx=x;
    by=y;
    
    // All new Blocks always fall
    fall=true;
    
    // Log
    println("New Block created");
    println("  x = "+x);
    println("  y = "+y);
  }

  // Add or subtract from the current colour towards the goal colour.
  // I never use this method.  Go figure.
  // goal - the colour to move toward
  public int transformColour(int goal) {
    
    // Select the direction (if they are equal, nothing happens)
    if (col>goal) col++;
    if (goal>col) col--;
    
    // Return the current colour (so the function can stop being called if the colour has been reached)
    return col;
  }
}
/* Written by Tommy Sebesyen
 * Purpose: This class handles the "real" x and y positions of 
 * objects on the playfield.  It also handles updating their 
 * positions, clearing lines, initializing new shapes, etc.
 * This is essentially the heart of this game.
 */

class Field {

  float sizex; // Width of the playfield in blocks.
  float sizey; // Height of the playfield in blocks.
  float sizeb; // Diameter of each block.
  ArrayList<Integer> shapes = new ArrayList<Integer>(); // Array for calculating shapes, to ensure you never get the same shape twice (as per Tetris standard)
  ArrayList<Block> blocks = new ArrayList<Block>(); // Array of Blocks that make up the game field.
  int moveDir; // Direction and distance to move a falling shape
  int linesCleared = 0; // How many lines have been cleared

  float centerx; // Center constant
  float centery; // Center constant

  // Color constants
  final int purple = color(184, 2, 253);
  final int red = color(254, 16, 60);
  final int green = color(102, 253, 0);
  final int yellow = color(255, 222, 0);
  final int orange = color(255, 115, 8);
  final int dblue = color(24, 1, 255);
  final int lblue = color(0, 230, 254);

  // Default constructor (should not be used)
  Field() {
    sizex = 10;
    sizey = 20;
    sizeb = 5;
    println("ERROR: Something called an uninitialized Field.  This should not happen.");
  }

  // Constructor
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
  public void initializeShape(String t) {
    // Cancel adding the shape if there is a block at the top of the field
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

  public void display() {
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
      int c = blocks.get(i).col;

      // Do some preliminary calculations
      x = ((width/2)-(w/2))+(s+3)*x;
      y = ((height/2)-(h/2))+(s+3)*y;

      // Draw the block
      fill(c);
      rect(x, y, s, s);
    }
  }

  // Update the position of any blocks that need their position updated
  public void update() {
    // Logic for dropping blocks ------------------------
    // Amount of blocks that are falling
    int falling=0;
    boolean clearingLine=false;

    // Iterate through the blocks in the field
    for (int i=blocks.size()-1; i>=0; i--) {
      // Log
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

                // Log
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
      // Log
      println("");
    }
    // Reset moveDir each update cycle
    moveDir = 0;

    // If we should be clearing lines
    if (falling>0) 
      // Clear lines
      clearingLine=true;

    // Logic for clearing lines --------------------
    // If we should be clearing lines
    if (clearingLine) {
      // Iterate through each line
      for (int i=PApplet.parseInt(sizey); i>0; i--) {
        // Log
        print("Line #"+i+" ");

        // How many blocks are on this line
        int howMany=0;

        // Iterate through the blocks on the field
        for (int j=0; j<blocks.size(); j++) {
          // If the block is at this line, count it
          if (blocks.get(j).by==i) howMany++;
        }
        print(howMany+" ");
        // If there are more blocks on this line than the width of the field
        if (howMany>sizex) {
          // Clear the line
          removeLine(i);

          // Log
          print("removed #"+i+" ");
        }
        // Log
        println("");
      }
    }
    // If no blocks are falling and we aren't clearing a line, add a new shape
    if (!clearingLine && falling==0) initializeShape(calculateNextShape());
  }

  // Remove a line of blocks from the field and update the blocks above to fall.
  // line - which line to remove
  public void removeLine(float line) {
    // Update the score
    linesCleared++;

    // Iterate through all lines before the one to be removed
    for (int i=0; i<line; i++) {
      print("Line #"+i+" ");
      // Iterate through the blocks on the field
      for (int j=blocks.size()-1; j>=0; j--) {
        // If the block is at the current line
        if (blocks.get(j).by==i) {
          // Whether there is a block underneath
          int under=0;

          // Iterate through the blocks on the field
          for (int k=blocks.size()-1; k>=0; k--) {
            // Reset this variable
            under=0;
            // If there is a block under this one
            if (blocks.get(j).bx==blocks.get(k).bx &&
              // Count it towards under
              blocks.get(j).by==blocks.get(k).by-1) under++;
          }
          // If there are no blocks under this one, drop it
          if (under<=0) blocks.get(j).fall=true;

          // Log
          print("drop #"+j+" ");
        }
      }
      // Log
      println("");
    }

    // Iterate through the blocks on the field
    for (int i=blocks.size()-1; i>=0; i--) {
      // Remove blocks on the line to be removed
      if (blocks.get(i).by==line) blocks.remove(i);
    }
  }

  // Select a random shape out of the available shapes.
  public String calculateNextShape() {
    // The shape to be chosen
    float chosenShape=0;

    // If there are no shapes left in the array, re-initialize it
    if (shapes.size()<=0) {
      // Iterate through 7 shapes
      for (int i=1; i<=7; i++) {
        // Add that shape ID
        shapes.add(i);
      }
    }
    // Choose a random index in the array
    chosenShape = random(PApplet.parseFloat(shapes.size()-1));

    // What shape to return based on the shape chosen
    switch(shapes.get(PApplet.parseInt(chosenShape))) {
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
  public void moveShape(int dir) {
    // Amount of blocks that are falling
    int falling=0;

    // Iterate through the blocks in the field
    for (int i=blocks.size()-1; i>=0; i--) {

      // If the block is falling, increment the counter
      if (blocks.get(i).fall) falling++;
    }

    // If there are 4 blocks falling (i.e. a shape)
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
      
      // Iterate through the blocks on the field
      for (int i=blocks.size()-1; i>=0; i--) {
        // If the block should move horizontally, move it
        if (moveDir!=0 && blocks.get(i).fall) blocks.get(i).bx+=moveDir;
      }
    }
  }
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "NotReallyTetris" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
