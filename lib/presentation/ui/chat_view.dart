import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../notifiers/timer_notifier.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final _timer = context.read<TimerNotifier>();

  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatty"),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: Colors.blue.shade100,
              height: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: _onStart,
                      icon: const Icon(Icons.schedule_rounded)),
                  Consumer<TimerNotifier>(builder: (context, nf, child) {
                    if (!nf.isRunning) {
                      return const Text(
                        "",
                        style: TextStyle(fontSize: 12),
                      );
                    }
                    return Text(
                      "Hey there, Im a timer ${nf.duration}",
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    );
                  }),
                  IconButton(
                      onPressed: _onAudioTranscriptions,
                      icon: const Icon(Icons.audio_file_outlined)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    String item = _messages.elementAt(index);

                    return Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade200,
                      child: Text(item),
                      /*child: Image.memory(
                        const Base64Decoder().convert(item.split(',').last),
                        gaplessPlayback: true,
                      ),*/
                    );
                  }),
            ),
            Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        label: Text("Prompt?"),
                        labelStyle: TextStyle(color: Colors.black),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        print("Value: $value");
                        request(prompt: value);
                      }),
                ))
          ],
        ),
      ),
    );
  }

  void request({required String prompt}) async {
    Dio client = Dio();
    client.options.baseUrl = "https://api.openai.com/v1/";

    /// Set API token
    String token = "";

    final headers = <String, Object>{};
    headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    headers[HttpHeaders.acceptHeader] = 'application/json';
    //headers[HttpHeaders.contentTypeHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

    client.options.headers.addAll(headers);

    /*var response = await client.post("completions", data: {
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 1500,
      "stop": ["You:"]
    });*/
    /*var response = await client.post("images/generations", data: {
      "prompt": prompt,
      "n": 1,
      "response_format": "b64_json"
    });*/

    ByteData a = await rootBundle.load("assets/audio/sample_0.mp3");
    //Uint8List audioUint8List = a.buffer.asUint8List(a.offsetInBytes, a.lengthInBytes);
    //List<int> audioListInt = audioUint8List.cast<int>();

    File? file;
    try {
      file = await writeToFile(a); // <= returns File
    } catch (e) {
      // catch errors here
    }

    /// for whisper
    FormData formData = FormData.fromMap({
      "model": "whisper-1",
      "file": await MultipartFile.fromFile(file!.path, filename: "file_01.mp3")
    });
    var response = await client.post("audio/transcriptions", data: formData);

    print("response: $response");

    var json = response.data as Map<String, dynamic>;
    //var message = json["choices"][0]["text"];
    //var message = json["data"][0]["b64_json"];
    //print("message: $message");

    /// for whisper
    final String text = json["text"];

    setState(() {
      _messages.add(text);
    });
  }

  void _onStart() {
    if (_timer.isRunning) {
      _timer.stop();

      return;
    }
    _timer.init(
      duration: 1000,
    );
  }

  void _onAudioTranscriptions() {
    request(prompt: "");
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        '$tempPath/file_01.mp3'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  void dispose() {
    _timer.stop();
    super.dispose();
  }
}
