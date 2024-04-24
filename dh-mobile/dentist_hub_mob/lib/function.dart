import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String?> sendData(String url, String username, String password) async {
  try {
    Map<String, String> data = {
      'username': username,
      'password': password,
    };

    String jsonData = jsonEncode(data);
    String ok = "true";

    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ok;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
