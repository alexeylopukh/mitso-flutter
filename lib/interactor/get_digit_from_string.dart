import 'package:flutter/cupertino.dart';

class GetDigitFromString {
  final String text;

  GetDigitFromString({@required this.text});

  int execute() {
    List<String> list = text.split('');
    try {
      final result = int.parse(list[0] + list[1]);
      return result;
    } catch (e) {
      return int.parse(
          list[0]); //ToDo: переписать для неограниченного кол-ва чисел
    }
  }
}
