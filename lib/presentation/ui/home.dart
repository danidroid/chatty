import 'package:chatty/presentation/ui/chat_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
                width: double.maxFinite,
                height: 60,
                child: ElevatedButton(
                    onPressed: _openChat, child: const Text("Chat View"))),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _openChat() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ChatView(),
        ));
  }
}
