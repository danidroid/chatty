import 'package:chatty/data/models/completation_response_model.dart';
import 'package:chatty/data/models/image_response_model.dart';
import 'package:chatty/data/models/response_model.dart';

class Message {
  final String message;
  final bool me;

  final CompletationResponseModel? model;
  final ImageResponseModel? image;

  final bool isLoading;

  Message(
      {required this.message,
      this.me = true,
      this.isLoading = false,
      this.model,
      this.image});

  factory Message.me(String message) => Message(message: message, me: true);

  factory Message.from(ResponseModel response) {
    switch (response.type) {
      case ResponseModelType.text:
        return Message(
            message: response.text?.choices?.first.text ?? "",
            me: false,
            model: response.text);
      case ResponseModelType.image:
        return Message(
            message: response.image?.data?.first.b64Json ?? "",
            me: false,
            image: response.image);
    }
  }

  factory Message.loading() => Message(message: "", me: false, isLoading: true);
}
