////Make the obstacles that the player must avoid

class Leaderboard {
  int[] topTenScoresClassic, topTenScoresHard;
  int timesPlayedClassic, timesPlayedHard;

  Leaderboard() {
    topTenScoresClassic = new int[11];
    topTenScoresHard = new int[11];
    timesPlayedClassic = 0;
    timesPlayedHard = 0;
  }

  void displayScores() {
    fill(255);
    stroke(0);
    strokeWeight(5);
    int position = 180;
    textSize(40);
    textAlign(RIGHT);
    
    String currentLocalString = "";
    for (int i = 0; i < 10; i++) {
      fill(255);
      
      currentLocalString += " " + str(i + 1) + ")       " + str(topTenScoresClassic[i]);
      rect(0.04 * width, position, 0.44 * width, 60);
      fill(0);
      currentLocalString = str(i + 1) + ")";
      text(currentLocalString, 0.1 * width, position + 45);
      currentLocalString = str(topTenScoresClassic[i]);
      text(currentLocalString, 0.46 * width, position + 45);
      
      fill(255);
      if(i + 1  == 10){
        currentLocalString = " ";
      }
      else{
        currentLocalString = "";
      }
      rect(0.52 * width, position, 0.44 * width, 60);
      fill(0);
      currentLocalString = str(i + 1) + ")";
      text(currentLocalString, 0.58 * width, position + 45);
      currentLocalString = str(topTenScoresHard[i]);
      text(currentLocalString, 0.94 * width, position + 45);
      position += 60;
    }
    textAlign(CENTER, CENTER);
    noStroke();
  }

  void updateLeaderboard(int newScore, String mode) {
    if (mode.equals("classic")) {
      timesPlayedClassic++;
      updateLeaderboardHelper(newScore, timesPlayedClassic, topTenScoresClassic, mode);
    }
    else{
      timesPlayedHard++;
      updateLeaderboardHelper(newScore, timesPlayedHard, topTenScoresHard, mode);
    }
    
  }
  
  void updateLeaderboardHelper(int newScore, int timesPlayed, int[] topTenArray, String mode){
      if (timesPlayed >= 10) {
        topTenArray[10] = newScore;
      } else {
        topTenArray[timesPlayed - 1] = newScore;
      }
    topTenArray = sort(topTenArray);
    topTenArray = reverse(topTenArray);
    
    if (mode.equals("classic")){
      topTenScoresClassic = topTenArray;
    }
    else{
      topTenScoresHard = topTenArray;
    }
  }
}
