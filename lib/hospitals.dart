import 'package:flutter/material.dart';
import 'package:cekovid/loading_widget.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'package:cekovid/static_data.dart';
import 'dart:convert';
import 'package:cekovid/hospital_detail.dart';

class CovidHospital extends StatefulWidget {
  const CovidHospital({Key? key}) : super(key: key);

  @override
  _CovidHospitalState createState() => _CovidHospitalState();
}

class _CovidHospitalState extends State<CovidHospital> {
  bool _isLoading = true;

  List hospitals = [];

  Widget widgetPlaceholder = Center(
    child: Text("You are not in Indonesia"),
  );

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Future<void> getHospitals() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Request Permission from user
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check permission from user
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        widgetPlaceholder = Center(
          child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Text("Please turn on your gps")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    _locationData = await location.getLocation();

    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
            _locationData.latitude!, _locationData.longitude!);

    geocoding.Placemark userLocation = placemarks[0];

    String provinceCode = "";
    String cityCode = "";

    for (var province in provincesWithCities) {
      if (province['province']['name'] == userLocation.administrativeArea) {
        for (var city in province['cities']) {
          if (city['name'] == userLocation.subAdministrativeArea) {
            provinceCode = province['province']['key'];
            cityCode = city['code'];
            break;
          }
        }
      }
    }

    if (placemarks[0].country == "Indonesia" &&
        provinceCode != "" &&
        cityCode != "") {
      var rsBed = await http.get(Uri.parse(
          "https://rs-bed-covid-api.vercel.app/api/get-hospitals?provinceid=$provinceCode&cityid=$cityCode&type=1"));
      var res = json.decode(rsBed.body);

      hospitals = res['hospitals'];

      // Widget
      widgetPlaceholder = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Rumah Sakit terupdate di ${userLocation.subAdministrativeArea}",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hospitals.length,
              itemBuilder: ((context, index) {
                var _isPressed = false;
                return GestureDetector(
                  onTapDown: (event) {
                    setState(() {
                      _isPressed = true;
                    });
                  },
                  onTapUp: (event) {
                    setState(() {
                      _isPressed = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: (_isPressed) ? Colors.blue : Colors.white,
                      border: Border.all(
                        color: (hospitals[index]['bed_availability'] == 0)
                            ? Color(0xFFa11616)
                            : Colors.transparent,
                        width: 5,
                      ),
                    ),
                    child: Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  hospitals[index]['name'],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hospitals[index]['address'],
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (hospitals[index]['bed_availability'] ==
                                              0)
                                          ? Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 20, 10, 20),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFa11616),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                "Penuh!",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Container(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Tersedia: ${hospitals[index]['bed_availability']}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    (hospitals[index]
                                                                ['queue'] ==
                                                            0)
                                                        ? "Tanpa antrean"
                                                        : "Antrean: ${hospitals[index]['queue']}",
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _launchURL(
                                    'tel:://${hospitals[index]['phone']}');
                              },
                              child: (hospitals[index]['phone'] == null)
                                  ? IgnorePointer(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Color(0xA8004455),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.phone,
                                                color: Colors.white),
                                            Text(
                                              "Tidak Tersedia",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 15),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF004469),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colors.white),
                                          Text(
                                            hospitals[index]['phone'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            Wrap(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      var responseDetail = await http.get(Uri.parse(
                                          "https://rs-bed-covid-api.vercel.app/api/get-hospital-map?hospitalid=${hospitals[index]['id']}"));
                                      var detailData = json
                                          .decode(responseDetail.body)['data'];
                                      _launchURL(
                                          'https://www.google.com/maps/search/?api=1&query=${detailData['lat']},${detailData['long']}');
                                    },
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xFF004469)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Color(0xFFc90015),
                                          size: 14,
                                        ),
                                        Text(
                                          "Lokasi",
                                          style: TextStyle(
                                            color: Color(0xFFc90015),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HospitalDetail(
                                                      id: hospitals[index]
                                                          ["id"])));
                                    },
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xFF004469)),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Detail",
                                      style: TextStyle(
                                        color: Color(0xFFc90015),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Text(
                          "${hospitals[index]["info"].substring(8, hospitals[index]["info"].length)}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc90015),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFFc90015),
        elevation: 0,
      ),
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
                title: Text("Hospitals"),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed("/hospital"),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getHospitals,
          child: (_isLoading)
              ? LoadingWidget(callbackFunc: getHospitals)
              : widgetPlaceholder,
        ),
      ),
    );
  }
}
