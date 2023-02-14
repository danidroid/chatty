import 'package:chatty/data/app_repository.dart';
import 'package:chatty/data/models/completation_response_model.dart';
import 'package:chatty/domain/entities/message.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

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

    var response = await appRepository.request(prompt: prompt);

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
              Text(item.message),
            ],
          ),
        ),
      ],
    );
  }
}
