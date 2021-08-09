import 'package:flutter/material.dart';
import 'package:cekovid/filter.dart';
import 'package:flutter/widgets.dart';
import 'package:cekovid/my_icon_icons.dart';

class CarouselCard extends StatefulWidget {
  final item;
  String itemIndex;
  final penambahan;

  CarouselCard({Key? key, this.item, this.itemIndex: "", this.penambahan})
      : super(key: key);

  @override
  _CarouselCardState createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  Color? baseColor;
  var icon;

  void chooseColorIcon() {
    switch (widget.itemIndex) {
      case "Positif":
        baseColor = Colors.yellow;
        icon = Icon(
          MyIcon.plus_1,
          color: baseColor,
          size: 64.0,
        );
        break;
      case "Meninggal":
        baseColor = Colors.red;
        icon = Icon(
          MyIcon.skull,
          color: baseColor,
          size: 64.0,
        );
        break;
      case "Dirawat":
        baseColor = Colors.blue;
        icon = Icon(
          MyIcon.airline_seat_flat,
          color: baseColor,
          size: 64.0,
        );
        break;
      case "Sembuh":
        baseColor = Colors.green;
        icon = Icon(
          MyIcon.heart,
          color: baseColor,
          size: 64.0,
        );
        break;
    }
  }

  @override
  void initState() {
    chooseColorIcon();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                widget.itemIndex,
                style: TextStyle(color: baseColor, fontSize: 20.0),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: icon,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${filterNumber(widget.item)}",
              style: TextStyle(color: baseColor, fontSize: 24.0),
            ),
          ),
          (widget.penambahan == null)
              ? Container()
              : Expanded(
                  flex: 2,
                  child: Text(
                    (widget.penambahan < 0)
                        ? "${filterNumber(widget.penambahan)}"
                        : "+${filterNumber(widget.penambahan)}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black26),
                  ),
                ),
        ],
      ),
    );
  }
}
