import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewScoresScreen extends StatelessWidget {
  const ViewScoresScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchTopScores() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('game_results')
        .orderBy('score', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Scores'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTopScores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No scores available.'));
          }

          final scores = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Top 10 Scores',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final score = scores[index];
                      return ListTile(
                        leading: Text('${index + 1}.'),
                        title: Text(score['playerName'].toString()),
                        trailing: Text(score['score'].toString()),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).pop(),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}