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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              personInfo.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Баланс:\n${personInfo.balance}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: FONT_COLOR_1,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Долг:\n${personInfo.debt}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: FONT_COLOR_1,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )),
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        'Пеня:\n${personInfo.fine}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: FONT_COLOR_1,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child:
              Text('Баланс обновлен ${getTextFromDate(personInfo.lastUpdate)}'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Text(
                'Лицевой счет: ' + personInfo.login,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.start,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.content_copy,
                              size: 15,
                            ),
                            Text('Копировать')
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: personInfo.login));
                      Toast.show('Скопировано в буфер обмена', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    },
                  )),
            ],
          ),
        ),
      ],
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
