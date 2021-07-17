import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppIconTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 5.0),
          Text(
            'Teach 2 Educate \nTask',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    );
  }
}
