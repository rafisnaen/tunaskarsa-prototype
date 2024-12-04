import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _loggedInUser;

  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser;

  void login(String email, String password) {
    _loggedInUser = _users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => User(email: '', password: '', username: '', role: ''),
    );
    notifyListeners();
  }

  void logout() {
    _loggedInUser = null;  // Menghapus data user yang login
    notifyListeners();
  }

  void registerUser(User user) {
    _users.add(user);
    notifyListeners();
  }
}

