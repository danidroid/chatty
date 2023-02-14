import 'package:chatty/data/api_service.dart';
import 'package:flutter/material.dart';

import 'presentation/ui/home.dart';

void main() {
  /// Set your token api account
  ApiService.api.token = "";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String eventName = "Flutter + ChatGPT - Flutter Faro #3";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: eventName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: eventName),
    );
  }
}
