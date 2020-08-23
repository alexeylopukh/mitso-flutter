import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/presentation/auth_screen/auth_screen.dart';
import 'package:mitso/presentation/physical_schedule_screen/physical_schedule_screen.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen_presenter.dart';
import 'package:mitso/presentation/settings_screen/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuWidget extends StatefulWidget {
  final UserScheduleInfo userScheduleInfo;
  final PersonInfo personInfo;
  final ScheduleScreenPresenter presenter;

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
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              height: 4,
              width: 60,
              decoration:
                  BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            ),
          ),
          personInfo == null
              ? RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AuthScreen())),
                  padding: const EdgeInsets.all(0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: Theme.of(context).brightness == Brightness.dark
                                ? [Color(0xff1E212A), Color(0xff1E212A)]
                                : [Color(0xff4373F3), Color(0xff3E6AE3)]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Войти в личный кабинет',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ),
                  ),
                )
              : getUserCard(),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhysicalScheduleScreen()),
            ),
            padding: const EdgeInsets.all(0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [Color(0xff1E212A), Color(0xff1E212A)]
                          : [Color(0xff4373F3), Color(0xff3E6AE3)]),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Расписание по физкультуре',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              ),
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () => _launchURL('https://t.me/AlexeyL13'),
            padding: const EdgeInsets.all(0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [Color(0xff1E212A), Color(0xff1E212A)]
                          : [Color(0xff4373F3), Color(0xff3E6AE3)]),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Связаться с разработчиком',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  presenter.appScopeData.setSchedule(null);
                  presenter.appScopeData.setUserScheduleInfo(null);
                },
                padding: const EdgeInsets.all(0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: Theme.of(context).brightness == Brightness.dark
                              ? [Color(0xff1E212A), Color(0xff1E212A)]
                              : [Color(0xff4373F3), Color(0xff3E6AE3)]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                          child: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                        ),
                        Text(userScheduleInfo.group + ' ',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SettingsScreen())),
                padding: const EdgeInsets.all(0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: Theme.of(context).brightness == Brightness.dark
                              ? [Color(0xff1E212A), Color(0xff1E212A)]
                              : [Color(0xff4373F3), Color(0xff3E6AE3)]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                        Text('Настройки',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget getUserCard() {
    return Column(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [Color(0xff282C3A), Color(0xff1E212A)]
                          : [Color(0xff4373F3), Color(0xff3E6AE3)])),
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
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '••••• ',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      Text(
                        '••••• ',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      Text(
                        '••••• ',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      Text(
                        personInfo.login,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Container(
                            child: Text(
                          personInfo.name,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ))),
                  ),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            personInfo.info,
            textAlign: TextAlign.center,
          ),
        )
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
