import 'package:flutter/material.dart';
import 'package:gyaanbot/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GyaanBot',
      theme: ThemeData(
        fontFamily: 'Magra',
       brightness: Brightness.dark,
       scaffoldBackgroundColor:  Colors.grey.shade900,
       primaryColor: Colors.deepPurple.shade300),
         home: HomePage()
    );
  }
}
