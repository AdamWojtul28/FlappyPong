//The ball class that will control the location, speed, and collision of the ball the player is juggling
class Ball {
  //Location, size, and color of the ball
  float ballX; //Made a float to avoid infinite bouncing balls
  float ballY; //Made a float to avoid infinite bouncing balls
  float ballSize;
  color ballColor;

  //Modifiers for the speed of the ball
  //The strength of gravity based on location, height and speed
  float gravity;
  float ballSpeedY;
  float ballSpeedX;
  float airFriction;
  float normalFriction;

  //Default constructor of the ball
  Ball() {
    //Basic properties of the ball
    ballX = width/4;
    ballY = width/5;
    ballColor = 0;
    ballSize = 20;

    //Set the modifiers to the default values
    gravity = 0.9;
    airFriction = 0.0001; //How much resistance we want for the ball when falling
    normalFriction = 0.1; //Resistence when we touch a surface
    ballSpeedX = 0;
    ballSpeedY = 0;
  }

  //Draw the ball
  void drawBall() {
    fill(ballColor);
    ellipse(ballX, ballY, ballSize, ballSize);
  }

  //Make ball bounce when hit from bottom
  //The surface could be the racket, walls, or screen boundaries
  void bounceBottom(float surface) {
    ballY = surface - (ballSize/2); //If hits ball radius
    ballSpeedY *= -1; //Switch Directions
    ballSpeedY -= (ballSpeedY * normalFriction); //Apply Friction
  }

  //Make ball bounce when hit from Top
  //The surface could be the racket, walls, or screen boundaries
  void bounceTop(float surface) {
    ballY = surface + (ballSize/2); //If hits ball radius
    ballSpeedY *= -1; //Switch Directions
    ballSpeedY -= (ballSpeedY * normalFriction); //Apply Friction
  }

  //Make ball bounce when hit from right
  //The surface could be the racket, walls, or screen boundaries
  void bounceRight(float surface) {
    ballX = surface - (ballSize/2); //If hits ball radius
    ballSpeedX *= -1; //Switch Directions
    ballSpeedX -= (ballSpeedX * normalFriction); //Apply Friction
  }

  //Make ball bounce when hit from left
  //The surface could be the racket, walls, or screen boundaries
  void bounceLeft(float surface) {
    ballX = surface + (ballSize/2); //If hits ball radius
    ballSpeedX *= -1; //Switch Directions
    ballSpeedX -= (ballSpeedX * normalFriction); //Apply Friction
  }

  //Ensure the ball doesn't go off screen when hitting an edge
  void paddScreen() {
    //Check floor collision
    if (ballY+(ballSize/2) > height) {
      bounceBottom(height);
    }

    //Check ceiling collision
    if (ballY-(ballSize/2) < 0) {
      bounceTop(0);
    }

    //Check right wall collision
    if (ballX+(ballSize/2) > width) {
      bounceRight(width);
    }

    //Check left wall collision
    if (ballX-(ballSize/2) < 0) {
      bounceLeft(0);
    }
  }

  //Apply the gravity to the ball, makes it fall faster
  //This is the equivalent of "applyHorizontalSpeed" but for the Y directions
  void applyGravity() {
    ballSpeedY += gravity;
    ballY += ballSpeedY;
    ballSpeedY -= (ballSpeedY * airFriction);
  }

  //Apply speed in the X direction
  void applyHorizontalSpeed() {
    ballX += ballSpeedX;
    ballSpeedX -=  (ballSpeedX * airFriction);
  }

  int getX() {
    return (int)ballX;
  }
  int getY() {
    return (int)ballY;
  }
  int getSize() {
    return (int)ballSize;
  }
}
