import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScopeData {
  AppScopeWidgetState state;

  AppScopeData({@required this.state});

  Future setUserScheduleInfo(UserScheduleInfo userScheduleInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userScheduleInfo == null)
      return prefs.remove('scheduleData').then((_) {
        state.setState(() => {});
      });
    else {
      final map = userScheduleInfo.toMap();
      final String json = jsonEncode(map);
      return prefs.setString('scheduleData', json).then((_) {
        state.setState(() => {});
      });
    }
  }

  Future<UserScheduleInfo> userScheduleInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final prefData = jsonDecode(prefs.getString('scheduleData'));
      final UserScheduleInfo scheduleData = UserScheduleInfo.fromMap(prefData);
      return scheduleData;
    } catch (error) {
      return null;
    }
  }

  Future setSchedule(Schedule schedule) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (schedule == null)
      return prefs.remove('schedule');
    else
      return prefs.setString('schedule', json.encode(schedule.toMap()));
  }

  Future<Schedule> schedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final prefSchedule = prefs.getString('schedule');
      final Schedule schedule = Schedule.fromMap(json.decode(prefSchedule));
      return schedule;
    } catch (error) {
      return null;
    }
  }
}

class _AppScopeWidget extends InheritedWidget {
  AppScopeWidgetState state;
  AppScopeData data;

  _AppScopeWidget({Key key, @required Widget child, @required this.state})
      : super(key: key, child: child) {
    data = AppScopeData(state: state);
  }

  @override
  bool updateShouldNotify(InheritedWidget old) => true;
}

class AppScopeWidget extends StatefulWidget {
  Widget child;

  AppScopeWidget({Key key, @required this.child}) : super(key: key);

  static AppScopeData of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_AppScopeWidget)
    as _AppScopeWidget)
        .data;
  }

  @override
  State<StatefulWidget> createState() {
    return AppScopeWidgetState(key: key, child: child);
  }
}

class AppScopeWidgetState extends State<AppScopeWidget> {
  Key key;
  Widget child;

  AppScopeWidgetState({this.key, this.child});

  @override
  Widget build(BuildContext context) {
    return _AppScopeWidget(
      key: key,
      child: child,
      state: this,
    );
  }
}