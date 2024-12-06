import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = []; // Daftar semua user
  User? _loggedInUser; // User yang sedang login

  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser;

  // Login user berdasarkan email dan password
  void login(String email, String password) {
    _loggedInUser = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('User not found'),
    );
    _loggedInUser!.isLoggedIn = true; // Set status login
    notifyListeners();
  }

  // Logout user yang sedang login
  void logout() {
    if (_loggedInUser != null) {
      _loggedInUser!.isLoggedIn = false; // Reset status login
      _loggedInUser = null;
      notifyListeners();
    }
  }

  // Menambahkan user baru ke dalam sistem
  void registerUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser({required String username, required String email}) {
    if (loggedInUser != null) {
      _loggedInUser = loggedInUser!.copyWith(
        username: username,
        email: email,
      );
      notifyListeners();
    }
  }

  // Mendapatkan daftar anak untuk orang tua yang sedang login
  List<User> getChildrenForLoggedInUser() {
    if (_loggedInUser == null) return [];
    return _users.where((user) => user.role == 'Anak').toList(); // Filter berdasarkan role "Anak"
  }

  // Mendapatkan daftar orang tua untuk anak yang sedang login
  List<User> getParentForLoggedInUser() {
    if (_loggedInUser == null) return [];
    return _users.where((user) => user.role == 'Orang Tua').toList(); // Filter berdasarkan role "Orang Tua"
  }

  // Mendapatkan anak berdasarkan ID
  User? getChildById(String childId) {
    if (_loggedInUser == null || _loggedInUser!.role != 'Orang Tua') {
      return null; // Hanya orang tua yang bisa melihat anak
    }
    return _users.firstWhere(
      (user) => user.id == childId && user.role == 'Anak',
      orElse: () => User(email: '', password: '', username: '', role: '', id: ''),
    );
  }

  // Menyimpan waktu layar untuk anak
  void saveScreenTime(String childId, int screenTimeInMinutes) {
    if (_loggedInUser == null || _loggedInUser!.role != 'Orang Tua') {
      return; // Hanya orang tua yang bisa mengatur screen time
    }

    final child = getChildById(childId); // Mendapatkan data anak berdasarkan ID
    if (child != null) {
      // Update waktu layar anak
      final updatedChild = child.copyWith(
        screenTime: screenTimeInMinutes, username: '', email: '',
      );
      // Update daftar user dengan data anak yang sudah diubah
      int index = _users.indexWhere((user) => user.id == child.id);
      if (index != -1) {
        _users[index] = updatedChild;
        notifyListeners(); // Notifikasi perubahan ke UI
      }
    }
  }
}
