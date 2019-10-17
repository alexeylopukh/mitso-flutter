import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/network/parser.dart';
import 'package:mitso/presentation/schedule_screen/schedule_pages_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleScreenPresenter{
  ScheduleScreenState view;
  AppScopeData appScopeData;
  Parser parser;
  List<String> weekList;
  UserScheduleInfo _userScheduleInfo;

  Future<UserScheduleInfo> get userScheduleInfo async {
    if (_userScheduleInfo == null)
      _userScheduleInfo = await appScopeData.userScheduleInfo();
    return _userScheduleInfo;
  }


  ScheduleScreenPresenter(this.view, this.appScopeData, this.parser);

  onRefresh() {
    refreshSchedule();
  }

  refreshSchedule({int week = 0}) async {
    view.forceRefresh();
    try {
      loadWeeks().then((weeks) {
        weekList = weeks;
      });
      final userInfo = await appScopeData.userScheduleInfo();
      final days = await Parser()
          .getWeek(userInfo: userInfo,
          week: week);
      final newSchedule = Schedule(days: days);
//      final oldSchedule = await appScopeData.schedule();
      view.completeRefresh();
      if (newSchedule != null) {
        //ToDo: Добавить проврку действительно ли является новое расписание новым
        appScopeData.setSchedule(newSchedule).then((_) {
          view.update();
        });
      }
    } catch(error) {
      view.completeRefresh();
//      Toast.show("Не удалось обновить распсиание", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<List<String>> loadWeeks() async {
    final userInfo = await appScopeData.userScheduleInfo();
    final list = await Parser().getDateList(
        userInfo.form, userInfo.fak,
        userInfo.kurs, userInfo.group);
    return list;
  }

  createErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            elevation: 4,
            title: Text('Ошибка'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Не удалось получить данные.'),
                    Text('Рекомендуем посетить сайт и проверить расписание вручную.'),
                    Text('А также Ваше интернет-соединение.'),
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                child: Text('Посетить сайт'),
                onPressed: () {
                  _launchURL("https://www.mitso.by/schedule/search");
                },
              ),
              FlatButton(
                child: Text('Сменить группу'),
                onPressed: () {
                  AppScopeWidget.of(context).setUserScheduleInfo(null);
                },
              ),
              FlatButton(
                child: Text('Обновить'),
                onPressed: () {
                  view.update();
                },
              ),
            ],);
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Day>> loadSchedule() async {
    updateWeeks();
    final userInfo = await appScopeData.userScheduleInfo();
    final result = await parser.getWeek(userInfo: userInfo);
    return result;
  }

  updateWeeks() async {
    weekList = await loadWeeks();
  }

  String getShortNameOfDayWeek(String longName) {
    switch (longName.toLowerCase()) {
      case 'понедельник':
        return 'ПН';
        break;
      case 'вторник':
        return 'ВТ';
        break;
      case 'среда':
        return 'СР';
        break;
      case 'четверг':
        return 'ЧТ';
        break;
      case 'пятница':
        return 'ПТ';
        break;
      case 'суббота':
        return 'СБ';
        break;
      case 'воскресенье':
        return 'ВС';
        break;
      default:
        return '';
    }
  }

  int getDigitFromString(String text) {
    List<String> list = text.split('');
    try {
      int.parse(list[0] + list[1]);
      return int.parse(list[0] + list[1]);
    } catch (e) {
      return int.parse(list[0]); //ToDo: переписать для неограниченного кол-ва чисел
    }
  }
}