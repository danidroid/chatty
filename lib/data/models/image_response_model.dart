class ImageResponseModel {
  int? created;
  List<ImageData>? data;

  ImageResponseModel({this.created, this.data});

  ImageResponseModel.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    if (json['data'] != null) {
      data = <ImageData>[];
      json['data'].forEach((v) {
        data!.add(ImageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageData {
  String? url;
  String? b64Json;

  ImageData({this.url, this.b64Json});

  ImageData.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    b64Json = json['b64_json'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['b64_json'] = b64Json;
    return data;
  }
}
