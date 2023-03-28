import 'package:flutter/cupertino.dart';

import 'api_service.dart';
import 'models/completation_response_model.dart';
import 'models/image_response_model.dart';
import 'models/response_model.dart';

class AppRepository {
  final ApiService api = ApiService.api;

  Future<ResponseModel> request({required String prompt}) async {
    var response = await api.post(url: "completions", body: {
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 1500,
      "stop": ["You:"]
    });

    debugPrint("response $response");

    var result = CompletationResponseModel.fromJson(response);

    return ResponseModel(text: result);
  }

  Future<ResponseModel> requestImage({required String prompt}) async {
    var response = await api.post(
        url: "images/generations",
        body: {"prompt": prompt, "n": 1, "response_format": "b64_json"});
    debugPrint("response $response");

    var model = ImageResponseModel.fromJson(response);

    return ResponseModel.image(image: model);
  }
}
