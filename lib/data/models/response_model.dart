import 'completation_response_model.dart';
import 'image_response_model.dart';

enum ResponseModelType { text, image }

class ResponseModel {
  final ResponseModelType type;

  final CompletationResponseModel? text;
  final ImageResponseModel? image;

  ResponseModel({this.type = ResponseModelType.text, this.text, this.image});

  factory ResponseModel.image({ImageResponseModel? image}) =>
      ResponseModel(type: ResponseModelType.image, image: image, text: null);
}
