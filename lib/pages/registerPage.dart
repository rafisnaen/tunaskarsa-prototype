import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/providers/userProvider.dart';
import 'package:tunaskarsa/models/user.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller dan State
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole = 'Anak';
  String? _selectedGrade = 'SD';

  // Dropdown Options
  final List<String> _roles = ['Anak', 'Orang Tua'];
  final List<String> _grades = ['SD', 'SMP', 'SMA'];

  void register(BuildContext context) {
  if (_formKey.currentState!.validate()) {
    // Membuat objek User dengan id unik
    User newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Membuat ID unik berdasarkan waktu
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole!,
      grade: _selectedRole == 'Anak' ? _selectedGrade : null,
    );

    // Tambahkan user ke provider
    Provider.of<UserProvider>(context, listen: false).registerUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User registered successfully!")),
    );

    // Navigasi ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F4), // Warna utama
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      color: Color(0xFF685752),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Username TextField
                  TextFormField(
                    controller: _usernameController,
                    decoration: _inputDecoration('Username'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan Username' : null,
                  ),
                  const SizedBox(height: 16),
                  // Email TextField
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan Email' : null,
                  ),
                  const SizedBox(height: 16),
                  // Password TextField
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Password'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan Password' : null,
                  ),
                  const SizedBox(height: 16),
                  // Role Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: _roles
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                        if (value == 'Anak') {
                          _selectedGrade ??= _grades.first;
                        } else {
                          _selectedGrade = null;
                        }
                      });
                    },
                    decoration: _inputDecoration('Role'),
                    validator: (value) => value == null ? 'Pilih Role' : null,
                  ),
                  const SizedBox(height: 16),
                  // Grade Dropdown (Hanya untuk Anak)
                  if (_selectedRole == 'Anak')
                    DropdownButtonFormField<String>(
                      value: _selectedGrade,
                      items: _grades
                          .map((grade) => DropdownMenuItem(
                                value: grade,
                                child: Text(grade),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGrade = value;
                        });
                      },
                      decoration: _inputDecoration('Grade'),
                      validator: (value) =>
                          value == null ? 'Pilih Grade' : null,
                    ),
                  const SizedBox(height: 24),
                  // Register Button
                  ElevatedButton(
                    onPressed: () => register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8EB486),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      minimumSize: const Size(double.infinity, 50)
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDF7F4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Color(0xFF997C70)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF8EB486),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFF8EB486).withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
