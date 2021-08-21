import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cekovid/loading_widget.dart';
import 'package:cekovid/bed_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalDetail extends StatefulWidget {
  final id;
  const HospitalDetail({Key? key, required this.id}) : super(key: key);

  @override
  _HospitalDetailState createState() => _HospitalDetailState();
}

class _HospitalDetailState extends State<HospitalDetail> {
  bool _isLoading = true;
  Map detailData = {};

  Future<void> getDetail() async {
    var response = await http.get(Uri.parse(
        "https://rs-bed-covid-api.vercel.app/api/get-bed-detail?hospitalid=${widget.id}&type=1"));
    detailData = json.decode(response.body);
    setState(() {
      _isLoading = false;
    });
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getDetail,
          child: (_isLoading)
              ? LoadingWidget(
                  callbackFunc: getDetail,
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          detailData["data"]["name"],
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(detailData["data"]["address"])),
                      GestureDetector(
                        onTap: () {
                          _launchURL('tel:://${detailData["data"]['phone']}');
                        },
                        child: (detailData['data']['phone'] ==
                                'hotline tidak tersedia')
                            ? IgnorePointer(
                                child: Container(
                                  margin: EdgeInsets.only(top: 15, left: 15),
                                  width: 130,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xA8004455),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone, color: Colors.white),
                                      Text(
                                        "Tidak Tersedia",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 15, left: 15),
                                width: 130,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xFF004469),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.phone, color: Colors.white),
                                    Text(
                                      detailData["data"]['phone'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: (detailData["data"]["bedDetail"]).length,
                        itemBuilder: (context, index) {
                          return BedCard(
                            title: detailData["data"]["bedDetail"][index]
                                ["stats"]["title"],
                            date: detailData["data"]["bedDetail"][index]
                                ["time"],
                            beds: detailData["data"]["bedDetail"][index]
                                ["stats"]["bed_available"],
                            empty: detailData["data"]["bedDetail"][index]
                                ["stats"]["bed_empty"],
                            queue: detailData["data"]["bedDetail"][index]
                                ["stats"]["queue"],
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
