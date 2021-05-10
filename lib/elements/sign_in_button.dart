import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  SignInButton({this.icon, this.text, this.color, this.borderRadius, this.onPressHandler});

  final Widget icon;
  final String text;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressHandler;

  @override
  Widget build(BuildContext context) {
    final double _iconSize = 30.0;
// ignore: deprecated_member_use
    return RaisedButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      onPressed: onPressHandler,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: Center(
              child: icon,
            ),
          ),
          Center(
            child: Text(text),
          ),
          SizedBox(
            width: _iconSize,
            height: _iconSize * 1.4,
          ),
        ],
      ),
    );
  }
}
