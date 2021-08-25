import 'package:flutter/material.dart';
import 'Add_item.dart';
import 'Delete_item.dart';
import 'Edit_item.dart';
import 'package:p3/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(ExampleApp());

class Dashboard extends StatefulWidget {
  @override
  _DashboardScreen createState() => _DashboardScreen();
  //  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        primaryColor: Colors.orange,
//        dividerColor: Colors.grey,
//      ),
//      home: DashboardScreen(),
//    );
//  }
}

class _DashboardScreen extends State<Dashboard> {
//  const _DashboardScreen({
//    Key key,
//  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    int _index;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(
                  value: 0,
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (value) {
              signOut();
            },
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: IconTheme.merge(
        data: IconThemeData(
          color: Colors.orange,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                              child: Image.asset(
                            "assets/images/Waiter-logo.jpg",
                            width: 350,
                            height: 150,
                            alignment: Alignment.center,
                          ))),
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.add_to_photos,
                      text: 'Add Item',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Add_item_screen()));
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.delete,
                      text: 'Delete Item',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Delete_item()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.view_list,
                      text: 'View Order',
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: DashboardButton(
                      icon: Icons.mode_edit,
                      text: 'Edit Item',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Edit_item_screen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  const DashboardButton({
    Key key,
    @required this.icon,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.orange.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.6,
              child: FittedBox(
                child: Icon(icon),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textScaleFactor: 0.8,
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                height: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
