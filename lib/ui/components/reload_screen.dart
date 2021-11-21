import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';

class RealodScreen extends StatelessWidget {
  const RealodScreen({
    Key key,
    @required this.error,
    @required this.reload,
  }) : super(key: key);

  final String error;
  final Future<void> Function() reload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            this.error,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: reload,
            child: Text(
              R.strings.realoading,
            ),
          ),
        ],
      ),
    );
  }
}
