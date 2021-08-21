import 'package:flutter/material.dart';
import 'package:cekovid/main_screen.dart';
import 'package:cekovid/covid_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cekovid/news.dart';
import 'package:cekovid/hospitals.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoder, 'assets/covid_19_precautions.svg'),
      null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MainScreen(),
        '/covidData': (BuildContext context) => new CovidData(),
        '/news': (BuildContext context) => new CovidNews(),
        '/hospital': (BuildContext context) => new CovidHospital(),
      },
      theme: ThemeData(
        primaryColor: Color(0xFF5a64ff),
      ),
    );
  }
}
