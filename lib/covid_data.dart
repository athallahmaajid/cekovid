import 'package:cekovid/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cekovid/static_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cekovid/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cekovid/carousel_card.dart';

class CovidData extends StatefulWidget {
  CovidData({Key? key}) : super(key: key);

  @override
  _CovidDataState createState() => _CovidDataState();
}

class _CovidDataState extends State<CovidData> {
  String negara = "ID";
  String provinsi = "Nasional";
  String? param;

  bool _loading = true;
  bool _provinceAvailable = true;
  var callbackFunc;
  Map displayData = {};
  Map penambahan = {};

  @override
  void initState() {
    callbackFunc = fetchIndonesiaData;
    super.initState();
  }

  void fetchIndonesiaData() async {
    var response = await http
        .get(Uri.parse("https://data.covid19.go.id/public/api/update.json"));
    var data = json.decode(response.body);
    IndonesiaData finalData = IndonesiaData.fromJson(data['update']['total']);
    setState(() {
      penambahan = data["update"]['penambahan'];
      penambahan = {
        "Positif": penambahan["jumlah_positif"],
        "Dirawat": penambahan["jumlah_dirawat"],
        "Sembuh": penambahan["jumlah_sembuh"],
        "Meninggal": penambahan["jumlah_meninggal"]
      };
      displayData = finalData.toMap();
      _loading = false;
    });
  }

  void getGlobalData(String country) async {
    var data;
    if (country == "Global") {
      data = await http.get(Uri.parse("https://covid19.mathdro.id/api/"));
    } else {
      data = await http
          .get(Uri.https("covid19.mathdro.id", "/api/countries/$country/"));
    }
    data = json.decode(data.body);
    setState(() {
      penambahan = {};
      displayData = {
        "Positif": data["confirmed"]['value'],
        "Meninggal": data["deaths"]['value']
      };
      _loading = false;
    });
  }

  void getProvincesData(String provinceName) async {
    var data;
    Map result = {};
    data = await http
        .get(Uri.parse("https://data.covid19.go.id/public/api/prov.json"));
    data = json.decode(data.body)['list_data'];
    for (var i = 0; i < data.length; i++) {
      if (data[i]['key'] == provinceName.toUpperCase()) {
        result = data[i];
      }
    }
    setState(() {
      penambahan = result.remove("penambahan");
      penambahan = {
        "Positif": penambahan["positif"],
        "Sembuh": penambahan["sembuh"],
        "Meninggal": penambahan["meninggal"]
      };
      displayData = {
        "Positif": result["jumlah_kasus"],
        "Dirawat": result["jumlah_dirawat"],
        "Sembuh": result["jumlah_sembuh"],
        "Meninggal": result["jumlah_meninggal"]
      };
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6c63ff),
      appBar: AppBar(
        backgroundColor: Color(0xFF6c63ff),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(90, 100, 255, 1)),
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
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: negara,
                  items: countries.map<DropdownMenuItem<String>>((value) {
                    if (value == "World") {
                      return DropdownMenuItem(
                          value: value, child: Text("Global"));
                    }
                    return DropdownMenuItem(
                      value: value,
                      child: Row(
                        children: [
                          (value == "Global")
                              ? Container()
                              : SizedBox(
                                  width: 20,
                                  height: 15,
                                  child: SvgPicture.asset(
                                    "assets/flags/${value.toLowerCase()}.svg",
                                    height: 15,
                                    width: 10,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("$value")
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      negara = "$value";
                      _loading = true;
                      if (negara == "ID") {
                        callbackFunc = fetchIndonesiaData;
                        param = null;
                        _provinceAvailable = true;
                      } else {
                        callbackFunc = getGlobalData;
                        param = negara;
                        _provinceAvailable = false;
                      }
                    });
                  },
                ),
              ),
              (_provinceAvailable)
                  ? DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: provinsi,
                        items: mapProvinsi.keys
                            .toList()
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provinsi = "$value";
                          _loading = true;
                          setState(() {
                            if (value == "Nasional") {
                              callbackFunc = fetchIndonesiaData;
                              param = null;
                            } else {
                              callbackFunc = getProvincesData;
                              param = provinsi;
                            }
                          });
                        },
                      ),
                    )
                  : Container()
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 7),
          (_loading)
              ? LoadingWidget(
                  callbackFunc: callbackFunc,
                  param: param,
                )
              : CarouselSlider(
                  items: displayData.keys.toList().map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CarouselCard(
                          item: displayData[i],
                          itemIndex: i,
                          penambahan: penambahan[i],
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.5,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )),
        ],
      ),
    );
  }
}
