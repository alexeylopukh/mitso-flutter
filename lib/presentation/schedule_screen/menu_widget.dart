import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen_presenter.dart';

import '../../app_theme.dart';

class MenuWidget extends StatefulWidget {

  UserScheduleInfo userScheduleInfo;
  PersonInfo personInfo;
  ScheduleScreenPresenter presenter;

  MenuWidget({@required this.presenter, this.userScheduleInfo, this.personInfo});

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
    return Column(
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
        Text(userScheduleInfo.group, style: TextStyle(fontSize: 22)),
        personInfo == null
        ? Container()
        : getUserInfo(),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            personInfo != null
                ? FlatButton(
              color: FONT_COLOR_1,
              child: Text('Выйти из ЛК',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: () =>
                  presenter.appScopeData.setPersonInfo(null, auth: true),
              shape: StadiumBorder(),)
                : FlatButton(
              color: FONT_COLOR_1,
              child: Text('Авторизоваться',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: () => Navigator.pushNamed(context, '/auth'),
              shape: StadiumBorder(),),
            FlatButton(
              color: FONT_COLOR_1,
              child: Text('Сменить группу',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: () {
                presenter.appScopeData.setSchedule(null);
                presenter.appScopeData.setUserScheduleInfo(null);
              },
              shape: StadiumBorder(),)
          ],
        )
      ],
    );
  }

  Widget getUserInfo() {
    return Column(
      children: <Widget>[
        Text(personInfo.name),
        Text('Баланс: ${personInfo.balance}')
      ],
    );
  }
}
