import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final void Function() onclick;
  final Color color;
  final String text;
  ButtonComponent({required this.text, required this.onclick, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onclick,
          minWidth: 200.0,
          height: 42.0,
          child: Text(text),
        ),
      ),
    );
  }
}
