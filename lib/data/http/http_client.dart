abstract class HttpClient {
  Future<dynamic> request({
    required String url,
    required method,
    Map? body,
    Map? headers,
  });
}
