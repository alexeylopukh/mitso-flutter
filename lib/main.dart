import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/data/notification_manager.dart';
import 'package:mitso/presentation/auth_screen/auth_screen.dart';
import 'package:mitso/presentation/schedule_screen/schedule_screen.dart';
import 'package:mitso/presentation/select_group_screen/select_group_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'app_theme.dart';

void main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    initFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    runZoned<Future<void>>(() async {},
        onError: Crashlytics.instance.recordError);

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      NotificationManager().sendNotification(
          message['notification']['title'], message['notification']['body']);
    });

    return AppScopeWidget(
      child: Builder(builder: (context) {
        return FutureBuilder(
            future: AppScopeWidget.of(context).userScheduleInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              if (snapshot.hasData)
                return createMaterialApp(ScheduleScreenWidget());
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
      routes: {'/auth': (BuildContext context) => AuthScreen()},
      home: home,
      theme: ThemeData(
          brightness: Brightness.light,
          buttonColor: Color(0xff4373F3),
          backgroundColor: Color(0xffF1F5FF),
          accentTextTheme: TextTheme(
              title: TextStyle(
                  fontFamily: 'Montserrat-bold',
                  color: Color(0xff515F79),
                  fontSize: 16),
              body1: TextStyle(
                  fontFamily: 'Montserrat-Light',
                  color: Color(0xff515F79),
                  fontSize: 13))),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        bottomAppBarColor: Color(0xff282C3A),
        buttonColor: Color(0xff28629C),
        backgroundColor: Color(0xff1E212A),
        cardColor: Color(0xff333742),
        accentTextTheme: TextTheme(
            title: TextStyle(
                fontFamily: 'Montserrat-bold',
                color: Color(0xffAEADB0),
                fontSize: 16),
            body1: TextStyle(
                fontFamily: 'Montserrat-Light',
                color: Color(0xffAEADB0),
                fontSize: 13)),
      ),
    );
  }

  initFirebase() {
    Crashlytics.instance.enableInDevMode = true;
    Crashlytics.instance.log('Start');
    FlutterError.onError = Crashlytics.instance.recordFlutterError;

    _firebaseMessaging.getToken().then((token) {});
  }
}
