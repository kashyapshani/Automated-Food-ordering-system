import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'scanner.dart';

import '../Clipper/oval-right-clipper.dart';

class H1 extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<H1> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar( title:
      //Center(

        //child:
      Text(
          'Menu',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 25,
          ),
        ),
        //   iconTheme: new IconThemeData(color: Colors.red),
     // ),
        iconTheme: new IconThemeData(color: Colors.orange),
        backgroundColor: Colors.transparent,
        elevation: 0.0,),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white,Colors.white,Colors.white,Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50], Colors.orange[100],Colors.orange[200],Colors.orange])),
      ),
//      body: Stack(
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: NetworkImage(
//                    'https://i.pinimg.com/564x/ab/dc/7c/abdc7c2e51ba059be8b51bffc159f5b5.jpg'),
//                fit: BoxFit.cover,
//              ),
//            ),
//            child: Center(
//              child: Text(
//                '',
//                style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 30,
//                ),
//              ),
//            ),
//          ),
//          Positioned(
//            child: AppBar(
//              title: Text("Transparent AppBar"),
//              backgroundColor: Colors.transparent,
//              iconTheme: new IconThemeData(color: Colors.red),
//              elevation: 0,
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.share),
//                  onPressed: () {},
//                  tooltip: 'Share',
//                ),
//              ],
//            ),
//          )
//        ],
//      ),
//

    );
  }

  _buildDrawer() {
    // final String image = images[0];
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: Colors.orange[50], boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: active,
                      ),
                      onPressed: () {},
                    ),
                  ),

                  SizedBox(height: 50.0),

                  Text(
                    "Shubham",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),

                  ),

                  SizedBox(height: 50.0,),

                  _buildRow(Icons.restaurant_menu, "Menu"),
                  _buildDivider(),
                  _buildRow(
                    MdiIcons.qrcodeScan,
                    "Scan",
                  ),
                  _buildDivider(),
                  _buildRow(
                    MdiIcons.clipboardListOutline,
                    "Order Details",

                  ),
                  _buildDivider(),
                  _buildRow(Icons.phone, "Contact Us"),
                  _buildDivider(),
                  _buildRow(Icons.power_settings_new, "Logout"),
                  _buildDivider(),



                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    //final children = <Widget>[];

//    final List<Widget> s1 = [
//
//      //BottomNavBar(),
//   //   restuarant(),
//      Scanner(),
//      order(),
//
//      // PlaceholderWidget(Colors.deepOrange),
//
//    ];
//    for (var i = 0; i < 5; i++) {
//
//    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [

        Icon(
          icon,
          color: Colors.black,
        ),
        SizedBox(width: 5.0,

        ),

        SizedBox(
          width: 200,
          height: 35,
          child: RaisedButton(

            highlightElevation: 0.0,
            splashColor: Colors.orange,
            highlightColor: Colors.orange[50],
            elevation: 0.0,
            color: Colors.orange[50],
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 20),
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Scanner()));


            },
          ),
        ),


//        Text(
//          title,
//          style: tStyle,
//
//        ),
        // Spacer(),

      ]),
    );
  }


}
//
//class BottomNavBar extends StatefulWidget {
//  @override
//  _BottomNavBarState createState() => _BottomNavBarState();
//}
//
//class _BottomNavBarState extends State<BottomNavBar> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar( title: Center(
//
//        child: Text(
//          'Menu',
//          style: TextStyle(
//            color: Colors.orange,
//            fontSize: 30,
//          ),
//        ),
//      ),
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,),
//      extendBodyBehindAppBar: true,
//      body: Container(
//        decoration: BoxDecoration(
//            gradient: LinearGradient(
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//                colors: [Colors.white,Colors.white,Colors.white,Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50],Colors.orange[50], Colors.orange[100],Colors.orange[200],Colors.orange])),
//      ),
//    );
//  }
//}