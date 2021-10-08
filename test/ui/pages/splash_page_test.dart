import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:test/test.dart' as test;
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4Dev'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    return tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => SplashPage(),
          ),
        ],
      ),
    );
  }

  testWidgets('Should presenter spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    test.expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
