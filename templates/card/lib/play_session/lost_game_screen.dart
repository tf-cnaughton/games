import 'package:card/game_internals/score.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LostGameScreen extends StatelessWidget {
  final Score score;
  const LostGameScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You Lost!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
                       const SizedBox(height: 20),
            Center(
              child: Text(
                'Score: ${score.score}\n'
                'Name: ${score.playerName}',
                style: const TextStyle(
                    fontFamily: 'Roboto', fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context)
                    .go('/menu'); // Navigate back to the main menu
              },
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
