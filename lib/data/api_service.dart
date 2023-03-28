import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _tag = '.APIService';
  static final ApiService _apiService = ApiService._();
  static late Dio _client;

  static ApiService get api => _apiService;

  /// Handle Authorization headers
  ///
  /// Set token session
  /// 'Authorization': 'Bearer $token'
  final Map<String, String> _sessionHeaders = {};

  set token(token) {
    _sessionHeaders.update(
        HttpHeaders.authorizationHeader, (value) => "Bearer $token",
        ifAbsent: () => "Bearer $token");
  }

  ApiService._() {
    _client = Dio();
    _client.options.baseUrl = "https://api.openai.com/v1/";
  }

  Future<dynamic> get({
    String? url,
    Map<String, Object>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final Map<String, Object> builtHeaders = _headerBuilder(headers);
      _client.options.headers.addAll(builtHeaders);

      final response = await _client.get(
        _queryBuilder(url, query),
      );

      return _returnResponse(response);
    } on DioError catch (e) {
      return _returnResponse(e.response);
    }
  }

  Future<dynamic> post({
    String? url,
    Map<String, Object?>? body,
    Map<String, Object>? query,
    Map<String, String>? headers,
  }) async {
    try {
      var builtHeaders = _headerBuilder(headers);

      _client.options.headers.addAll(builtHeaders);

      debugPrint("API SERVICE POST (HEADERS): ${_client.options.headers}");

      final response = await _client.post(
        _queryBuilder(url, query),
        data: body,
      );

      return _returnResponse(response);
    } on DioError catch (e) {
      return _returnResponse(e.response);
    }
  }

  Object _returnResponse(Response? response) {
    if (response == null) {
      throw Exception(
        'Ops, Unable to get a response from the server.',
      );
    }
    return response.data;
  }

  String _queryBuilder(String? path, Map<String, Object>? query) {
    final buffer = StringBuffer();
    bool removeLastChar = false;
    buffer.write(path);
    if (query != null) {
      if (query.isNotEmpty) {
        buffer.write('?');
      }
      query.forEach((key, value) {
        buffer.write('$key=$value&');
        removeLastChar = true;
      });

      if (removeLastChar) {
        /// REMOVE LAST &
        String result = buffer.toString();
        //return result.substring(0, result.length - 1);
        return result;
      }
    }

    return buffer.toString();
  }

  Map<String, Object> _headerBuilder(Map<String, Object>? extraHeaders) {
    final headers = <String, Object>{};

    /// Updates and adds the current session token and build the headers
    if (_sessionHeaders.isNotEmpty) {
      headers.addAll(_sessionHeaders);
    }

    headers[HttpHeaders.acceptHeader] = 'application/json';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    if (extraHeaders != null && extraHeaders.isNotEmpty) {
      extraHeaders.forEach((key, value) {
        headers[key] = value;
      });
    }
    return headers;
  }
}
