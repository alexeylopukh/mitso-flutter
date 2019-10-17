import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/presentation/schedule_screen/schedule_pages_screen.dart';
import 'package:mitso/presentation/select_group_screen/select_group_screen.dart';

import 'app_theme.dart';
import 'data/schedule_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'МИТСО - Рассписание',
        home: Container(
          color: BACK_COLOR,
          child: AppScopeWidget(child: Builder(builder: (context) {
            return FutureBuilder(
                future: AppScopeWidget.of(context).userScheduleInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  if (snapshot.hasData)
                      return ScheduleScreen();
                  if (snapshot.data == null)
                    return SelectGroupScreen();
                  return Container();
                },
              );
          })),
        ));
  }
}
