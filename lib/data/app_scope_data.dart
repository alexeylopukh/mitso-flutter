import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mitso/ad_manager.dart';
import 'package:mitso/data/app_settings.dart';
import 'package:mitso/data/person_info_data.dart';
import 'package:mitso/data/remote_config_data.dart';
import 'package:mitso/data/schedule_data.dart';
import 'package:mitso/firebase_analytics_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScopeData {
  AppScopeWidgetState state;

  AppSettings appSettings = AppSettings();

  FirebaseAnalyticsHelper _analyticsHelper;

  AdManager _adManager;

  AdManager get adManager => _adManager;

  FirebaseAnalyticsHelper get analyticsHelper => _analyticsHelper;

  RemoteConfigData _remoteConfig;

  AppScopeData({@required this.state}) {
    loadAppSettings();
    _loadRemoteConfig();
    _analyticsHelper = FirebaseAnalyticsHelper();
    _adManager = AdManager();
  }

  Future loadAppSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final json = jsonDecode(prefs.getString('app_settings'));
      appSettings = AppSettings.fromJson(json);
    } catch (error) {}
  }

  Future saveAppSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setString('app_settings', jsonEncode(appSettings.toJson()));
    } catch (error) {}
  }

  _loadRemoteConfig() async {
    _remoteConfig = await RemoteConfigData.setupRemoteConfig();
  }

  Future<RemoteConfigData> get remoteConfig async {
    if (_remoteConfig == null) _remoteConfig = await RemoteConfigData.setupRemoteConfig();
    return _remoteConfig;
  }

  Future setUserScheduleInfo(UserScheduleInfo userScheduleInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userScheduleInfo == null)
      return prefs.remove('scheduleData').then((_) {
        state.rebuild();
      });
    else {
      final map = userScheduleInfo.toMap();
      final String json = jsonEncode(map);
      return prefs.setString('scheduleData', json).then((_) {
        state.rebuild();
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
        state.rebuild();
      });
    else
      prefs.setString('personInfo', json.encode(personInfo.toMap())).then((_) {
        if (auth) state.rebuild();
      });
  }
}

class _AppScopeWidget extends InheritedWidget {
  final AppScopeWidgetState state;
  final AppScopeData data;

  _AppScopeWidget._(Key key, Widget child, this.state, this.data) : super(key: key, child: child) {
    // data = AppScopeData(state: state);
  }

  factory _AppScopeWidget({Key key, @required Widget child, @required AppScopeWidgetState state}) {
    return _AppScopeWidget._(key, child, state, AppScopeData(state: state));
  }

  @override
  bool updateShouldNotify(InheritedWidget old) => true;
}

class AppScopeWidget extends StatefulWidget {
  final Widget child;

  AppScopeWidget({Key key, @required this.child}) : super(key: key);

  static AppScopeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppScopeWidget>().data;
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

  rebuild() {
    if (mounted) setState(() {});
  }
}
