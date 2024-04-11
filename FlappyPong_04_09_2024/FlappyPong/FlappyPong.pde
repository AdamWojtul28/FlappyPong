//Javier Lopez
//3/24/24

/*
--------------------------------------------------Final Project-----------------------------------------------------------------
 Project Synopsis:
 • The nature of the gameplay is that you control a small bar with your mouse, similar to the game
 Pong, to juggle a small ball around obstacles, avoiding collisions and keeping your health up. The
 bar you control, depending on the angle and speed at which you move it, sends the ball in different
 directions and speed. The obstacle can be from the top or bottom of the screen and you must
 carefully maneuver around each obstacle. The ball has a small heath bar that will deplete if you hit an
 obstacle. You gain a point for every set of obstacles you overcome. Your goal is to see how far you
 can go and how high a score you can get before losing your health.
 • The challenge would be to precisely hit the ball in a way that it won’t hit an obstacle. They would
 also struggle with an increasing speed at which the obstacles appear the longer the game lasts.
 • The actions to overcome them would be accurately moving the base to juggle the ball.
 
 Part 1:
 Make a basic skeleton code with all classes and user interface/menu designed
 
 Screen: Menu, Gameplay, and Game-Over
 
 */

//-----------------------Global Variables-----------------------------------------//

import processing.sound.*;

//Holds what screen it should be: "menu", "gameplay", "gameover", "scores", "tutorial", "classic", "hard"
String gameState = "menu";

//Object we will use
Ball ball;
Racket racket;
HealthBar health;
Leaderboard leaderboard;

//General values to track
int score;
int lastWallInSight;
int lastAddWallTime; //Last time a wall was added
int wallInterval; //How often a new wall should spawn
//int walls[];  //Array of walls
ArrayList<Wall> walls = new ArrayList<Wall>();  //Array of walls

// Sound
SoundFile classicModeMusic, hardModeMusic, zapSFX, gameOverSFX;

int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 30;
int wallSpeed = 5;

int wallsHit = 0;

//-----------------------Mechanical Functions-----------------------------------------//
//Setup
void setup() {
  size(1000, 800);

  ball = new Ball();
  racket = new Racket();
  health = new HealthBar();
  leaderboard = new Leaderboard();

  classicModeMusic = new SoundFile(this, "133937_popcorn.mp3", false);
  hardModeMusic = new SoundFile(this, "85046_newgrounds_parago.mp3", false);
  zapSFX = new SoundFile(this, "laser-zap-90575.mp3", false);
  gameOverSFX = new SoundFile(this, "Bum Bum Ba Bum200734-424bf6bb-0f17-4a67-8335-95712032829b.mp3", false);
  
  

  score = 0;
  lastWallInSight = 0;
  lastAddWallTime = millis();
  wallInterval = 1000;
}

//Calls the screen that should be displayed at each state of the game
void draw() {
  switch(gameState) {
  case "menu":
    menuScreen();
    break;
    /*
    case "gameplay":
     gameplayScreen();
     break;
     */
  case "classic":
    health.switchMode("easy");
    gameplayScreen();
    break;
  case "hard":
    health.switchMode("hard");
    gameplayScreen();
    break;
  case "gameover":
    gameoverScreen();
    break;
  case "scores":
    highScoresScreen();
    break;
  case "tutorial":
    tutorialScreen();
    break;
  }
}

//Used to determine when to start game based on screen click
void mousePressed() {
  //TODO

  //TEMP TESTING
  if (gameState.equals("menu")) {
    if (mouseX >= 250 && mouseX <= 450 && mouseY >= height/3 && mouseY <= height/3 + 100) {
      reset();
      gameState = "classic";
      classicModeMusic.jump(0);
    } else if (mouseX >= 250 && mouseX <= 450 && mouseY >= (height/3 + 150) && mouseY <= (height/3 + 250)) {
      reset();
      gameState = "hard";
      hardModeMusic.jump(0);
    } else if (mouseX >= 550 && mouseX <= 750 && mouseY >= height/3 && mouseY <= height/3 + 100) {
      gameState = "tutorial";
    } else if (mouseX >= 550 && mouseX <= 750 && mouseY >= (height/3 + 150) && mouseY <= (height/3 + 250)) {
      gameState = "scores";
    }
  } else if (gameState.equals("gameover")) {
    if (mouseX >= 250 && mouseX <= 450 && mouseY >= height/3 && mouseY <= height/3 + 100) {
      // Replay button
      reset();
      gameState = "classic";  // Or any other default gameplay mode
      classicModeMusic.jump(0);
    } else if (mouseX >= 550 && mouseX <= 750 && mouseY >= height/3 && mouseY <= height/3 + 100) {
      // Menu button
      gameState = "menu";
    }
  } else if (gameState.equals("scores") || gameState.equals("tutorial") || gameState.equals("gameplay") || gameState.equals("classic") || gameState.equals("hard")) {
    // Return to menu
    if (mouseX >= 25 && mouseX <= 125 && mouseY >= 25 && mouseY <= 75) {
      // Stop music depending on game mode
      if (gameState.equals("classic")) {
        classicModeMusic.pause();
      } else if (gameState.equals("hard")) {
        hardModeMusic.pause();
      }

      gameState = "menu";
    }
  }
}

