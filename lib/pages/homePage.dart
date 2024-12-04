import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/pages/loginPage.dart';
import 'package:tunaskarsa/providers/userProvider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.loggedInUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF8EB486),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              userProvider.logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting user
            Text(
              'Welcome, ${user?.username ?? "Guest"}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF685752),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Play Quiz Button
            ElevatedButton(
              onPressed: () {
                // TODO: Arahkan ke halaman Play Quiz
                // Bisa mengganti dengan halaman QuizPage atau halaman lain
                print('Play Quiz button pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8EB486),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Play Quiz',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFDF7F4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
