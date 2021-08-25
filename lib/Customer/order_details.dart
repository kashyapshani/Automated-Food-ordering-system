import 'package:flutter/material.dart';

class order extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.orange,
        dividerColor: Colors.grey,
      ),
      home: order_screen(),
    );
  }
}

class order_screen extends StatefulWidget {
  @override
  _order_screenState createState() => _order_screenState();
}

class _order_screenState extends State<order_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 50,


        title: Center(

          child: Text(
            '      Order Details',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Logout"),
              ),

            ],

            onSelected: (value) {
              //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Add_item()));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.orange[50],
      ),
    );
  }
}


