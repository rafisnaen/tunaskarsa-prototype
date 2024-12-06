import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/models/user.dart';
import 'package:tunaskarsa/pages/loginPage.dart';
import 'package:tunaskarsa/pages/quizHomePage.dart';
import 'package:tunaskarsa/pages/profilePage.dart'; // Buat halaman profile
import 'package:tunaskarsa/pages/schedulePage.dart'; // Buat halaman schedule
import 'package:tunaskarsa/pages/progressQuizPage.dart'; // Buat halaman progress quiz
import 'package:tunaskarsa/providers/userProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Untuk menyimpan indeks halaman yang dipilih

  // List halaman berdasarkan indeks navbar
  final List<Widget> _pages = [
    HomeScreen(), // Halaman utama (Home)
    ProfilePage(), // Halaman profil
    SchedulePage(), // Halaman jadwal
    ProgressQuizPage(), // Halaman progress quiz
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman berdasarkan indeks
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Indeks halaman aktif
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Perbarui halaman aktif
          });
        },
        selectedItemColor: const Color(0xFF8EB486), // Warna aktif
        unselectedItemColor: Colors.grey, // Warna tidak aktif
        type: BottomNavigationBarType.fixed, // Fixed navbar
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress Quiz',
          ),
        ],
      ),
    );
  }
}

// Komponen untuk halaman Home
class HomeScreen extends StatelessWidget {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

            // Jika user adalah orang tua, tampilkan daftar anak yang terhubung
            if (user?.role == 'Orang Tua') ...[
              const Text(
                'Your Connected Children:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF685752),
                ),
              ),
              const SizedBox(height: 10),
              Consumer<UserProvider>(
                builder: (context, provider, child) {
                  final connectedChildren = provider.getChildrenForLoggedInUser();
                  if (connectedChildren.isEmpty) {
                    return const Text('No children connected.');
                  } else {
                    return Column(
                      children: connectedChildren
                          .map(
                            (child) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '${child.username} - ${child.email}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ],

            const SizedBox(height: 40),
            // Tombol Play Quiz
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuizHomePage()));
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
