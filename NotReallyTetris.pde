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

void setup() {
  // Log
  println("Initializing Tetris...");
  size(800, 600); // Size of the window
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  // Log
  println("OK");
  bg = loadImage("bg.jpg"); // Background image
  noStroke();
}

void draw() {
  if (state.equals("title")) drawTitleScreen(); // If we're on the title screen, display the title screen
  if (state.equals("game")) drawGame(); // If we are in the game, display the game
  if (state.equals("pause")) drawPauseScreen(); // If we are paused, display the pause screen
  // NOTE: This doesn't work.  I don't know why.  If you start this game,
  // you'd better be committed, because you can't pause.
}

void keyPressed() {
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

void mousePressed() {
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
void drawBG(color BG) {
  background(BG);
}

// Draw the title screen.
void drawTitleScreen() {
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
void drawPauseScreen() {
  // Draw a gray rectangle
  fill(128, 128, 128, 128);
  rect(0, 0, width, height);
  
  // Write PAUSE in the middle
  fill(255, 255, 255);
  textSize(18);
  text("PAUSE", width/2, height/2);
}

// Draw/update the game.  This is the meaty part.
void drawGame() {
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
