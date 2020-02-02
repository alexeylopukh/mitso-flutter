import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as IoClient;

class HttpGet {
  bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  Future<String> getRequest(String url) async {
    var http = await _httpClient().get(url);
    return http.body;
  }

  Future<String> postRequest(String url, {Map<String, String> body}) async {
    var http = await _httpClient().post(url, body: body);
    return http.body;
  }

  http.Client _httpClient() {
    return IoClient.IOClient(
        HttpClient()..badCertificateCallback = _certificateCheck);
  }
}
