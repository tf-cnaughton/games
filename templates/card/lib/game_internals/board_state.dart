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
  final VoidCallback onDraw;

  final PlayingArea areaOne = PlayingArea();

  final PlayingArea areaTwo = PlayingArea();

  final Player player = Player();

  final Dealer dealer = Dealer();

  BoardState({required this.onWin, required this.onLose, required this.onDraw}) {
    player.addListener(_handlePlayerChange);
  }

  void _handlePlayerChange() {
    if (player.hand.isEmpty) {
      onWin();
    }
  }

  Future<void> evaluateGame() async {
    dealer.revealHand();

    await Future.delayed(const Duration(milliseconds: 1000));

    if (player.calculateScore() > 21 && dealer.calculateScore() > 21) {
      onDraw();
      resetBoard();
    } else if (dealer.calculateScore() > 21 && player.calculateScore() <= 21) {
      onWin();
    } else if (player.calculateScore() > 21 && dealer.calculateScore() <= 21) {
      onLose();
    } else if (player.calculateScore() > dealer.calculateScore()) {
      onWin();
    } else if (player.calculateScore() < dealer.calculateScore()) {
      onLose();
    } else if (player.calculateScore() == dealer.calculateScore()) {
      onDraw();
      resetBoard(); // Reset the board if scores are the same
    }
  }

  void resetBoard() {
    player.hand.clear(); // Clear the player's hand
    dealer.dealerHand.clear(); // Clear the dealer's hand
    player.addCard(); // Add initial cards for the player
    dealer.addCard(); // Add initial cards for the dealer
  }

  void dispose() {}
}
