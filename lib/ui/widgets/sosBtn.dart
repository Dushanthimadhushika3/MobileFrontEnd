import 'package:flutter/material.dart';

class SosButton extends StatelessWidget {
  SosButton({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    Image _buildLogo() {
      return Image.asset(
        "sos.jpg",
        height: 18.0,
        width: 18.0,
      );
    }
    return MaterialButton(
      height: 40.0,
      onPressed: this.onPressed,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLogo(),
        ],
      ),
    );
  }
}
