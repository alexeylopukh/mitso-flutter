import 'dart:convert';

import 'package:flutter/material.dart';

PersonInfo personInfoFromJson(String str) => PersonInfo.fromMap(json.decode(str));

String personInfoToJson(PersonInfo data) => json.encode(data.toMap());

class PersonInfo {
  String name;
  String info;
  double balance;
  double debt;
  double fine;

  PersonInfo({
    @required this.name,
    @required this.info,
    @required this.balance,
    @required this.debt,
    @required this.fine,
  });

  factory PersonInfo.fromMap(Map<String, dynamic> json) => PersonInfo(
    name: json["name"],
    info: json["info"],
    balance: json["balance"].toDouble(),
    debt: json["debt"].toDouble(),
    fine: json["fine"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "info": info,
    "balance": balance,
    "debt": debt,
    "fine": fine,
  };
}
