import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Dealer extends ChangeNotifier {
  final List<PlayingCard> dealerHand = [PlayingCard.random()];

  void addCard() {
    dealerHand.add(PlayingCard.random());
    notifyListeners();
  }

  int calculateScore() {
    int score = 0;
    for (var card in dealerHand) {
      if (['K', 'Q', 'J'].contains(card.value)) {
        score += 10; // Face cards are worth 10
      } else if (card.value == 'A') {
        score += 11; // Ace is worth 11
      } else {
        score += int.tryParse(card.value) ?? 0; // Numeric cards
      }
    }
    return score;
  }

  void revealHand(){
    while (calculateScore() < 16) {
      addCard();
      notifyListeners();
    }
  }
}
