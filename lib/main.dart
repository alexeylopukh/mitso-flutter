import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/presentation/schedule_pages_screen.dart';
import 'package:mitso/presentation/select_group_screen/select_group_screen.dart';

import 'app_theme.dart';
import 'data/schedule_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mitso Schedule',
        home: Container(
          color: BACK_COLOR,
          child: AppScopeWidget(child: Builder(builder: (context) {
            return FutureBuilder(
                future: AppScopeWidget.of(context).userScheduleInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null) return SelectGroupScreen();
                  return SchedulePagesScreen();
                },
              );
          })),
        ));
  }
}
