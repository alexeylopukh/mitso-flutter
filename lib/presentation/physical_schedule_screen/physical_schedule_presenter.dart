import 'package:flutter/cupertino.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/physical_schedule_data.dart';
import 'package:mitso/interactor/parser.dart';

import 'physical_schedule_screen.dart';

class PhysicalSchedulePresenter {
  final PhysicalScheduleScreenState view;
  final AppScopeData appScopeData;

  PhysicalSchedulePresenter(
      {@required this.view, @required this.appScopeData}) {
    loadSchedule();
  }

  PhysicalScheduleStatus currentStatus = PhysicalScheduleStatus.Loading;

  List<PhysicalScheduleData> scheduleList;

  loadSchedule() async {
    currentStatus = PhysicalScheduleStatus.Loading;
    Parser().getPhysicalEducationSchedule().catchError((error) {
      currentStatus = PhysicalScheduleStatus.Error;
    }).then((result) {
      if (result == null || result.length == 0) {
        currentStatus = PhysicalScheduleStatus.Error;

        view.update();
      } else {
        scheduleList = result;
        currentStatus = PhysicalScheduleStatus.Loaded;
        view.update();
      }
    });
  }
}

enum PhysicalScheduleStatus { Loading, Loaded, Error }
