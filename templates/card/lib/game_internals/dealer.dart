import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Dealer extends ChangeNotifier {
  final List<PlayingCard> hand = [PlayingCard.random()];

  void addCard() {
    hand.add(PlayingCard.random());
    notifyListeners();
  }

  void reveal_hand(){
    
  }
}
