import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> sendHttpRequest(
    {required String url, String body = "", required String method}) async {
  return switch (method) {
    "GET" => http.get(Uri.parse(url)),
    "DELETE" => http.delete(Uri.parse(url)),
    "POST" => http.post(Uri.parse(url), body: body),
    "PATCH" => http.patch(Uri.parse(url), body: body),
    "PUT" => http.put(Uri.parse(url), body: body),
    _ => http.get(Uri.parse(url))
  };
}

String prettyPrint(http.Response response) {
  if (response.headers.containsKey('content-type') &&
      response.headers['content-type']!.contains('application/json')) {
    final dynamic jsonResponse = json.decode(response.body);
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(jsonResponse);
  }
  return response.body;
}
