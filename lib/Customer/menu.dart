import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p3/Admin/Add_item.dart';
import 'Home.dart';
import 'package:p3/Instances/Menu_model.dart';

class menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        dividerColor: Colors.grey,
      ),
      home: menu_screen(),
    );
  }
}

class menu_screen extends StatefulWidget {
  @override
  _menu_screenState createState() => _menu_screenState();
}

class _menu_screenState extends State<menu_screen> {
// final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar( title: Center(
//        child: Text(
//          'Menu',
//          style: TextStyle(
//            color: Colors.orange,
//            fontSize: 30,
//          ),
//        ),
//     //   iconTheme: new IconThemeData(color: Colors.red),
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
  int Qty = 1;
  Map data;
  List itemsList;

  Future get_item() async {
    itemsList = new List();
    final response = await http
        .post("http://192.168.0.106:81/Login/get_items.php", body: {});
    data = jsonDecode(response.body); //.cast<Map<dynamic, dynamic>>();

    setState(() {
      itemsList = data['items'];
    });
    print(itemsList);
  }

  @override
  void initState() {
    super.initState();
    get_item();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 30,
            ),
          ),
          //   iconTheme: new IconThemeData(color: Colors.red),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        child: new ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (BuildContext context, int index) =>
                buildMenuCard(context, index)),
      ),
    );
  }

  Widget buildMenuCard(BuildContext context, int index) {
     return new Container(
        height: 150.0,
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            Container(
              child: Container(
                margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                constraints: new BoxConstraints.expand(),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(height: 4.0),
                    new Text(itemsList[index]['I_name'],
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600)),
                    new Container(height: 10.0),
                    new Text("₹" + itemsList[index]['I_price'],
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: const Color(0xffb6b2df),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400)),
                    new Container(
                        margin: new EdgeInsets.symmetric(vertical: 8.0),
                        height: 2.0,
                        width: 25.0,
                        color: new Color(0xff00c6ff)),
                    new Row(
                      children: <Widget>[
                        DropdownButton<int>(
                          //key: _ddmenu,
                          value: Qty,
                          items: <int>[1, 2, 3, 4]
                              .map((value) => DropdownMenuItem<int>(
                                    child: new Text(value.toString()),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (int value) {
                            setState(() {
                              Qty = value;
                            });
                          },
                          isExpanded: false,
                          hint: Qty == null
                              ? Text(
                                  'Please Select Quantity',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 25),
                                )
                              : Text(Qty.toString(),
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 25)),
                        ),
                        new Padding(padding: EdgeInsets.only(right: 10)),
                        new Expanded(
                            child: Row(children: <Widget>[
                          RaisedButton(
                              highlightElevation: 0.0,
                              splashColor: Colors.orange,
                              highlightColor: Colors.white,
                              elevation: 0.0,
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(25.0)),
                              child: Text(
                                'Order Now',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 10),
                              ),
                              onPressed: () {}),
                        ]))
                      ],
                    ),
                  ],
                ),
              ),
              height: 147.0,
              margin: new EdgeInsets.only(left: 40.0),
              decoration: new BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: new Offset(0.0, 10.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(vertical: 16.0),
              alignment: FractionalOffset.centerLeft,
              child: GestureDetector(
                child: ClipOval(
                  child: Image(
                    image: new MemoryImage(
                        base64Decode(itemsList[index]['I_image'])),
                    height: 92.0,
                    width: 92.0,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () {},
              ),
            )
          ],
        ));
  }
}