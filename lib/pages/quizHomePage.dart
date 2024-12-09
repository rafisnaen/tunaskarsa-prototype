import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/pages/progressQuizPage.dart';
import 'package:tunaskarsa/pages/quizPage.dart';
import 'package:tunaskarsa/providers/userProvider.dart';
import 'package:tunaskarsa/pages/homePage.dart';

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List<Map<String, dynamic>> quizTopics = [
    {
      "id": 1,
      "title": "Matematika Dasar",
      "description": "Uji pengetahuanmu tentang matematika dasar.",
      "questions": [
        {
          "question": "Berapa hasil dari 5 + 3?",
          "options": ["6", "7", "8", "9"],
          "answer": "8"
        },
        {
          "question": "Berapakah 9 × 7?",
          "options": ["63", "72", "54", "49"],
          "answer": "63"
        },
        {
          "question": "Berapakah akar kuadrat dari 64?",
          "options": ["6", "7", "8", "9"],
          "answer": "8"
        },
      ],
      "reward": 10, // dalam menit screen time
      "isCompleted": false, // status awal belum selesai
      "totalQuestions": 3, // Added to track total questions
      "completedQuestions": 0 // Added to track completed questions
    },
    {
      "id": 2,
      "title": "Sejarah Dunia",
      "description": "Seberapa baik kamu mengetahui sejarah dunia?",
      "questions": [
        {
          "question": "Siapa penemu bola lampu?",
          "options": ["Edison", "Newton", "Tesla", "Einstein"],
          "answer": "Edison"
        },
        {
          "question": "Perang Dunia I dimulai tahun?",
          "options": ["1912", "1914", "1918", "1920"],
          "answer": "1914"
        },
        {
          "question": "Candi Borobudur terletak di?",
          "options": ["Bali", "Jawa Tengah", "Sumatera", "Sulawesi"],
          "answer": "Jawa Tengah"
        },
      ],
      "reward": 15, // dalam menit screen time
      "isCompleted": false, // status awal belum selesai
      "totalQuestions": 3, // Added to track total questions
      "completedQuestions": 0 // Added to track completed questions
    },
  ];

  void _reward(int reward) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.addTime(reward);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Selamat!"),
          content: Text("Kamu mendapatkan $reward menit tambahan!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _incompleted() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Selesai"),
          content:
          Text("Kamu belum menjawab semua soal dengan benar. Coba lagi!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter hanya quiz yang belum selesai
    final availableQuizzes =
    quizTopics.where((quiz) => !quiz['isCompleted']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Play Quiz"),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              // Pass quizTopics to ProgressQuizPage when navigating
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressQuizPage(quizTopics: quizTopics),
                ),
              ).then((_) {
                // Refresh state to reflect any changes made in ProgressQuizPage
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: availableQuizzes.isEmpty
          ? Center(child: Text("Semua quiz sudah selesai!"))
          : ListView.builder(
        itemCount: availableQuizzes.length,
        itemBuilder: (context, index) {
          final topic = availableQuizzes[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                topic['title'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(topic['description']),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${topic['questions'].length} Soal"),
                  Text("${topic['reward']} Menit",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
              onTap: () {
                // Navigate to QuizPage and handle quiz completion
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(
                      topic: topic,
                      onQuizCompleted: (isPerfect) {
                        setState(() {
                          topic['isCompleted'] = true; // Mark quiz completed
                          topic['completedQuestions'] = topic['questions'].length; // Track completed questions

                          if (isPerfect) {
                            final reward = topic['reward'];
                            _reward(reward);
                          } else {
                            _incompleted();
                          }
                        });
                      },
                    ),
                  ),
                ).then((_) {
                  // Refresh state after returning from QuizPage
                  setState(() {});
                });
              },
            ),
          );
        },
      ),
    );
  }
}

