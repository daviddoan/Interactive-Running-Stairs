void addNewScore(int score) {
  for (int i=0; i < highscores.length; i++) {
    if (score <= highscores[i]) {
      for (int j = highscores.length-1; j >= max(i,1); j--) {
        highscores[j] = highscores[j-1];
        highscorer[j] = highscorer[j-1];
      }
      highscores[i] = score;
      highscorer[i] = scorer;
      break;
    }
  }
}
