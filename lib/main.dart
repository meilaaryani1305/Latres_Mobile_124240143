import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latres_mobile/pages/home_page.dart';
import 'package:latres_mobile/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<String>('favorites');

  final prefs = await SharedPreferences.getInstance();

  String? username = prefs.getString('logged_in_username');

  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  final String? username;

  const MyApp({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeriesKu',

      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFF8F7FC),
      ),

      home: username == null
          ? LoginPage()
          : HomePage(username: username!),
    );
  }
}