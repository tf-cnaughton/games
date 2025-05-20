import 'dart:convert';

import 'package:card/game_internals/board_state.dart';
import 'package:card/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../game_internals/score.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;
  final BoardState boardState;
  final VoidCallback stopCelebration;

  const WinGameScreen({
    super.key,
    required this.score,
    required this.boardState,
    required this.stopCelebration
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gap,
            const Center(
              child: Text(
                'You won!',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                'Score: ${score.score}\n'
                'Name: ${settingsController.playerName.value}\n',
                style: const TextStyle(
                    fontFamily: 'Roboto', fontSize: 20),
              ),
            ),
            gap,
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/play');
            stopCelebration();          
            boardState.resetBoard();
          },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}