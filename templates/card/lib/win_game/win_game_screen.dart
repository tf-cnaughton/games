import 'dart:convert';

import 'package:card/game_internals/board_state.dart';
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
    const gap = SizedBox(height: 10);
    final TextEditingController nameController = TextEditingController();

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
                'Name: ${score.playerName}',
                style: const TextStyle(
                    fontFamily: 'Roboto', fontSize: 20),
              ),
            ),
            gap,
            ElevatedButton(
              onPressed: () async {
                score.setPlayerName(nameController.text);
                await sendScoreToApi(score);
                GoRouter.of(context).go('/');
              },
              child: Text('Submit'),
            ),
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

  Future<void> sendScoreToApi(Score score) async {
    final url = Uri.parse('https://your-rails-api.com/scores');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(score.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('Score sent successfully');
    } else {
      print('Failed to send score: ${response.statusCode}');
    }
  }
}