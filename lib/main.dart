import 'package:chatty/data/api_service.dart';
import 'package:flutter/material.dart';

import 'presentation/ui/home.dart';

// ignore_for_file: non_constant_identifier_names
import 'env/env.dart';


void main() {
  
  // Set the OpenAI API key from the .env file.
  ApiService.api.token = Env.apiKey;

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
