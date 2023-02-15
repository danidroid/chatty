import 'dart:io';

import 'package:chatty/presentation/ui/chat.dart';
import 'package:flutter/material.dart';
import 'package:whisper_dart/whisper_dart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openChat() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ChatView(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /*const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Available Tokens:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),*/
          const SizedBox(
            height: 16,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.audio_file)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChat,
        tooltip: 'open chat',
        child: const Icon(Icons.message),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void main(List<String> arguments) {
    DateTime time = DateTime.now();
    // print(res);
    Whisper whisper = Whisper(
      whisperLib: "whisper.cpp/whisper.so",
    );
    try {
      var res = whisper.request(
        whisperRequest: WhisperRequest.fromWavFile(
          audio: File("samples/output.wav"),
          model: File("models/ggml-model-whisper-small.bin"),
        ),
      );
      print(res.toString());
      //print(convertToAgo(time.millisecondsSinceEpoch));
    } catch (e) {
      print(e);
    }
  }
}
