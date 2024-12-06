import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/pages/childDetailPage.dart';
import 'package:tunaskarsa/providers/userProvider.dart';
import 'package:tunaskarsa/models/user.dart';
import 'loginPage.dart';

class ListChildPage extends StatefulWidget {
  const ListChildPage({super.key});

  @override
  State<ListChildPage> createState() => _ListChildPageState();
}

class _ListChildPageState extends State<ListChildPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final loggedInUser = userProvider.loggedInUser;

    if (loggedInUser == null) {
      return const Center(child: Text('Anda tidak memiliki akses ke halaman ini.'));
    }

    // Ambil daftar anak berdasarkan role pengguna yang sedang login
    final children = userProvider.getChildrenForLoggedInUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Anak'),
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
          children: [
            // Hanya tampilkan form untuk orang tua
            if (loggedInUser.role == 'Orang Tua') ...[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Masukkan email anak',
                  filled: true,
                  fillColor: const Color(0xFF8EB486).withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final targetEmail = _emailController.text.trim();
                  final targetUser = userProvider.users
                      .firstWhere((user) => user.email == targetEmail && user.role == 'Anak', orElse: () => User(email: '', password: '', username: '', role: '', id: ''));

                  if (targetUser.email != '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Permintaan koneksi dikirim!')),
                    );
                    _emailController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Anak dengan email tersebut tidak ditemukan.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EB486),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tambahkan Anak',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
           // Menampilkan daftar anak yang terhubung
            Expanded(
              child: children.isEmpty
                  ? const Center(child: Text('Tidak ada anak terhubung.'))
                  : ListView.builder(
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        final child = children[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 3,
                          child: ListTile(
                            title: Text(child.username),
                            subtitle: Text('${child.email} - ${child.grade}'),
                            onTap: () {
                              // Navigasi ke halaman detail anak
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChildDetailPage(childId: child.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
