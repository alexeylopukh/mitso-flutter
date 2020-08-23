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
  String login;
  DateTime lastUpdate;

  PersonInfo(
      {@required this.name,
      @required this.info,
      @required this.balance,
      @required this.debt,
      @required this.fine,
      @required this.login,
      @required this.lastUpdate});

  factory PersonInfo.fromMap(Map<String, dynamic> json) => PersonInfo(
      name: json["name"],
      info: json["info"],
      balance: json["balance"].toDouble(),
      debt: json["debt"].toDouble(),
      fine: json["fine"].toDouble(),
      login: json["login"],
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(json["lastUpdate"]));

  Map<String, dynamic> toMap() => {
        "name": name,
        "info": info,
        "balance": balance,
        "debt": debt,
        "fine": fine,
        "login": login,
        "lastUpdate": lastUpdate.millisecondsSinceEpoch
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          info == other.info &&
          balance == other.balance &&
          debt == other.debt &&
          fine == other.fine &&
          login == other.login;

  @override
  int get hashCode =>
      name.hashCode ^
      info.hashCode ^
      balance.hashCode ^
      debt.hashCode ^
      fine.hashCode ^
      login.hashCode;
}
