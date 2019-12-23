import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/notification_manager.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/interactor/get_digit_from_string.dart';
import 'package:mitso/interactor/parser.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen.dart';
import 'package:mitso/presentation/update_message_screen/update_message_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleScreenPresenter {
  final ScheduleScreenWidgetState view;
  final AppScopeData appScopeData;
  Parser parser;
  List<String> weekList;
  UserScheduleInfo _userScheduleInfo;
  Schedule schedule;
  ScheduleStatus scheduleStatus = ScheduleStatus.LoadFromStorage;

  int currentWeek = 0;

  bool isAdShowed;

  Future<UserScheduleInfo> get userScheduleInfo async {
    return _userScheduleInfo = await appScopeData.userScheduleInfo();
  }

  ScheduleScreenPresenter(this.view, this.appScopeData, this.parser) {
    appScopeData.schedule().then((schedule) {
      if (schedule != null) {
        this.schedule = schedule;
        scheduleStatus = ScheduleStatus.Loaded;
        view.update();
      } else
        loadSchedule();
    });

    isAdShowed = false;
    appScopeData.adManager.isMainBannerShowedStream.stream.listen((isShowed) {
      isAdShowed = isShowed;
      view.update();
    });
    appScopeData.remoteConfig.then((remoteConfig) {
      appScopeData.adManager.showMainBanner(remoteConfig);
    });

    parser.getPhysicalEducationSchedule();
  }

  refreshSchedule() async {
    loadWeeks();
    updPerson();
    final userInfo = await appScopeData.userScheduleInfo();
    final newSchedule = await Parser()
        .getSchedule(userInfo: userInfo, week: currentWeek)
        .catchError((error) => goToCurrentDay());
    view.completeRefresh();
    final isNew = schedule.toMap() != newSchedule.toMap();
    if (newSchedule != null) {
      schedule = newSchedule;
      if (currentWeek == 0) appScopeData.setSchedule(newSchedule);
      view.update();
      view.pageController.animateToPage(0,
          duration: Duration(milliseconds: 1000), curve: Curves.ease);
      goToCurrentDay();
    }
  }

  loadWeeks() async {
    final userScheduleInfo = await appScopeData.userScheduleInfo();
    var list = await parser
        .getWeekList(
            form: userScheduleInfo.form,
            fak: userScheduleInfo.fak,
            kurs: userScheduleInfo.kurs,
            group: userScheduleInfo.group)
        .catchError((error) => print(error));
    weekList = list;
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
                Text(
                    'Рекомендуем посетить сайт и проверить расписание вручную.'),
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
            ],
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  loadSchedule() async {
    loadWeeks();
    updPerson();
    scheduleStatus = ScheduleStatus.FirstLoad;
    view.update();
    final userInfo = await appScopeData.userScheduleInfo();
    final result = await parser.getSchedule(userInfo: userInfo);
    if (result != null) {
      schedule = result;
      scheduleStatus = ScheduleStatus.Loaded;
      appScopeData.setSchedule(schedule);
      view.update();
    } else {
      scheduleStatus = ScheduleStatus.Empty;
      view.update();
    }
  }

  updPerson() async {
    final oldPersonInfo = await appScopeData.personInfo();
    if (oldPersonInfo == null) return;
    final newPersonInfo =
        await Parser().getPerson(oldPersonInfo.login, oldPersonInfo.login);
    if (newPersonInfo != null) {
      appScopeData.setPersonInfo(newPersonInfo, auth: false);
      final diff =
          newPersonInfo.lastUpdate.difference(oldPersonInfo.lastUpdate).inHours;
      if (oldPersonInfo != newPersonInfo || diff > 17) if (newPersonInfo.debt >
          0.0) showDebtNotification(newPersonInfo.debt);
    }
  }

  bool goToCurrentDay() {
    if (view.pageController.hasClients &&
        schedule != null &&
        schedule.days != null &&
        schedule.days.length != 0) {
      for (int i = 0; i < schedule.days.length; i++) {
        if (GetDigitFromString(text: schedule.days[i].data).execute() ==
            DateTime.now().day)
          view.pageController.animateToPage(i,
              duration: Duration(milliseconds: 1000), curve: Curves.ease);
      }
    } else
      return false;
    return true;
  }

  checkAppVersion(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final config = await appScopeData.remoteConfig;
    if (config.actualVersion != packageInfo.version) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateMessageScreen()),
      );
    }
  }

  showDebtNotification(double debt) {
    NotificationManager().sendNotification(
        'Задолженность', 'У ваc образовалась задоженность $debt р.');
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
}

enum ScheduleStatus { LoadFromStorage, FirstLoad, Empty, Loaded }
