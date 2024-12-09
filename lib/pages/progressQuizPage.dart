import 'package:flutter/material.dart';



class ProgressQuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> quizTopics;

  // Constructor to accept the quizTopics list
  ProgressQuizPage({required this.quizTopics});

  @override
  _ProgressQuizPageState createState() => _ProgressQuizPageState();
}

class _ProgressQuizPageState extends State<ProgressQuizPage> {
  @override
  Widget build(BuildContext context) {
    // Calculate completed quizzes and total quizzes
    final completedQuizzes = widget.quizTopics.where((quiz) => quiz['isCompleted']).length;
    final totalQuizzes = widget.quizTopics.length;
    final progress = totalQuizzes > 0 ? completedQuizzes / totalQuizzes : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Quiz"),
        backgroundColor: const Color(0xFF8EB486),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Progress Kamu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "$completedQuizzes / $totalQuizzes Quiz Selesai",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to QuizHomePage
              },
              child: Text("Kembali"),
            ),
          ],
        ),
      ),
    );
  }
}
