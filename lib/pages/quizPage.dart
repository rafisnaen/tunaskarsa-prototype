import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> topic;
  // final VoidCallback onQuizCompleted; // Callback untuk update status
  final Function(bool isPerfect) onQuizCompleted;

  QuizPage({required this.topic, required this.onQuizCompleted});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int correctAnswers = 0;

  void checkAnswer(String selectedOption) {
    String correctAnswer = widget.topic['questions'][currentQuestion]['answer'];
    if (selectedOption == correctAnswer) {
      correctAnswers++;
    }
    setState(() {
      currentQuestion++;
    });

    if (currentQuestion >= widget.topic['questions'].length) {
      // Tandai quiz selesai
      bool isPerfect = correctAnswers == widget.topic['questions'].length;
      widget.onQuizCompleted(isPerfect);
      // widget.onQuizCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentQuestion >= widget.topic['questions'].length) {
      // Quiz selesai
      return Scaffold(
        appBar: AppBar(title: Text("Hasil Quiz")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Benar: $correctAnswers", style: TextStyle(fontSize: 20)),
              Text(
                  "Salah: ${widget.topic['questions'].length - correctAnswers}",
                  style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Kembali ke Halaman Utama"),
              ),
            ],
          ),
        ),
      );
    }

    // Soal quiz
    final question = widget.topic['questions'][currentQuestion];
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic['title'])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Soal ${currentQuestion + 1} / ${widget.topic['questions'].length}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(question['question'], style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...question['options'].map((option) {
              return ElevatedButton(
                onPressed: () => checkAnswer(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
