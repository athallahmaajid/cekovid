import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cekovid/loading_widget.dart';
import 'package:cekovid/bed_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6c63ff),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF6c63ff),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: getDetail,
        child: (_isLoading)
            ? LoadingWidget(
                callbackFunc: getDetail,
              )
            : ListView.builder(
                itemCount: (detailData["data"]["bedDetail"]).length,
                itemBuilder: (context, index) {
                  return BedCard(
                    title: detailData["data"]["bedDetail"][index]["stats"]
                        ["title"],
                    date: detailData["data"]["bedDetail"][index]["time"],
                    beds: detailData["data"]["bedDetail"][index]["stats"]
                        ["bed_available"],
                    empty: detailData["data"]["bedDetail"][index]["stats"]
                        ["bed_empty"],
                    queue: detailData["data"]["bedDetail"][index]["stats"]
                        ["queue"],
                  );
                },
              ),
      ),
    );
  }
}
