
import 'package:calendar_app/authen_check_page.dart';
import 'package:calendar_app/authen_page.dart';
import 'package:calendar_app/screen_home.dart';
import 'package:calendar_app/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      theme: ThemeData(colorScheme: MaterialTheme.lightScheme(), useMaterial3: true),
      darkTheme: ThemeData(colorScheme: MaterialTheme.darkScheme(), useMaterial3: true),
      //home: const ScreenHome(),
      home: const authenpage(),
      //home: const authencheck(),
    );
  }
}
