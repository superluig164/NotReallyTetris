/* Written by Tommy Sebestyen
 * Purpose: Play Tetris (ah well it will probably not quite be Tetris but who cares)
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
PImage bg;

void setup() {
  println("Initializing Tetris...");
  size(800, 600);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  println("OK");
  bg = loadImage("bg.jpg");
  noStroke();
}

void draw() {
  if (state.equals("title")) drawTitleScreen();
  if (state.equals("game")) drawGame();
  if (state.equals("pause")) drawPauseScreen();
}

void keyPressed() {
  if (state.equals("title")) {
    if (keyCode == ENTER || keyCode==RETURN) state="game";
  }
  if (state.equals("game")) {
    if (keyCode == LEFT) game.moveShape(-1);
    if (keyCode == RIGHT) game.moveShape(1);
    if (key == 'p' || key == 'P') state="pause";
  }
  if (state.equals("pause")) {
    if (key == 'p' || key == 'P') state="game";
  }
}

void mousePressed() {
  if (state.equals("title")) {
    if (mouseX > (width/2)-100 && 
      mouseX < (width/2)+100 &&
      mouseY > (height/2)-50 &&
      mouseY < (height/2)+50)
      state="game";
  }
  if (state.equals("game")) {
  }
}

void drawBG(color BG) {
  background(BG);
}

void drawTitleScreen() {
  imageMode(CENTER);
  tint(255, 255, 255, 50);
  image(bg, width/2, height/2);

  textAlign(CENTER, TOP);
  textSize(30);
  fill(255, 255, 255);
  text("Not Really Tetris", width/2, height/6);

  rectMode(CENTER);
  fill(200, 200, 200);
  rect(width/2, height/2, 200, 100, 5);
  rectMode(CORNER);

  textSize(18);
  fill(0, 0, 0);
  text("Start [Enter]", width/2, (height/2)-15);

  fill(255, 255, 255);
  text("Use the arrow keys to move left and right", width/2, height-100);
}

void drawPauseScreen() {
  fill(128, 128, 128, 128);
  rect(0, 0, width, height);
  fill(255, 255, 255);
  textSize(18);
  text("PAUSE", width/2, height/2);
}

void drawGame() {
  if (keyCode == DOWN && keyPressed) updateInterval=5;
  else updateInterval=15;

  drawBG(color(100, 100, 100));
  imageMode(CENTER);
  tint(255, 255, 255, 50);
  image(bg, width/2, height/2);

  if (frameCount % updateInterval == 0) {
    game.update();
    upTime++;
    score=game.linesCleared;
  }
  game.display();

  fill(255, 255, 255);
  textSize(18);
  textAlign(LEFT, TOP);
  text("SCORE: "+score, 10, 10);
}
