import 'dart:ffi';
import 'dart:io';

import 'package:chatty/data/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/ui/home.dart';
import 'presentation/ui/whisper.dart';

void main() async {
  /// Set your token api account
  ApiService.api.token = "";

  /// For Whisper
  WidgetsFlutterBinding.ensureInitialized();
  DynamicLibrary.open('libwhisper.so');

  //runApp(const MyApp());
  runApp(const MyAppWhisper());
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
