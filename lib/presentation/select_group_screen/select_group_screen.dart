import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/presentation/select_group_screen/dropdowns_pickers_widget.dart';
import '../../app_theme.dart';

const BUTTON_TEXT = 'Найти расписание';
const TITLE_TEXT = 'Выбери свою группу:';

class SelectGroupScreen extends StatelessWidget {
  PersistentBottomSheetController _controller;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MAIN_COLOR_2,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MAIN_COLOR_2,
        systemNavigationBarIconBrightness: Brightness.light));
    final dropDownKey = new GlobalKey<DropDownsPickersState>();
    return Scaffold(
        key: _key,
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(color: MAIN_COLOR_2),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 40),
                  child: Text(
                    TITLE_TEXT,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DropDownsPickers(key: dropDownKey)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
                elevation: 4.0,
                backgroundColor: Colors.white,
                icon: const Icon(Icons.done, color: MAIN_COLOR_2),
                label: const Text(BUTTON_TEXT,
                    style: TextStyle(color: MAIN_COLOR_2)),
                onPressed: () {
                  final form = dropDownKey.currentState.widget.form;
                  final fak = dropDownKey.currentState.widget.fakulty;
                  final kurs = dropDownKey.currentState.widget.cours;
                  final group = dropDownKey.currentState.widget.group;

                  if (form == null ||
                      fak == null ||
                      kurs == null ||
                      group == null) {
                    _controller = _key.currentState.showBottomSheet(
                        (_) => SizedBox(
                              child: Container(
                                  decoration:
                                      BoxDecoration(color: MAIN_COLOR_1),
                                  child: Center(
                                      child: Text('Заполните все данные',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-bold',
                                              color: MAIN_COLOR_2,
                                              fontSize: 18)))),
                              width: double.maxFinite,
                              height: 100,
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ));
                    return;
                  }
                  AppScopeWidget.of(context).setUserScheduleInfo(
                      UserScheduleInfo(
                          form: form, fak: fak, kurs: kurs, group: group));
                })));
  }
}
