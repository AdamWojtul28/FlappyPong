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

  // if the user had played the game before, it will import their previous results from the textfile, else the defaults are used
  void setLeaderboard(String[] textFile) {
    int counter = 1;
    // update the number of times classic mode was played
    timesPlayedClassic = int(textFile[0]);
    
    // update the top ten scores in classic mode
    for (int i = 0; i < 10; i++) {
      topTenScoresClassic[i] = int(textFile[counter]);
      counter++;
    }
    
    // update the number of times hard mode was played
    timesPlayedHard = int(textFile[counter]);
    counter++;
    
    // update the top ten scores in hard mode
    for (int i = 0; i < 10; i++) {
      topTenScoresHard[i] = int(textFile[counter]);
      counter++;
    }
  }

  // saves the current stats to a textfile so the user can keep their scores from the previous times they played
  String[] getStats() {
    String[] currentStats = new String[22];
    int counter = 1;
    // the number of times they played the classic mode is stored in position 0
    currentStats[0] = str(timesPlayedClassic);
    // the user's top 10 scores in classic mode are stored in positions 1-10
    for (int i = 0; i < 10; i++) {
      currentStats[counter] = str(topTenScoresClassic[i]);
      counter++;
    }
    
    // the number of times they played the hard mode is stored in position 11
    currentStats[counter] = str(timesPlayedHard);
    counter++;
    // the user's top 10 scores in hard mode are stored in positions 12-22
    for (int i = 0; i < 10; i++) {
      currentStats[counter] = str(topTenScoresHard[i]);
      counter++;
    }
    return currentStats;
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
      if (i + 1  == 10) {
        currentLocalString = " ";
      } else {
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
    } else {
      timesPlayedHard++;
      updateLeaderboardHelper(newScore, timesPlayedHard, topTenScoresHard, mode);
    }
  }

  void updateLeaderboardHelper(int newScore, int timesPlayed, int[] topTenArray, String mode) {
    if (timesPlayed >= 10) {
      topTenArray[10] = newScore;
    } else {
      topTenArray[timesPlayed - 1] = newScore;
    }
    topTenArray = sort(topTenArray);
    topTenArray = reverse(topTenArray);

    if (mode.equals("classic")) {
      topTenScoresClassic = topTenArray;
    } else {
      topTenScoresHard = topTenArray;
    }
  }
}
