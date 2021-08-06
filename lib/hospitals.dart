// import 'package:flutter/material.dart';
//
// class CovidHospital extends StatefulWidget {
//   const CovidHospital({Key? key}) : super(key: key);
//
//   @override
//   _CovidHospitalState createState() => _CovidHospitalState();
// }
//
// class _CovidHospitalState extends State<CovidHospital> {
//   bool _isLoading = true;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF6c63ff),
//       extendBodyBehindAppBar: true,
//       drawer: Drawer(
//         child: SafeArea(
//           child: ListView(
//             children: [
//               DrawerHeader(
//                 decoration:
//                 BoxDecoration(color: Color.fromRGBO(90, 100, 255, 1)),
//                 child: Center(
//                   child: Image(image: AssetImage("assets/corona.png")),
//                 ),
//               ),
//               ListTile(
//                 title: Text("Home"),
//                 onTap: () =>
//                     Navigator.of(context).pushReplacementNamed("/home"),
//               ),
//               ListTile(
//                 title: Text("Covid Data"),
//                 onTap: () =>
//                     Navigator.of(context).pushReplacementNamed("/covidData"),
//               ),
//               ListTile(
//                 title: Text("Covid News"),
//                 onTap: () =>
//                     Navigator.of(context).pushReplacementNamed("/news"),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               flexibleSpace: Text(""),
//               backgroundColor: Color(0xFF6c63ff),
//             ),
//             (_isLoading)
//                 ? LoadingWidget(callbackFunc: getNews)
//                 : SliverList(
//               delegate: SliverChildBuilderDelegate((context, index) {
//                 bool _isPressed = false;
//                 return GestureDetector(
//                   onTap: () => _launchURL(news[index]['link']),
//                   onTapDown: (event) {
//                     setState(() {
//                       _isPressed = true;
//                     });
//                   },
//                   onTapUp: (event) {
//                     setState(() {
//                       _isPressed = false;
//                     });
//                   },
//                   child: Container(
//                     margin: EdgeInsets.all(15),
//                     padding: EdgeInsets.all(10.0),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: (_isPressed) ? Colors.blue : Colors.white),
//                     child: Column(
//                       children: [
//                         Container(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             news[index]["title"],
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           news[index]["desc"],
//                           style: TextStyle(fontSize: 12),
//                         ),
//                         Divider(),
//                         Text(
//                           news[index]["time"],
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }, childCount: news.length),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
