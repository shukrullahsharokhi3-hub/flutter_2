import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(String path, {String? token}) {
    return _send('GET', path, token: token);
  }

  Future<dynamic> post(String path, {Object? body, String? token}) {
    return _send('POST', path, body: body, token: token);
  }

  Future<dynamic> put(String path, {Object? body, String? token}) {
    return _send('PUT', path, body: body, token: token);
  }

  Future<dynamic> patch(String path, {Object? body, String? token}) {
    return _send('PATCH', path, body: body, token: token);
  }

  Future<dynamic> delete(String path, {String? token}) {
    return _send('DELETE', path, token: token);
  }

  Map<String, String> _buildHeaders(String? token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      };

  Uri _buildUri(String path) {
    final base = AppConfig.baseUrl.endsWith('/')
        ? AppConfig.baseUrl.substring(0, AppConfig.baseUrl.length - 1)
        : AppConfig.baseUrl;
    final endpoint = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$endpoint');
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    String? token,
  }) async {
    final uri = _buildUri(path);
    final headers = _buildHeaders(token);
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      final response = switch (method) {
        'GET' => await _client.get(uri, headers: headers),
        'POST' => await _client.post(uri, headers: headers, body: encodedBody),
        'PUT' => await _client.put(uri, headers: headers, body: encodedBody),
        'PATCH' => await _client.patch(uri, headers: headers, body: encodedBody),
        'DELETE' => await _client.delete(uri, headers: headers),
        _ => throw ArgumentError.value(
            method,
            'method',
            'Unsupported HTTP method',
          ),
      };

      final responseData = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          _errorMessage(responseData, response.statusCode),
          statusCode: response.statusCode,
          responseData: responseData,
        );
      }
      return responseData;
    } on http.ClientException {
      throw const ApiException(
        'Unable to connect to the server. Please try again.',
      );
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    }
  }

  Object? _decodeResponse(String body) {
    if (body.trim().isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException {
      return body;
    }
  }

  String _errorMessage(Object? responseData, int statusCode) {
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    return 'Request failed with status code $statusCode.';
  }

  void close() => _client.close();
}
