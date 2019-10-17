import 'package:flutter/material.dart';
import 'package:mitso/app_theme.dart';
import 'package:mitso/network/parser.dart';

const FAK_HINT = 'Факультет';
const FORM_HINT = 'Форма обучения';
const KURS_HINT = 'Курс';
const GROUP_HINT = 'Группа';

class DropDownsPickers extends StatefulWidget {
  String fakulty;
  String form;
  String cours;
  String group;
  Parser parser = Parser();

  DropDownsPickers({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DropDownsPickersState();
  }
}

class DropDownsPickersState extends State<DropDownsPickers> {
  final decoration = ShapeDecoration(
    color: MAIN_COLOR_2,
    shape: RoundedRectangleBorder(
      side:
          BorderSide(width: 2.0, style: BorderStyle.solid, color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  );

  final textPadding = const EdgeInsets.only(left: 5);
  final pickerPadding = const EdgeInsets.only(top: 10);
  final textStyle = const TextStyle(color: Colors.white);
  final hintStyle = const TextStyle(color: FONT_COLOR_HINT, fontSize: 18);
  final menuItemStyle = const TextStyle(color: Colors.white, fontSize: 18);
  final icon = const Icon(Icons.arrow_drop_down, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(canvasColor: MAIN_COLOR_2, accentColor: Colors.white),
      child: Padding(
        padding: EdgeInsets.only(left: 40, right: 40, top: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: widget.parser.getFakList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  if (snapshot.data == null) return Text('No data');
                  return Container(
                    width: double.infinity,
                    decoration: decoration,
                    padding: textPadding,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          style: textStyle,
                          icon: icon,
                          value: widget.fakulty == null ? null : widget.fakulty,
                          hint: Center(child: Text(FAK_HINT, style: hintStyle),),
                          onChanged: (String value) {
                            setState(() {
                              widget.fakulty = value;
                              widget.form = null;
                              widget.cours = null;
                              widget.group = null;
                            });
                          },
                          items: snapshot.data
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: menuItemStyle),
                            );
                          }).toList()),
                    ),
                  );
                },
              ),
              Padding(
                padding: pickerPadding,
                child: widget.fakulty == null
                    ? Container()
                    : FutureBuilder(
                        future: widget.parser.getFormList(widget.fakulty),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          if (snapshot.data == null) return Text('No data');
                          return Container(
                            decoration: decoration,
                            width: double.infinity,
                            padding: textPadding,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  style: textStyle,
                                  icon: icon,
                                  value:
                                      widget.form == null ? null : widget.form,
                                  hint: Center(child: Text(FORM_HINT, style: hintStyle)),
                                  onChanged: (String value) {
                                    setState(() {
                                      widget.form = value;
                                      widget.cours = null;
                                      widget.group = null;
                                    });
                                  },
                                  items: snapshot.data
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child:
                                            Text(value, style: menuItemStyle));
                                  }).toList()),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: pickerPadding,
                child: widget.form == null
                    ? Container()
                    : FutureBuilder(
                        future: widget.parser
                            .getKursList(widget.form, widget.fakulty),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          if (snapshot.data == null) return Text('No data');
                          return Container(
                            decoration: decoration,
                            width: double.infinity,
                            padding: textPadding,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  style: textStyle,
                                  icon: icon,
                                  value: widget.cours == null
                                      ? null
                                      : widget.cours,
                                  hint: Center(child: Text(KURS_HINT, style: hintStyle)),
                                  onChanged: (String value) {
                                    setState(() {
                                      widget.cours = value;
                                      widget.group = null;
                                    });
                                  },
                                  items: snapshot.data
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: menuItemStyle,
                                      ),
                                    );
                                  }).toList()),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: pickerPadding,
                child: widget.cours == null
                    ? Container()
                    : FutureBuilder(
                        future: widget.parser.getGroupList(
                            widget.form, widget.fakulty, widget.cours),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<String>> snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          if (snapshot.data == null) return Text('No data');
                          return Container(
                            decoration: decoration,
                            width: double.infinity,
                            padding: textPadding,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  style: textStyle,
                                  icon: icon,
                                  value: widget.group == null
                                      ? null
                                      : widget.group,
                                  hint: Center(child: Text(
                                    GROUP_HINT,
                                    style: hintStyle,
                                  )),
                                  onChanged: (String value) {
                                    setState(() {
                                      widget.group = value;
                                    });
                                  },
                                  items: snapshot.data
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: menuItemStyle),
                                    );
                                  }).toList()),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
