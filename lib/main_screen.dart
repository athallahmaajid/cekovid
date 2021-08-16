import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cekovid/navigator_button.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Cekovid"), backgroundColor: Color(0xFFc90015)),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFc90015)),
                child: Center(
                  child: Image(image: AssetImage("assets/corona.png")),
                ),
              ),
              ListTile(
                title: Text("Home"),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed("/home"),
              ),
              ListTile(
                title: Text("Covid Data"),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed("/covidData"),
              ),
              ListTile(
                title: Text("Covid News"),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed("/news"),
              ),
              ListTile(
                title: Text("Covid Hospital"),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed("/hospital"),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 2,
            height: MediaQuery.of(context).size.height / 3,
            child: SvgPicture.asset("assets/empty_street_red.svg"),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavigatorButton(
                firstText: "Covid 19 di",
                secondText: "Indonesia",
                destination: '/covidData',
              ),
              NavigatorButton(
                firstText: "Berita Covid",
                secondText: "di Indonesia",
                destination: '/news',
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavigatorButton(
                firstText: "Cari",
                secondText: "Rumah Sakit",
                destination: '/hospital',
              ),
            ],
          )
        ],
      ),
    );
  }
}
