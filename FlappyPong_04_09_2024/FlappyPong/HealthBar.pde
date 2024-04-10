//Bar that will contain the Health left for the player
//In hard mode, the health will be 1 so that 1 hit makes you lose instanly
//In normal mode, you

class HealthBar {
  //Health Bar globals
  float maxHealth; //Max health you cna have
  float currHealth; //Curr health
  int healthDecrease; //How much health you lose per hit
  float healthBarWidth;
  float healthBarHeight;

  //Will determine status of health (Green is for >50%, Yellow for 20% - 50%, and red is for <20%)
  color healthColor;

  //Default constructor
  HealthBar() {
    //By default, it wll make the game normal mode
    maxHealth = 100;
    currHealth = 100;
    healthDecrease = 10;
    healthBarWidth = 30;
    healthBarHeight = 10;
    healthColor = color(0, 255, 0);
  }

  //Constructor for hard mode
  HealthBar(String mode) {
    if (mode == "hard") {
      maxHealth = 1;
      currHealth = 1;
      healthDecrease = 1;
    } else if (mode == "easy") {
      maxHealth = 100;
      currHealth = 100;
      healthDecrease = 10;
    }
  }

  void switchMode(String mode) {
    if (mode == "hard") {
      maxHealth = 100;
      healthDecrease = 100;
    } else if (mode == "easy") {
      maxHealth = 100;
      healthDecrease = 10;
    }
  }

  //Draw the health bar
  //The passed in values are for the positions of the ball, health bar should be drawn above it
  void drawHealthBar(float posX, float posY) {
    //Draws the health bar at the specified location

    //Make the inner rectangle that will serve as the actual health, drawn proportionally to the health
    rectMode(CORNER);
    fill(healthColor);
    noStroke();
    rect(posX - 15, posY - 25, (int)(healthBarWidth * (float)(currHealth/maxHealth)), healthBarHeight);

    //Make the outer rectangle that will serve as the frame
    stroke(0);
    noFill();
    rect(posX -15, posY - 25, healthBarWidth, healthBarHeight);
  }

  //Decrease health, won't ever need to add health
  void decreaseHealth() {
    currHealth -= healthDecrease;

    //Check for color change
    //If health is above 50% full, bar is green
    if (currHealth > 0.5*(maxHealth)) {
      healthColor = color(0, 255, 0); //Green
    }
    //If health is below 50% but above 20%
    else if (currHealth <= 0.5*(maxHealth) && currHealth > 0.20*(maxHealth)) {
      healthColor = color(255, 255, 0); //Yellow
    }
    //If health is at 20% or lower
    else {
      healthColor = color(255, 0, 0); //Red
    }
  }

  //Resets the health bar to the maximum it can be
  void resetHealth() {
    currHealth = maxHealth;
    healthColor = color(0, 255, 0);
  }

  //Checks if player has lost all health
  boolean checkAlive() {
    if (currHealth <= 0) {
      return false;
    } else {
      return true;
    }
  }
}
