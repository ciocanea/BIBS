import 'package:http/http.dart' as http;

Future<bool> hasInternetAccess() async {
  try {
    final response = await http
        .get(Uri.parse('https://www.google.com'))
        .timeout(const Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}