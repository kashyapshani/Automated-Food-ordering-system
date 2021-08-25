import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Customer/Home.dart';
import '../login.dart';
import '../Clipper/oval-right-clipper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'scanner.dart';
import 'menu.dart';
import '../Customer/order_details.dart';
import 's1.dart';



class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 5;
  int _currentIndex = 0;


  final List<Widget> _children = [

    menu(),
    Scanner(),
    order(),

   // PlaceholderWidget(Colors.deepOrange),
  ];


  //final List<Widget> _children = [];
  GlobalKey _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;
  final GlobalKey _draw = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
        bottomNavigationBar: CurvedNavigationBar(
          onTap: onTabTapped, // new
       //   currentIndex: _currentIndex,
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
          //  Icon(Icons.home, size: 30),
            Icon(Icons.restaurant_menu, size: 30),
            Icon(MdiIcons.qrcodeScan, size: 30),
            Icon(MdiIcons.clipboardListOutline, size: 30),
         //   Icon(Icons.person, size: 30),
          ],
          color: Colors.white,

          buttonBackgroundColor: Colors.orangeAccent,
          backgroundColor: Colors.orange,

          animationCurve: Curves.easeOutCubic,
          //animationDuration: Duration(milliseconds: 600),
//          onTap: (index) {
//            setState(() {
//              _page = index;
//            }
//
//            );
//          },
        ),
        body:
        Stack(
          //color: Colors.blueAccent,
          children: <Widget>[

            _children[_currentIndex],
                      Positioned(
                          height: 100,
                          width: 50,
              child: AppBar(
//                      decoration: BoxDecoration(
//                          color: Colors.transparent
//                        ),
                leading: IconButton(icon: Icon(Icons.menu,color: Colors.white,),
//                    onPressed: ()
//                    {
//                      _buildDrawer().currentState.openDrawer();
//                    }
                ),

                title: Text("xyz"),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(50),

                  ),
                ),
                iconTheme: new IconThemeData(color: Colors.orange[50]),
                backgroundColor: Colors.orange,
               elevation: 16,
//                actions: <Widget>[
//                ],
             ),
               //extendBodyBehindAppBar: true,
            )
          ],
        )
    );
  }
  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      preferences.setDouble("phone", null);
      preferences.setString("privilege", null);
      preferences.commit();
      Navigator.of(context)
          .pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext
              context) =>
              new Login()),
              (Route<dynamic> route) =>
          false);
    });
  }


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

    });
  }

  void onTabPressed(int index){
    setState(() {
      _currentIndex = index;

    });
  }

  _buildDrawer() {
    // final String image = images[0];
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        key: _draw,
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
                      onPressed: () {
                        signOut();
                      },
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

                 // _buildRow(Icons.restaurant_menu, "Menu"),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.restaurant_menu,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5.0,

                      ),
                      SizedBox(
                        width: 200,
                          height: 50,
                        child: RaisedButton(

                          highlightElevation: 0.0,
                          splashColor: Colors.orange,
                          highlightColor: Colors.orange[50],
                          elevation: 0.0,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 20),
                          ),

                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => _children[0]));

                          },
                        ),
                      ),

                    ],
                  ),

                  _buildDivider(),
//                  _buildRow(
//                    MdiIcons.qrcodeScan,
//                    "Scan",
//                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        MdiIcons.qrcodeScan,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5.0,

                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(

                          highlightElevation: 0.0,
                          splashColor: Colors.orange,
                          highlightColor: Colors.orange[50],
                          elevation: 0.0,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'QR Scan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 20),
                          ),

                          onPressed: (){},
                        ),
                      ),

                    ],
                  ),


                  _buildDivider(),
//                  _buildRow(
//                    MdiIcons.clipboardListOutline,
//                    "Order Details",
//
//                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        MdiIcons.clipboardListOutline,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5.0,

                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(

                          highlightElevation: 0.0,
                          splashColor: Colors.orange,
                          highlightColor: Colors.orange[50],
                          elevation: 0.0,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Orders Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 20),
                          ),

                          onPressed: (){},
                        ),
                      ),

                    ],
                  ),

                  _buildDivider(),
                  //_buildRow(Icons.phone, "Contact Us"),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.phone,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5.0,

                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(

                          highlightElevation: 0.0,
                          splashColor: Colors.orange,
                          highlightColor: Colors.orange[50],
                          elevation: 0.0,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Contact Us',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 20),
                          ),

                          onPressed: (){},
                        ),
                      ),

                    ],
                  ),
                  _buildDivider(),
                  //_buildRow(Icons.power_settings_new, "Logout"),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.power_settings_new,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5.0,

                      ),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(

                          highlightElevation: 0.0,
                          splashColor: Colors.orange,
                          highlightColor: Colors.orange[50],
                          elevation: 0.0,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                                fontSize: 20),
                          ),

                          onPressed: (){
                              signOut();
                          },
                        ),
                      ),

                    ],
                  ),
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

//  Widget _buildRow(IconData icon, String title, {bool showBadge = false}  ) {
//    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
//    //final children = <Widget>[];
//
////    final List<Widget> s1 = [
////
////      //BottomNavBar(),
////   //   restuarant(),
////      Scanner(),
////      order(),
////
////      // PlaceholderWidget(Colors.deepOrange),
////
////    ];
////    for (var i = 0; i < 5; i++) {
////
////    }
//
//    return Container(
//      padding: const EdgeInsets.symmetric(vertical: 5.0),
//      child: Row(children: [
//
////        Icon(
////          icon,
////          color: Colors.black,
////        ),
////        SizedBox(width: 5.0,
////
////        ),
////
////        SizedBox(
////          width: 200,
////          height: 35,
////          child: RaisedButton(
////
////            highlightElevation: 0.0,
////            splashColor: Colors.orange,
////            highlightColor: Colors.orange[50],
////            elevation: 0.0,
////            color: Colors.orange[50],
////            shape: RoundedRectangleBorder(
////                borderRadius: new BorderRadius.circular(30.0)),
////            child: Text(
////              title,
////              style: TextStyle(
////                  fontWeight: FontWeight.bold,
////                  color: Colors.orange,
////                  fontSize: 20),
////            ),
////
////            onPressed: ,
////            ),
////    ),
//
//
////        Text(
////          title,
////          style: tStyle,
////
////        ),
//       // Spacer(),
//
//      ]),
//    );
//  }

}
