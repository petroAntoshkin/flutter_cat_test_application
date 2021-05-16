import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            width: 40.0,
            height: 40.0,
            child: Center(
              child: Image.asset('assets/icon/icon.png'),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('Flutter Cat Test App', textAlign: TextAlign.center,),
            ),
          ),
          SizedBox(
            width: 40.0,
            height: 40.0,
          ),

        ],
      ),
    );
  }
}
