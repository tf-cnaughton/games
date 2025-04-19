// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'dealer.dart';
import 'player.dart';
import 'playing_area.dart';

class BoardState {
  final VoidCallback onWin;
  final VoidCallback onLose;

  final PlayingArea areaOne = PlayingArea();

  final PlayingArea areaTwo = PlayingArea();

  final Player player = Player();

  final Dealer dealer = Dealer();

  BoardState({required this.onWin, required this.onLose}) {
    player.addListener(_handlePlayerChange);
  }

  void _handlePlayerChange() {
    if (player.hand.isEmpty) {
      onWin();
    }
  }

  void evaluateGame() {
    dealer.revealHand();

    if (player.calculateScore() > 21 && dealer.calculateScore() > 21) {
      onLose();
    } else if (player.calculateScore() > dealer.calculateScore()) {
      onWin();
    } else if (player.calculateScore() < dealer.calculateScore()) {
      onLose();
    } else if (player.calculateScore() == dealer.calculateScore()) {
      onLose();
    }
  }

  void dispose() {}
}
