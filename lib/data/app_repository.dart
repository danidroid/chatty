import 'api_service.dart';
import 'models/completation_response_model.dart';

class AppRepository {
  final ApiService api = ApiService.api;

  Future<CompletationResponseModel> request({required String prompt}) async {
    var response = await api.post(url: "completions", body: {
      "model": "text-davinci-003",
      "prompt": prompt,
      "max_tokens": 1500,
      "stop": ["You:"]
    });
    print("response $response");

    var completationResponseModel =
        CompletationResponseModel.fromJson(response);

    return completationResponseModel;
  }
}
