import 'package:chatty/data/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/notifiers/timer_notifier.dart';
import 'presentation/ui/chat_view.dart';
import 'presentation/ui/home.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerNotifier()),
      ],
      child: MaterialApp(
        title: eventName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ChatView(),
      ),
    );
  }
}
