/* Written by Tommy Sebestyen
 * Purpose: Play Tetris (ah well it will probably not quite be Tetris but who cares)
 */
// Standard Tetris board is 10w 20h
// ArrayList<Object> name = new ArrayList<Object>();

float gameWidth = 10; // Width of the game field block wise
float gameHeight = 20; // Height of the game field block wise
float blockSize = 20; // Size of each block, square
boolean log = false; // if true, logging will be verbose.  Only for debugging.
final int updateInterval = 15; // How often the game should update, in frames.
int upTime = 0; // How long the game has been running, in updates
int score = 0; // How many lines the player has cleared
Field game = new Field(gameWidth, gameHeight, blockSize);
String state = "title"; // The state of the game

void setup() {
  println("Initializing Tetris...");
  size(800, 600);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  println("OK");
}

void draw() {
  if (state.equals("title")) drawTitleScreen();
  if (state.equals("game")) drawGame();
  if (state.equals("pause")) drawPauseScreen();
}

void keyPressed() {
  if (state.equals("game")) {
    if (keyCode == LEFT) game.moveShape(-1);
    if (keyCode == RIGHT) game.moveShape(1);
  }
}

void mousePressed() {
  if (state.equals("game")) {
  }
}

void drawBG(color BG) {
  background(BG);
}

void drawTitleScreen() {
}

void drawPauseScreen() {
}

void drawGame() {
  drawBG(color(100, 100, 100));

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