//-----------------------Global Functions-----------------------------------------//

//Draw, format, and run menu
void menuScreen() {
  //TODO
  background(255);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Flappy Pong", width/2, 150, 3);
  textSize(24);

  // Classic Mode Button
  noStroke();
  fill(#4806C6);
  rect(250, height/3, 200, 100, 28);
  fill(255);
  text("Classic Mode", 350, height/3 + 50);

  // Tutorial Button
  fill(#4806C6);
  rect(550, height/3, 200, 100, 28);
  fill(255);
  text("Tutorial", 650, height/3 + 50);

  // Hard Mode Button
  fill(#4806C6);
  rect(250, height/3 + 150, 200, 100, 28);
  fill(255);
  text("Hard Mode", 350, height/3 + 200);

  // High Scores Button
  fill(#4806C6);
  rect(550, height/3 + 150, 200, 100, 28);
  fill(255);
  text("High Scores", 650, height/3 + 200);
}

//Draw, format, and run game
void gameplayScreen() {
  //TODO

  //Set the background to certain images
  background(0, 240, 255); //Temp color

  //Make the racket and see if at the current frame there is a collision with the ball
  racket.drawRacket();
  checkRacketBounce();

  // update the score if the position of the ball is greater than the nearest wall
  increaseScore();

  //Make the ball after its potential interaction with the racket, applying all modifiers to the speed while making sure it doen't go offscreen
  ball.drawBall();
  health.drawHealthBar(ball.ballX, ball.ballY);
  ball.applyGravity(); //Add speed in the Y
  ball.applyHorizontalSpeed(); //Add speed in the X
  ball.paddScreen();

  addWalls();
  updateWalls();

  // checks if the ball is colliding with any of the lasers
  checkWallCollision();

  if (!health.checkAlive()) {
    if(classicModeMusic.isPlaying()){
      classicModeMusic.pause();
    }
    if(hardModeMusic.isPlaying()){
      hardModeMusic.pause();
    }
    gameOverSFX.jump(0);
    leaderboard.updateLeaderboard(score, gameState);
    gameState = "gameover";

  }

  // Menu Button
  noStroke();
  fill(#4806C6);
  rect(25, 25, 100, 50, 20);
  fill(255);
  textSize(25);
  text("Menu", 75, 50);
}

//Draw, format, and run gameover screen
void gameoverScreen() {
  //TODO
  background(255);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Game Over :(", width/2, 200, 3);
  textSize(24);
  
  // Replay Button
  fill(#4806C6);
  rect(250, height/3, 200, 100, 20);
  fill(255);
  text("Replay", 350, height/3 + 50);

  // Menu Button
  fill(#4806C6);
  rect(550, height/3, 200, 100, 20);
  fill(255);
  text("Menu", 650, height/3 + 50);
}

void highScoresScreen() {
  background(255);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Your High Scores", width/2, 50, 3);
  textSize(40);
  text("Classic Mode", width/4, 130, 3);
  text("Hard Mode", 3*width/4, 130, 3);
  leaderboard.displayScores();


  // Menu Button
  noStroke();
  fill(#4806C6);
  rect(25, 25, 100, 50, 20);
  fill(255);
  textSize(25);
  text("Menu", 75, 50);
}

void tutorialScreen() {
  background(255);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Tutorial", width/2, 150, 3);

  // Menu Button
  noStroke();
  fill(#4806C6);
  rect(25, 25, 100, 50, 20);
  fill(255);
  textSize(25);
  text("Menu", 75, 50);

  fill(0);
  // Game Instructions
  text("How to Play:", 200, 250);
  String s = "Control the paddle bar with your mouse to juggle the ball and avoid collision with the walls. If you hit a wall, your health will decline. No keyboard control is necessary.";
  textAlign(LEFT, CENTER);
  text(s, 300, 170, 550, 250);  // Text wraps within text box

  text("Purpose:", 135, 450);
  s = "You gain a point for every set of obstacles you overcome without collision. Your goal is to get the highest score possible before losing your health.";
  text(s, 300, 255, 550, 450);
}

//Resets all values to default to reset the game
//Reset the variables to restart the game
void reset() {
  score = 0;
  health.resetHealth();
  ball.ballX = width/4;
  ball.ballY = height/5;
  lastAddWallTime = 0;
  lastWallInSight = 0;
  walls.clear();
  //walls = [];
  //gameState = "gameplay";
}

//Handle wall managment
//Remove, move, draw, and detect collision with walls
//Should call other wall functions
void updateWalls() {
  //TODO
  for (int i = walls.size() - 1; i >= 0; i--) {
    Wall wall = walls.get(i);
    wall.move();
    wall.display();

    if (wall.x + wall.wallWidth <= 0) {
      walls.remove(0);
      lastWallInSight++;
    }
  }
}

//Add walls to array if it has been enough time and draw it
void addWalls() {
  //TODO
  if (isTimeToAddWall()) {
    createAndAddNewWall();
  }
}

boolean isTimeToAddWall() {
  return millis() - lastAddWallTime > wallInterval;
}

void createAndAddNewWall() {
  int gapHeight = calculateGapHeight();
  int gapY = calculateGapY(gapHeight);
  walls.add(new Wall(width, gapY, gapHeight, wallWidth, wallSpeed));
  lastAddWallTime = millis();
}

int calculateGapHeight() {
  return round(random(minGapHeight, maxGapHeight));
}

int calculateGapY(int gapHeight) {
  return round(random(0, height - gapHeight));
}



//See if wall has hit the ball
void checkWallCollision() {
  for (int i = walls.size() - 1; i >= 0; i--) {
    Wall wall = walls.get(i);
    boolean previousCollisionState = wall.getCollisionCondition();
    boolean currentCollisionState = wall.ballColliding(ball.getX(), ball.getY(), ball.getSize());
    // checks if the ball was colliding with the laser in the previous iteration
    if (currentCollisionState != previousCollisionState) {
      // when the states are different, we either just started to collide with the wall or all of the ball passed through the wall
      if (!previousCollisionState) {
        zapSFX.jump(0.3);
        health.decreaseHealth();
        wall.setCollisionCondition(true);
        walls.set(i, wall);

        // when we just started to collide with the wall, we lower the health and set the condition variable to true so we don't deduct the health too many times
      } else {
        wall.setCollisionCondition(false);
        walls.set(i, wall);
        // when all of the ball passes through the wall, we can once again begin to check whether the condition occurs
      }
    }
  }
}

//See if the racket made contact with ball, if so, change ball details
void checkRacketBounce() {
  //This is the change in in the racket between frames
  //If the mouse moves quickly, this can be used to add or decrease how far the ball will move (Like the force the racket hits the ball with
  float deltaRacket = mouseY - pmouseY;

  //Check if the racket and ball are alligned vertically and horizontally
  //First check is in the same X dir
  if ((ball.ballX+(ball.ballSize/2) > (mouseX - (racket.racketWidth/2))) && (ball.ballX-(ball.ballSize/2) < (mouseX + (racket.racketWidth)/2))) {

    //Check vertical bounce for the top
    if (dist(ball.ballX, ball.ballY, ball.ballX, mouseY) <= (ball.ballSize/2) + abs(deltaRacket)) {
      ball.bounceBottom(mouseY); //Bounce on top of platform only
      ball.ballSpeedX = (ball.ballX - mouseX)/10; //Adds horizontal velocity

      //If change is less than 0, add more speed to ball
      if (deltaRacket < 0) {
        ball.ballY += deltaRacket/2;
        ball.ballSpeedY += deltaRacket/2;
      }
    }
  }
}

//Add to score
void increaseScore() {
  if (walls.size() > score - lastWallInSight) {
    if (walls.get(score - lastWallInSight).getX() <= ball.getX()) {
      score++;
    }
  }
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Score: " + str(score), width/2, 50, 3);
}
