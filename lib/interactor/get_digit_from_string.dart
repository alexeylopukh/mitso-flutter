import 'package:flutter/cupertino.dart';

class GetDigitFromString {
  final String text;

  GetDigitFromString({@required this.text});

  execute() {
    List<String> list = text.split('');
    try {
      int.parse(list[0] + list[1]);
      return int.parse(list[0] + list[1]);
    } catch (e) {
      return int.parse(
          list[0]); //ToDo: переписать для неограниченного кол-ва чисел
    }
  }
}
