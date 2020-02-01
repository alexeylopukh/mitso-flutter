import 'dart:convert';
import 'dart:io';

class HttpGet {
  Future<String> getPage(String url) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}
