import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class Edit_item_screen extends StatefulWidget {
  @override
  _Edit_item_screenState createState() => _Edit_item_screenState();
}

class _Edit_item_screenState extends State<Edit_item_screen> {
  //Key _ddmenu = new Key;
  String ddvalue;
  final _Eitem = new GlobalKey<FormState>();

  List<String> getvalues;
  String id, desc, price,i_name;
  File _image;

  @override
  void initState() {
    super.initState();
    get_item();
  }

  Map data;
  List itemsList;

  Future get_item() async {
    getvalues = new List();
    itemsList = new List();
    final response = await http
        .post("http://192.168.0.106:81/Login/get_items.php", body: {});
    data = jsonDecode(response.body);//.cast<Map<dynamic, dynamic>>();
    print(data['items']);
    itemsList = data['items'];
    var i;
    for(i=0;i<itemsList.length;i++)
      {
        getvalues.add(itemsList[i]['I_name']);
      }
  print(getvalues);
    print(itemsList);
    setState(() {
    });
  }

//  get_item() async {
//    getvalues = new List<String>();
//    final response = await http
//        .post("http://192.168.0.106:81/Login/get_items.php", body: {});
//
//    final data = jsonDecode(response.body).cast<Map<String, dynamic>>();
//    print(data);
//    data.map((json) {
//      getvalues.add(json['items'][0]['I_name']);
//    }).toList();
//    setState(() {
//    });
//
//    print(getvalues);
//  }

  void check() {
    final form = _Eitem.currentState;
    if (form.validate()) {
      form.save();
      add_item();
    }
  }

  add_item() async {
    var stream = new http.ByteStream(_image.openRead());
    var length = await _image.length();
    var url = Uri.parse("http://192.168.0.106:81/Login/edit_item.php");
    var file = new http.MultipartFile("image", stream, length,
        filename: basename(_image.path));

    final req = await http.MultipartRequest("POST", url);
    //req.fields["id"] = id;
    req.fields["i_name"] = ddvalue;
    req.fields["desc"] = desc;
    req.files.add(file);
    req.fields["price"] = price;

    var result, status, message;
    final response = await req.send();
    response.stream.transform(utf8.decoder).listen((value) {
      result = jsonDecode(value);
      print(value);

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
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            'Edit Item',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
              },onSelected: (int){

            },
            ),
          ],
        ),
        body: Container(
            child: Center(
                child: Form(
                    key: _Eitem,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        DropdownButton<String>(
                          //key: _ddmenu,
                          value: ddvalue,
                          items: getvalues
                              .map((value) => DropdownMenuItem<String>(
                                    child: new Text(value),
                                    value: value,
                                  ))
                              .toList(),
                          onChanged: (String value) {
                            setState(() {
                              ddvalue = value;
                            });
                          },
                          isExpanded: false,
                          hint: ddvalue == null
                              ? Text(
                                  'Select Item Name',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 25),
                                )
                              : Text(ddvalue,
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 25)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          child: IconButton(
                            icon: _image == null
                                ? Icon(Icons.add_a_photo)
                                : Image.file(_image),
                            iconSize: 130.0,
                            color: Colors.orange,
                            onPressed: getImage,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: 350,
                          //height: 50,
                          child: OutlineButton(
                            highlightedBorderColor: Colors.orange,
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2.0),
                            highlightElevation: 0.0,
                            splashColor: Colors.orange,
                            highlightColor: Theme.of(context).primaryColor,
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            child: TextFormField(
                              //controller: _textEditingController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: new InputDecoration(
                                  //filled: true,
                                  hintStyle:
                                      new TextStyle(color: Colors.orange),
                                  hintText: "Item Description",
                                  fillColor: Colors.white),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 15),
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter Item Description";
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
                            borderSide:
                                BorderSide(color: Colors.orange, width: 2.0),
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
                                  hintStyle:
                                      new TextStyle(color: Colors.orange),
                                  hintText: "Price",

                                  fillColor: Colors.white),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 15),
                              keyboardType: TextInputType.number,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Please Enter Price";
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
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                child: Text(
                                  'Edit Item',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                onPressed: () {
                                  check();
                                })),
                      ],
                    )))));
  }
}
