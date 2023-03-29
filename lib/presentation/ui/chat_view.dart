import 'dart:io';

import 'package:chatty/audio_recorder.dart';
import 'package:chatty/env/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../notifiers/timer_notifier.dart';

enum RequestType { text, image, audio }

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final _timer = context.read<TimerNotifier>();
  String? audioPath;

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
            /*Container(
              color: Colors.blue.shade100,
              height: 100,
              child: Row(
                children: [
                  IconButton(
                    onPressed: _onStart,
                    icon: const Icon(Icons.schedule_rounded)
                  ),
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
                    icon: const Icon(Icons.audio_file_outlined)
                  ),
                ],
              ),
            ),*/
            Expanded(
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    String item = _messages.elementAt(index);

                    return Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue.shade200,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: index.isOdd ? Colors.blue.shade200 : Colors.blue.shade100,
                        child: Text(item)
                      ),
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
                  child: Row(
                    children: [
                      Expanded(
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
                              //suffix: IconButton(icon: Icon(Icons.play_arrow_rounded), onPressed: onSubmit)
                            ),
                            onFieldSubmitted: (value) {
                              debugPrint("Value: $value");
                              setState(() {
                                _messages.add(value);
                              });
                              requestText(prompt: value);
                            }),
                      ),

                      /// For event #4
                      /// Added the [AudioRecorder] widget
                      AudioRecorder(
                        onStop: (path) {
                          debugPrint('Recorded file path: $path');
                          setState(() {
                            audioPath = path;
                          });

                          requestFromAudio(audioPath: audioPath!, speakResponse: true);
                        },
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<String> requestText({required String prompt}) async {
    Dio client = Dio();
    client.options.baseUrl = "https://api.openai.com/v1/";

    /// Set API token
    String token = Env.apiKey;

    final headers = <String, Object>{};
    headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    client.options.headers.addAll(headers);

    debugPrint(client.options.headers.toString());

    var response = await client.post("completions", data: {
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 1500,
      "stop": ["You:"]
    });
    /*var response = await client.post("images/generations", data: {
      "prompt": prompt,
      "n": 1,
      "response_format": "b64_json"
    });*/

    debugPrint("response: $response");

    var json = response.data as Map<String, dynamic>;
    var message = json["choices"][0]["text"];
    //var message = json["data"][0]["b64_json"];
    //print("message: $message");

    setState(() {
      _messages.add(message);
    });

    return message;
  }

  void requestImage({required String prompt}) async {
    Dio client = Dio();
    client.options.baseUrl = "https://api.openai.com/v1/";

    /// Set API token
    String token = Env.apiKey;

    final headers = <String, Object>{};
    headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    client.options.headers.addAll(headers);

    debugPrint(client.options.headers.toString());

    var response = await client.post("images/generations",
        data: {"prompt": prompt, "n": 1, "response_format": "b64_json"});
    debugPrint("response: $response");

    var json = response.data as Map<String, dynamic>;
    var message = json["data"][0]["b64_json"];

    setState(() {
      _messages.add(message);
    });
  }

  /// for whisper
  void requestFromAudio({required String audioPath, bool speakResponse = false}) async {
    Dio client = Dio();
    client.options.baseUrl = "https://api.openai.com/v1/";

    /// Set API token
    String token = Env.apiKey;
    print("token: $token");

    final headers = <String, Object>{};
    headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

    client.options.headers.addAll(headers);

    MultipartFile multipartFile;

    /// for web we'll need to send it as bytes
    if (kIsWeb) {
      /// first get the blob path and parse it
      final result = await http.get(Uri.parse(audioPath));

      /// then convert to bytes
      Uint8List data = result.bodyBytes.buffer.asUint8List();

      multipartFile = MultipartFile.fromBytes(data, filename: "audio.m4a");
    } else {
      File? file;
      try {
        file = File.fromUri(Uri.file(audioPath)); // <= returns File
      } catch (e) {
        print("eee: $e");
      }
      multipartFile = await MultipartFile.fromFile(file!.path, filename: "file_01.m4a");
    }

    /// for whisper
    FormData formData = FormData.fromMap({"model": "whisper-1", "file": multipartFile});
    var response = await client.post("audio/transcriptions", data: formData);

    debugPrint("whisper parse: $response");

    var json = response.data as Map<String, dynamic>;
    final String prompt = json["text"];

    setState(() {
      _messages.add(prompt);
    });

    // Flutter tts
    debugPrint("requestFromAudio (prompt): $prompt");
    var text = await requestText(prompt: prompt);

    if (speakResponse) {
      FlutterTts flutterTts = FlutterTts();
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(0.8);
      await flutterTts.speak(text);
    }

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
