import 'package:flutter/cupertino.dart';

abstract class HttpClient {
  Future<Map> request({@required String url, @required method, Map body});
}
