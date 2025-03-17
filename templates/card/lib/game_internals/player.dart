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
}
