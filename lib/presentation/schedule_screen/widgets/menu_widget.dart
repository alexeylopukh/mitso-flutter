import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen_presenter.dart';
import 'package:toast/toast.dart';

import '../../../app_theme.dart';

class MenuWidget extends StatefulWidget {
  UserScheduleInfo userScheduleInfo;
  PersonInfo personInfo;
  ScheduleScreenPresenter presenter;

  MenuWidget(
      {@required this.presenter, this.userScheduleInfo, this.personInfo});

  @override
  State<StatefulWidget> createState() {
    return MenuWidgetState();
  }
}

class MenuWidgetState extends State<MenuWidget> {
  UserScheduleInfo get userScheduleInfo => widget.userScheduleInfo;
  PersonInfo get personInfo => widget.personInfo;
  ScheduleScreenPresenter get presenter => widget.presenter;

  @override
  Widget build(BuildContext baseContext) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            ),
          ),
          personInfo == null
              ? FlatButton(
                  color: FONT_COLOR_1,
                  child: Text('Авторизоваться',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  onPressed: () => Navigator.pushNamed(context, '/auth'),
                  shape: StadiumBorder(),
                )
              : getUserInfo(),
          Align(
            alignment: Alignment.topLeft,
            child: Text('Выбрана группа: ${userScheduleInfo.group}',
                style: TextStyle(fontSize: 18)),
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              personInfo != null
                  ? FlatButton(
                      color: FONT_COLOR_1,
                      child: Text('Выйти из ЛК',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      onPressed: () => presenter.appScopeData
                          .setPersonInfo(null, auth: true),
                      shape: StadiumBorder(),
                    )
                  : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FlatButton(
                    color: FONT_COLOR_1,
                    child: Text('Сменить группу',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    onPressed: () {
                      presenter.appScopeData.setSchedule(null);
                      presenter.appScopeData.setUserScheduleInfo(null);
                    },
                    shape: StadiumBorder(),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getUserInfo() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff282C3A), Color(0xff1E212A)])),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'MITSO',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
                  Image.asset(
                    'assets/images/chip.png',
                    height: 50,
                    width: 50,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    'Баланс\n${personInfo.balance}',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Долг\n${personInfo.debt}',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    'Пеня\n${personInfo.fine}',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Text(
              '•••••   •••••   •••••   ${personInfo.login}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                  child: Container(
                      child: Text(
                    personInfo.name,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ))),
            )
          ],
        ),
      ),
    );
  }

  String getTextFromDate(DateTime dateTime) {
    final dif = dateTime.difference(DateTime.now()).inDays;
    if (dif == 0)
      return 'сегодня в ${DateFormat('HH:mm').format(dateTime)}';
    else if (dif == 1)
      return 'вчера в ${DateFormat('HH:mm').format(dateTime)}';
    else
      return DateFormat('dd.MM HH:mm').format(dateTime);
  }
}
