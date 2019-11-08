import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:mitso/ad_manager.dart';
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/remote_config_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/firebase_analytics_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScopeData {
  AppScopeWidgetState state;

  FirebaseAnalyticsHelper _analyticsHelper;

  AdManager _adManager;

  AdManager get adManager => _adManager;

  FirebaseAnalyticsHelper get analyticsHelper => _analyticsHelper;

  RemoteConfigData _remoteConfig;

  AppScopeData({@required this.state}) {
    _loadRemoteConfig();
    _analyticsHelper = FirebaseAnalyticsHelper();
    _adManager = AdManager();
  }

  _loadRemoteConfig() async {
    _remoteConfig = await RemoteConfigData.setupRemoteConfig();
  }

  Future<RemoteConfigData> get remoteConfig async {
    if (_remoteConfig == null)
      _remoteConfig = await RemoteConfigData.setupRemoteConfig();
    return _remoteConfig;
  }

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
      final scheduleData = UserScheduleInfo.fromMap(prefData);
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
      final schedule = Schedule.fromMap(json.decode(prefSchedule));
      return schedule;
    } catch (error) {
      return null;
    }
  }

  Future<PersonInfo> personInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final prefPersonInfo = prefs.getString('personInfo');
      final personInfo = PersonInfo.fromMap(json.decode(prefPersonInfo));
      return personInfo;
    } catch (error) {
      return null;
    }
  }

  Future setPersonInfo(PersonInfo personInfo, {bool auth = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (personInfo == null)
      return prefs.remove('personInfo').then((_) {
        state.setState(() => {});
      });
    else
      prefs.setString('personInfo', json.encode(personInfo.toMap())).then((_) {
        if (auth) state.setState(() => {});
      });
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
