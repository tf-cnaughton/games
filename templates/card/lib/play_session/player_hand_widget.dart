import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  const PlayerHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    final player = boardState.player;
    final dealer = boardState.dealer;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ConstrainedBox(
            constraints:
                const BoxConstraints(minHeight: PlayingCardWidget.height),
            child: ListenableBuilder(
              // Make sure we rebuild every time there's an update
              // to the player's hand.
              listenable: player,
              builder: (context, child) {
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ...player.hand
                        .map((card) => PlayingCardWidget(card, player: player)),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Adjust spacing between buttons
            children: [
              ElevatedButton(
                onPressed: player.addCard,
                child: Text('Twist'),
              ),
              ElevatedButton(
                onPressed: dealer.revealHand,
                child: Text('Stick'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
