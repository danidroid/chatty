import 'package:chatty/data/models/completation_response_model.dart';

class Message {
  final String message;
  final bool me;

  final CompletationResponseModel? model;

  final bool isLoading;

  Message(
      {required this.message,
      this.me = true,
      this.isLoading = false,
      this.model});

  factory Message.me(String message) => Message(message: message, me: true);

  factory Message.from(CompletationResponseModel response) => Message(
      message: response.choices?.first.text ?? "", me: false, model: response);

  factory Message.loading() => Message(message: "", me: false, isLoading: true);
}
