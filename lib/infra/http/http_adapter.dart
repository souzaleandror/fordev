import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fordev/data/http/http.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({@required String url, @required method, Map body}) async {
    
    final headers = {'content-type': 'application/json', 'accept': 'application/json'};
    final jsonBody = body != null ? jsonEncode(body) : body;
    final response = await client.post(url, headers: headers, body: jsonBody);
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if(response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw HttpError.badRequest;
    }
  }

}