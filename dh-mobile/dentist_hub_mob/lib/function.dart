import 'package:http/http.dart' as http;

Future<String?> sendData(String url) async {
  try {
    http.Response response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
