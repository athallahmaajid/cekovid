import 'package:flutter/material.dart';

class BedCard extends StatefulWidget {
  final title;
  final date;
  final beds;
  final empty;
  final queue;
  const BedCard(
      {Key? key,
      required this.title,
      required this.date,
      required this.beds,
      required this.empty,
      required this.queue})
      : super(key: key);

  @override
  _BedCardState createState() => _BedCardState();
}

class _BedCardState extends State<BedCard> with SingleTickerProviderStateMixin {
  var _animationController;
  bool _isPressed = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(2.0, 2.0),
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isPressed = !_isPressed;
                if (_isPressed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text("Diupdate pada ${widget.date}"),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animationController,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black12,
              ),
              height: (_isPressed) ? 100 : 0,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF38A169),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Tempat Tidur"),
                        Text("${widget.beds}"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFF3182CE),
                    ),
                    child: Column(
                      children: [
                        Text("Kosong"),
                        Text("${widget.empty}"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFFDD6B20),
                    ),
                    child: Column(
                      children: [
                        Text("Antrean"),
                        Text("${widget.queue}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
