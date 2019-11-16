import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mitso/main.dart';

class ThemePickerWidget extends StatefulWidget {
  @override
  _ThemePickerWidgetState createState() => _ThemePickerWidgetState();
}

class _ThemePickerWidgetState extends State<ThemePickerWidget> {
  int _currentIndex = 1;

  List<GroupModel> _group = [
    GroupModel(
      text: "Системная",
      index: 1,
    ),
    GroupModel(
      text: "Светлая",
      index: 2,
    ),
    GroupModel(
      text: "Темная",
      index: 3,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: _group
          .map((item) => RadioListTile(
                groupValue: _currentIndex,
                title: Text("${item.text}"),
                value: item.index,
                onChanged: (val) {
                  setState(() {
                    _currentIndex = val;
                    if (val == 2)
                      MediaQuery.platformBrightnessOf(context);
                    else if (val == 3) ThemeMode.dark;
                  });
                },
              ))
          .toList(),
    );
  }
}

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}
