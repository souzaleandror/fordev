import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/i18n/i18n.dart';

class SurveyResultPage extends StatelessWidget {
  const SurveyResultPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding:
                  EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withAlpha(90),
              ),
              child: Text(
                'Qual e o seu framework web favorito ?',
              ),
            );
          }
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      'http://fordevs.herokuapp.com/static/img/logo-angular.png',
                      width: 40,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          'React',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).highlightColor,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
