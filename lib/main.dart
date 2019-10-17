import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/presentation/auth_screen/auth_screen.dart';
import 'package:mitso/presentation/schedule_screen/schedule_pages_screen.dart';
import 'package:mitso/presentation/select_group_screen/select_group_screen.dart';

import 'app_theme.dart';
import 'data/schedule_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AppScopeWidget(
      child: Builder(builder: (context) {
        return FutureBuilder(
          future: AppScopeWidget.of(context).userScheduleInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container();
            if (snapshot.hasData)
              return createMaterialApp(ScheduleScreen());
            if (snapshot.data == null)
              return createMaterialApp(SelectGroupScreen());
            return Container();
        });
      }),
    );
  }

  static Widget createMaterialApp(Widget home) {
    return MaterialApp(
      title: 'МИТСО',
      routes: {
        '/auth' : (BuildContext context) => AuthScreen()
        },
      home: home,
    );
  }

}
