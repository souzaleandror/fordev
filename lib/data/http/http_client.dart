abstract class HttpClient {
  Future<Map>? request({required String? url, required method, Map? body});
}
