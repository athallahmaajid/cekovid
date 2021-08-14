import 'package:flutter/material.dart';

class NavigatorButton extends StatefulWidget {
  final firstText;
  final secondText;
  final destination;
  const NavigatorButton(
      {Key? key, this.firstText, this.secondText, this.destination})
      : super(key: key);

  @override
  _NavigatorButtonState createState() => _NavigatorButtonState();
}

class _NavigatorButtonState extends State<NavigatorButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, widget.destination),
      onTapDown: (event) {
        setState(() {
          _isPressed = !_isPressed;
        });
      },
      onTapUp: (event) {
        setState(() {
          _isPressed = !_isPressed;
        });
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        color: (_isPressed) ? Colors.blue : Color(0xFFe6e6e6ff),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(widget.firstText),
              Text(widget.secondText),
            ],
          ),
        ),
      ),
    );
  }
}
