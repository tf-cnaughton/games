import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const maxCards = 2;

  final List<PlayingCard> hand =
      List.generate(maxCards, (index) => PlayingCard.random());

  void removeCard(PlayingCard card) {
    hand.remove(card);
    notifyListeners();
  }

  void addCard() {
    hand.add(PlayingCard.random());
    notifyListeners();
  }

  int calculateScore() {
    int score = 0;
    for (var card in hand) {
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
}
