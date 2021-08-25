import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

//part 'item.g.dart';

@JsonSerializable()
class Item {
  final String i_id;
  final String i_name;
  final String i_desc;
  final String i_image;
  final int i_price;

  Item({
    this.i_id,
    this.i_name,
    this.i_desc,
    this.i_image,
    this.i_price
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item(
        i_id: json['items']['0']['I_id'],
        i_name: json['items']['0']['I_name'],
        i_desc: json['items']['0']['I_desc'],
        i_image: json['items']['0']['I_image'],
        i_price: int.parse(json['items']['0']['I_price'])
    );
  }
}