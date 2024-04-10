////Make the obstacles that the player must avoid

class Wall {
  int x, y, gapHeight, wallWidth, wallSpeed;
  boolean isCollidingWithBall;

  Wall(int x, int y, int gapHeight, int wallWidth, int wallSpeed) {
    this.x = x;
    this.y = y;
    this.gapHeight = gapHeight;
    this.wallWidth = wallWidth;
    this.wallSpeed = wallSpeed;
    isCollidingWithBall = false;
  }

  void move() {
    x -= wallSpeed;
  }

  void display() {
    noStroke();

    fill(255);
    rect(x-10, 0, wallWidth + 20, y + 10, 0, 0, 5, 5);
    // creates a white background so that the blue light from the laser is visible
    float size = 15;
    for (int i = 40; i < 120; i += 20) {
      fill(0, 0, 255, i);
      rect(x-size, 0, wallWidth + size*2, y + size, 0, 0, 5, 5);
      size-=2.5;
      // increasinly more visible blue lines emitting from the laser
    }

    rect(x-10, y + gapHeight - 10, wallWidth + 20, height - (y + gapHeight) + 10, 0, 0, 5, 5); // Lower part of the wall
    size = 15;
    // creates a white background so that the blue light from the laser is visible
    for (int i = 40; i < 120; i += 20) {
      fill(0, 0, 255, i);
      rect(x-size, y + gapHeight - size, wallWidth + size*2, height - (y + gapHeight) + size*2, 0, 0, 5, 5);
      size-=2.5;
      // increasinly more visible blue lines emitting from the laser
    }

    fill(255); // Wall color
    rect(x, 0, wallWidth, y, 0, 0, 5, 5); // Upper part of the wall

    rect(x, y + gapHeight, wallWidth, height - (y + gapHeight), 0, 0, 5, 5); // Lower part of the wall
  }

  int getX() {
    return x;
  }

  boolean ballColliding(int xBall, int yBall, int ballSize) {
    boolean collisionExists = false;
    if ((xBall - ballSize/2 >= x && xBall - ballSize/2 <= x + wallWidth) || (xBall + ballSize/2 >= x && xBall + ballSize/2 <= x + wallWidth)) {
        // checks if either the left side of the ball or the right side of the ball is within the x-dimensions of a laser beam
      if ((yBall - ballSize/2 >= -1 * ballSize && yBall - ballSize/2 <= y) || (yBall + ballSize/2 >= -ballSize && yBall + ballSize/2 <= y)) {
        collisionExists = true;
        // checks if the ball is within the top laser beam
      } else if ((yBall - ballSize/2 >= y + gapHeight && yBall - ballSize/2 <= height + ballSize) || (yBall + ballSize/2 >= y + gapHeight && yBall + ballSize/2 <= height + ballSize)) {
        collisionExists = true;
        // checks if the ball is within the bottom laser beam
      }
    }
    return collisionExists;
  }

  boolean getCollisionCondition() {
    return isCollidingWithBall;
  }

  void setCollisionCondition(boolean condition) {
    isCollidingWithBall = condition;
  }
}
