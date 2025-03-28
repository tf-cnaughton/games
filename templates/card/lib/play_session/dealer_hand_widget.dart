import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class DealerHandWidget extends StatelessWidget {
  const DealerHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    final dealer = boardState.dealer;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        ...dealer.hand.map((card) =>
            PlayingCardWidget(card)),
      ],
    );
  }
}