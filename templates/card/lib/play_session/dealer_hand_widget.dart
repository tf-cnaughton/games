import 'package:flutter/material.dart';
import '../game_internals/playing_card.dart';
import 'playing_card_widget.dart';

class DealerHandWidget extends StatelessWidget {
  final PlayingCard card;

  const DealerHandWidget({super.key, required this.card});

  factory DealerHandWidget.random({Key? key}) {
    return DealerHandWidget(
      key: key,
      card: PlayingCard.random(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PlayingCardWidget(card),
    );
  }
}