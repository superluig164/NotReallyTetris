/* Written by Tommy Sebestyen
 * Purpose: This class handles the individual blocks
 * that make up the Tetris shapes.
 */

class Block {

  float bx; // x location BLOCK-WISE (in the field)
  float by; // y location BLOCK-WISE (in the field)
  color col; // Block's color
  boolean fall; // Whether the block is falling or not

  // Default constructor (should not be used)
  Block() {
    col=color(0, 0, 0);
    bx=0;
    by=0;
    fall=true;
    println("ERROR: Something called an uninitialized Block.  This should not happen.");
  }

  // c - the colour of the block
  // x - the position of the block horizontally
  // y - the position of the block vertically
  Block(color c, float x, float y) {
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
  // goal - the colour to move toward
  color transformColour(color goal) {
    
    // Select the direction (if they are equal, nothing happens)
    if (col>goal) col++;
    if (goal>col) col--;
    
    // Return the current colour (so the function can stop being called if the colour has been reached)
    return col;
  }
}
