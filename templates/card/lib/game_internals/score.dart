// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Encapsulates a score and the arithmetic to compute it.
class Score {
  final int score;

  final int level;

  String playerName;

  factory Score(int level, int difficulty, String playerName) {
    // The higher the difficulty, the higher the score.
    var score = difficulty;
    // The lower the time to beat the level, the higher the score.
    return Score._(score, level, playerName);
  }

  Score._(this.score, this.level, this.playerName);

  @override
  String toString() => 'Score<$score,$level$playerName>';

  void setPlayerName(String text) {
    playerName = text;
  }
  
   Map<String, dynamic> toJson() {

    return {

      'score': score,

      'playerName': playerName,

    };

  }
}
