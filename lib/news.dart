import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cekovid/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CovidNews extends StatefulWidget {
  const CovidNews({Key? key}) : super(key: key);

  @override
  _CovidNewsState createState() => _CovidNewsState();
}

class _CovidNewsState extends State<CovidNews> {
  List<Map> news = [];
  bool _isLoading = true;

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Future<void> getNews() async {
    var response = await http
        .get(Uri.parse("https://covid19-news-api-self.vercel.app/api/news"));
    var data = json.decode(response.body);
    for (var i = 1; i < data.length + 1; i++) {
      news.add(data["$i"]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6c63ff),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF6c63ff),
        elevation: 0,
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
              ListTile(
                title: Text("Hospital"),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed("/hospital"),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: (_isLoading)
            ? LoadingWidget(callbackFunc: getNews)
            : RefreshIndicator(
                onRefresh: getNews,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 15),
                              child: Text(
                                "Berita Covid terbaru",
                                style: TextStyle(fontSize: 24),
                              )),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        itemCount: news.length,
                        itemBuilder: ((context, index) {
                          var _isPressed = false;
                          return GestureDetector(
                            onTap: () => _launchURL(news[index]['link']),
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
                                  color: (_isPressed)
                                      ? Colors.blue
                                      : Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      news[index]["title"],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    news[index]["desc"],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Divider(),
                                  Text(
                                    news[index]["time"],
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
                ),
              ),
      ),
    );
  }
}
