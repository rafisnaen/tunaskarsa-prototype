import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunaskarsa/pages/loginPage.dart';
import 'package:tunaskarsa/providers/userProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Memastikan izin notifikasi sudah di-check saat aplikasi dijalankan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.checkAndRequestPermission();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: LoginPage(),
    );
  }
}
