class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;
  final String? grade;
  bool isLoggedIn;
  List<String> connections;
  int? screenTime;
  DateTime?
      screenTimeEndAt; // Waktu layar yang tersisa (hanya untuk Anak dalam bentuk datetime, agar persistent, tidak reset setiap logout)

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.grade,
    this.isLoggedIn = false,
    this.connections = const [],
    this.screenTime,
    this.screenTimeEndAt,
  });

  // CopyWith untuk mengubah screenTime
  User copyWith({
    int? screenTime,
    required String username,
    required String email,
    DateTime? screenTimeEndAt,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password,
      role: role,
      grade: grade,
      isLoggedIn: isLoggedIn,
      connections: connections,
      screenTime: screenTime ?? this.screenTime,
      screenTimeEndAt: screenTimeEndAt ?? this.screenTimeEndAt,
    );
  }
}