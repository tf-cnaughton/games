import 'package:card/game_internals/score.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  fontFamily: 'Roboto',
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add a new record to Firestore
                try {
                  await FirebaseFirestore.instance.collection('game_results').add({
                    'playerName': score.playerName,
                    'score': score.score,
                    'timestamp': FieldValue.serverTimestamp(), // Optional: Add a timestamp
                  });
                  print('Record added to Firestore');
                } catch (e) {
                  print('Error adding record to Firestore: $e');
                }

                // Navigate back to the main menu
                GoRouter.of(context).go('/menu');
              },
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
