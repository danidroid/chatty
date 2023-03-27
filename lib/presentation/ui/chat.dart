import 'dart:convert';
import 'dart:io';

import 'package:chatty/data/app_repository.dart';
import 'package:chatty/domain/entities/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

/// TODO:
/// Better handle what to query, Text or Image
/// or event both?
class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final AppRepository appRepository = AppRepository();
  final TextEditingController input = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //await appRepository.request(prompt: "What is the best movie ever?");
  //await appRepository.request(prompt: "Ok, how about Comedy films?");

  bool isLoading = false;
  final List<Message> _messages = [];
  final List<String> _messages2 = [];

  @override
  Widget build(BuildContext context) {
    adjustScroll();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    Message item = _messages.elementAt(index);

                    return MessageBubble(item: item);

                    /*String item = _messages2.elementAt(index);

                    return Container(
                      color: Colors.blue,
                      child: Text(item),
                    );*/
                  })),
          Container(
            color: Colors.amber,
            child: TextFormField(
              maxLines: 3,
              controller: input,
              decoration: const InputDecoration(),
              onChanged: (value) {},
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                if (isLoading) {
                  return;
                }

                String message = value.trim();
                debugPrint("Value: $message");

                _messages.add(Message.me(message));

                request(message);

                input.clear();
              },
            ),
          )
        ],
      ),
    );
  }

  void request(String prompt) async {
    setState(() {
      isLoading = true;
      _messages.add(Message.loading());
    });

    /// Request Text
    //var response = await appRepository.request(prompt: prompt);
    /// Request Image
    var response = await appRepository.requestImage(prompt: prompt);

    setState(() {
      _messages
        ..removeLast()
        ..add(Message.from(response));
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  void adjustScroll() {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  void request2(String prompt) async {
    Dio client = Dio();
    client.options.baseUrl = "https://api.openai.com/v1/";

    String token = "";

    final headers = <String, Object>{};
    headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    client.options.headers.addAll(headers);

    var response = await client.post("completions", data: {
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 1500,
      "stop": ["You:"]
    });
    print("response: $response");

    var json = response.data as Map<String, dynamic>;
    var message = json["choices"][0]["text"];
    print("message: $message");

    setState(() {
      _messages2.add(message);
    });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Message item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          item.me ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6, minHeight: 80),
          decoration: BoxDecoration(
            color: item.me ? Colors.green.shade300 : Colors.green.shade100,
            border: Border.all(
              color: item.me ? Colors.green.shade300 : Colors.green.shade100,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.isLoading) ...[
                JumpingDots(
                  color: Colors.green.shade500,
                  radius: 10,
                ),
              ],
              if (item.image != null) ...[
                Image.memory(
                  const Base64Decoder().convert(item.message.split(',').last),
                  gaplessPlayback: true,
                )
              ],
              if (item.model != null || item.me) ...[
                Text(item.message),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
