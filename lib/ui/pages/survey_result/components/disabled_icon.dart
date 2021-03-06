import 'package:flutter/material.dart';

class DisabledIcon extends StatelessWidget {
  const DisabledIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: 10,
        ),
        child: Icon(
          Icons.check_circle,
          color: Theme.of(context).disabledColor,
        ),
      );
}
