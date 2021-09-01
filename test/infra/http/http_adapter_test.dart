import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({@required Uri url, @required method}) async {
    final headers = {'content-type': 'application/json', 'accept': 'application/json'};
    await client.post(url, headers: headers);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();
      var uri = Uri.parse(url);

      await sut.request(url: uri, method: 'post');

      verify(client.post(uri, headers: {'content-type': 'application/json', 'accept': 'application/json'}));
      //verify(response);
    });
  });
}