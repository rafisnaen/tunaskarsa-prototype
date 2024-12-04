import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/models/user.dart';
import 'package:tunaskarsa/pages/loginPage.dart';
import 'package:tunaskarsa/providers/userProvider.dart';

class ListChildPage extends StatelessWidget {
  const ListChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final List<User> children = userProvider.users
        .where((user) => user.role == 'Anak') // Filter berdasarkan role 'Anak'
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Anak'),
        backgroundColor: const Color(0xFF8EB486),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              userProvider.logout();  // Logout dan bersihkan state

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
        child: children.isEmpty
            ? const Center(child: Text('Tidak ada anak terdaftar.'))
            : ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final user = children[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    child: ListTile(
                      title: Text(user.username),
                      subtitle: Text('${user.email} - ${user.grade}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
