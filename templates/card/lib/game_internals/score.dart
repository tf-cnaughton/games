// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Encapsulates a score and the arithmetic to compute it.
class Score {
  final int score;
  String playerName;

  factory Score(int score, String playerName) {
    return Score._(score, playerName);
  }

  Score._(this.score, this.playerName);

  @override
  String toString() => 'Score<$score, $playerName>';

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
