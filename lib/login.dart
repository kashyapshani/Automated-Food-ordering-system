import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Customer/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'Admin/Admin_dashboard.dart';
import 'Clipper/BottomWaveClipper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }


class _LoginState extends State<Login> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  final _reg = new GlobalKey<FormState>();

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String name, email, password;
  String privilege;
  int value;
  String phoneNo;
  bool _secureText = true;


  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response =
      await http.post("http://192.168.0.106:81/Login/login.php", body: {

      "email": email,
      "password": password

    });

    final data = jsonDecode(response.body);
    print(data);
    email = data["0"]['email'];
    name = data["0"]['username'];
    String id = data["0"]['id'];
    phoneNo = data["0"]['phone'];
    privilege = data["0"]['privilege'];
    String message = data['message'];
    value = data['value'];


    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, email, name, id, phoneNo , privilege);
        print(privilege);
        Navigator.pop(context);
      });
      print(data);
      print(privilege);
      print(message);
      loginToast(message);

    } else {
      print("fail");
      print(message);
      loginToast(message);
    }
  }

  checkreg() {
    final form = _reg.currentState;
    if(form.validate()) {
      form.save();
      register();
    }
  }

  register() async {
    final response = await http
        .post("http://192.168.0.106:81/Login/registration.php", body: {
      //"flag": 1.toString(),
      "name": name,
      "email": email,
      "password": password,
      "phone": phoneNo,
      //"fcm_token": "test_fcm_token"
    });

    final data = jsonDecode(response.body);
   // print(data);
    value = data['value'];
    String message = data['message'];

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        Navigator.pop(context);
      });
      print(message);
      loginToast(message);
    } else {
      print("fail");
      print(message);
      loginToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  savePref(int value, String email, String name, String id, String phone, String privilege) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.setString("phone", phone);
      preferences.setString("privilege", privilege);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      privilege = preferences.getString("privilege");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
      print(privilege);

    });
  }

//  checkPref() async
//  {
//    if(value == 1 && privilege == "user")
//      {
//        Navigator.of(context)
//            .pushAndRemoveUntil(
//            MaterialPageRoute(
//                builder: (BuildContext
//                context) =>
//                new Home()),
//                (Route<dynamic> route) =>
//            false);
//      }
//    else if(value == 1 && privilege == "admin") {
//      Navigator.of(context)
//          .pushAndRemoveUntil(
//          MaterialPageRoute(
//              builder: (BuildContext
//              context) =>
//              new dashboard()),
//              (Route<dynamic> route) =>
//          false);
//    }
//  }

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
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
   // checkPref();
  }

  void _showLoginSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (builder) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              clipBehavior: Clip.hardEdge,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
                child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: 0.95,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          height: 450,
                          alignment: Alignment.topCenter,
                          child: Center(
                              child: Form(
                            key: _key,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          //    border: new OutlineInputBorder(
                                          //     borderRadius: const BorderRadius.all(
                                          //       const Radius.circular(10.0),
                                          //       ),
                                          //    ),
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Email",
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      onSaved: (e) => email = e,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
                                      validator: (e){if(e.isEmpty){
                                        return "Please Enter your Email";
                                      }},
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                    'OR',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Phone",
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
                                        //maxLength: 10,
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      //maxLengthEnforced: true,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Password",
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      obscureText: _secureText,
                                      validator: (e) {
                                        if (e.isEmpty) {
                                          return "Please Enter Password";
                                          // ignore: missing_return
                                        }
                                      },
                                      onSaved: (e) => password = e,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
//                                      maxLength: 24,
//                                      maxLengthEnforced: true,
                                    ),
                                    onPressed: () {
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: RaisedButton(
                                        highlightElevation: 0.0,
                                        splashColor: Colors.white,
                                        highlightColor: Colors.white,
                                        elevation: 0.0,
                                        color: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                            check();

                                        })),
                              ],
                            ),
                          )),
                        ));
                  },
                ),
              ),
            ),
          );
        });
  }

  void _showRegistartionsheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (builder) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              clipBehavior: Clip.hardEdge,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                  ),
                ),
                child: DraggableScrollableSheet(
                  initialChildSize: 1,
                  minChildSize: 0.95,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          height: 500,
                          alignment: Alignment.topCenter,
                          child: Center(
                              child: Form(
                            key: _reg,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Name",
                                          prefixIcon: const Icon(
                                            Icons.people,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
                                      validator: (e) {
                                        if (e.isEmpty) {
                                          return "Please Enter Your Name";
                                        }
                                      },
                                      onSaved: (e) {
                                        name = e;
                                      },
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                //   SizedBox(height: 3,),
                                SizedBox(
                                  height: 25,
                                ),
                                //   SizedBox(height: 3,),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Email",
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
                                      onSaved: (e) {
                                        email = e;
                                      },
                                    validator: (e){if(e.isEmpty){
                                      return "Please Enter Your Email";
                                    }},),
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(

                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Phone",
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
                                        keyboardType: TextInputType.number,
                                      //maxLength: 10,
                                      onSaved: (e) {
                                        phoneNo = e;//int.parse(e);
                                      },
                                        validator: (e){if(e.isEmpty){
                                          return "Please Enter Your Mobile Number";
                                        }}),
                                    onPressed: () {},
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: OutlineButton(
                                    highlightedBorderColor: Colors.orange,
                                    borderSide: BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    highlightElevation: 0.0,
                                    splashColor: Colors.orange,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.orange),
                                          hintText: "Password",
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.orange,
                                          ),
                                          fillColor: Colors.white),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 15),
                                      //maxLength: 24,
                                      onSaved: (e) {
                                        password = e;
                                      },obscureText: _secureText,
                                    validator: (e){if(e.isEmpty){
                                      return "Please Enter Password";
                                    }},),
                                    onPressed: () {showHide();},
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: RaisedButton(
                                        highlightElevation: 0.0,
                                        splashColor: Colors.white,
                                        highlightColor: Colors.white,
                                        elevation: 0.0,
                                        color: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          checkreg();
                                        })),
                              ],
                            ),
                          )),
                        ));
                  },
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Colors.orange,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 250),
              SizedBox(
                width: 200,
                height: 50,
                child: RaisedButton(
                    highlightElevation: 0.0,
                    splashColor: Colors.orange,
                    highlightColor: Colors.white,
                    elevation: 0.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 20),
                    ),
                    onPressed: _showLoginSheet),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: OutlineButton(
                  highlightedBorderColor: Colors.white,
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  highlightElevation: 0.0,
                  splashColor: Colors.white,
                  highlightColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  onPressed: _showRegistartionsheet,
                ),
              ),
              Expanded(
                child: Align(
                  child: ClipPath(
                    child: Container(
                      color: Colors.white,
                      height: 300,
                    ),
                    clipper: BottomWaveClipper(),
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ));
        break;
      case LoginStatus.signIn:
         if(privilege == "admin")
           {
             return new Dashboard();
           }
         else if(privilege == "user")
           {
             return new BottomNavBar();
           }
         else
           {
             _loginStatus=LoginStatus.notSignIn;
             return Login();
           }
         //return BottomNavBar();
        break;
    }
  }
}
