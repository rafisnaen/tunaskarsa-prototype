import 'package:flutter/material.dart';

class ProgressQuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Quiz"),
        backgroundColor: const Color(0xFF8EB486),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          "Progress Quiz Page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
