class User {
  final String username;
  final String email;
  final String password;
  final String role;
  final String? grade;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.grade
  });
}