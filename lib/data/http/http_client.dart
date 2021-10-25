import 'package:flutter/material.dart';

abstract class HttpClient<ResponseType> {
  Future<ResponseType> request(
      {@required String url, @required method, Map body});
}
