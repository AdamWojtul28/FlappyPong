//Racket class that will help postion the movable base controlled by the user and determine the direction in which the ball will move
class Racket {
  //Values
  color racketColor;
  float posX;
  float posY;
  int racketWidth;
  int racketHeight;

  Racket() {
    racketColor = 0;
    posX = mouseX;
    posY = mouseY;
    racketWidth = 100;
    racketHeight = 10;
  }

  //Draw the racket at specified x and y position
  void drawRacket() {
    //Update mouse location
    posX = mouseX;
    posY = mouseY;

    //Draw the racket
    fill(racketColor);
    rectMode(CENTER);
    rect(posX, posY, racketWidth, racketHeight);
  }
}
