import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:p3/login.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add_item_screen extends StatefulWidget {
  @override
  _Add_item_screenState createState() => _Add_item_screenState();
}

class _Add_item_screenState extends State<Add_item_screen> {
  final _item = new GlobalKey<FormState>();

  String i_name, desc;
  var price;
  String id = "I" + DateTime.now().toString() + TimeOfDay.now().toString();
  File _image;

  double _inputHeight = 50;
  final TextEditingController _textEditingController = TextEditingController();

  void check() {
    final form = _item.currentState;
    if (form.validate()) {
      form.save();
      add_item();
    }
  }

  add_item() async {
    var stream = new http.ByteStream(_image.openRead());
    var length = await _image.length();
    var img_name = basename(_image.path);
    var url = Uri.parse("http://192.168.0.106:81/Login/add_item.php");
    var file = new http.MultipartFile("image", stream, length,
        filename: img_name);

    print(img_name);
    final req = await http.MultipartRequest("POST", url);
    req.fields["id"] = id;
    req.fields["i_name"] = i_name;
    req.fields["desc"] = desc;
    req.files.add(file);
    //req.fields["img_name"]= img_name;
    req.fields["price"] = price;

    var result, status, message;

    final response = await req.send();
      response.stream.transform(utf8.decoder).listen((value)
      {
      result = jsonDecode(value);
      print(value);
      print(result);

      status = result['status'];
      message = result['message'];
      if (status == 1) {
        print(message);
        makeToast(message);
      } else {
        print("fail");
        print(message);
        makeToast(message);
      }
    });
  }

  makeToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_checkInputHeight);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _checkInputHeight() async {
    int count = _textEditingController.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }

    if (count <= 5) {
      // use a maximum height of 6 rows
      // height values can be adapted based on the font size
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
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

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.orange,
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
        ),
        body: Container(
          child: Center(
            child: Form(
              key: _item,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    child: IconButton(
                      icon: _image == null
                          ? Icon(Icons.add_a_photo)
                          : Image.file(_image),
                      iconSize: 160.0,
                      color: Colors.orange,
                      onPressed: getImage,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 350,
                    height: 45,
                    child: OutlineButton(
                      highlightedBorderColor: Colors.orange,
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      highlightElevation: 0.0,
                      splashColor: Colors.orange,
                      highlightColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: TextFormField(
                        decoration: new InputDecoration(
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.orange),
                            hintText: "Item Name",
                            fillColor: Colors.white),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 15),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Enter Item Name";
                          }
                        },
                        onSaved: (e) {
                          i_name = e;
                        },
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 350,
                    //height: ,
                    child: OutlineButton(
                      highlightedBorderColor: Colors.orange,
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      highlightElevation: 0.0,
                      splashColor: Colors.orange,
                      highlightColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: TextFormField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: new InputDecoration(
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.orange),
                            hintText: "Item Description",
                            fillColor: Colors.white),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 15),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Enter Item Description";
                          }
                        },
                        onSaved: (e) {
                          desc = e;
                        },
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 350,
                    height: 45,
                    child: OutlineButton(
                      highlightedBorderColor: Colors.orange,
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                      highlightElevation: 0.0,
                      splashColor: Colors.orange,
                      highlightColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: TextFormField(
                        decoration: new InputDecoration(
                            filled: true,
                            hintStyle: new TextStyle(color: Colors.orange),
                            hintText: "Price",
                            fillColor: Colors.white),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 15),
                        keyboardType: TextInputType.number,
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Enter Item Price";
                          }
                        },
                        onSaved: (e) {
                          price = e;
                        },
                      ),
                      onPressed: () {},
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
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Text(
                            'Add Item',
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
            ),
          ),
        ));
  }
}
