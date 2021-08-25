import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Delete_itemState pageState;

class Delete_item extends StatefulWidget {
  @override
  Delete_itemState createState() {
    pageState = Delete_itemState();
    theme:
    ThemeData(
      primaryColor: Colors.orange,
      dividerColor: Colors.grey,
    );
    return pageState;
  }
}

class Delete_itemState extends State<Delete_item> {
  List<String> items;
//  List<String>.generate(7, (index) {
//    return "Item - $index";
//  }
//  );

  final teController = TextEditingController(
    text: "good",
  );

  get_item() async {
    items = new List<String>();
    final response = await http
        .get("http://192.168.0.106:81/Login/get_items.php");

    final data = jsonDecode(response.body).cast<Map<String, dynamic>>();
    print(data);
    data.map((json) {
      items.add(json['I_name']);
    }).toList();

    setState(() {
    });

    print(items);
  }

  delete(curr_item) async {
    final response = await http
        .post("http://192.168.0.106:81/Login/delete_item.php", body: {
          "i_name": curr_item
    });
    var status, message;
    final result = jsonDecode(response.body);
    print(result);
    status = result['status'];
    message = result['message'];
    if (status == 1) {
      print(message);
      makeToast(message);
      setState(() {
        get_item();
      });
    } else {
      print("fail");
      print(message);
      makeToast(message);
    }
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
  @override
  void dispose() {
    teController.dispose();
    super.dispose();
  }

  @override
  void initState()
  {
    super.initState();
    get_item();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Delete item',
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
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 5,
                  alignment: Alignment(0, 0),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item),
                      direction: DismissDirection.startToEnd,
                      child: ListTile(
                        title: Text(
                          item,
                          style: TextStyle(fontSize: 30, color: Colors.orange),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.orange,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              print(items.elementAt(index));
                              var curr_item = items.elementAt(index);
                              delete(curr_item);
                            });
                          },
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          print(items.elementAt(index));
                          var curr_item = items.elementAt(index);
                          delete(curr_item);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}