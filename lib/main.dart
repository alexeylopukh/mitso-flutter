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
import 'package:mitso/thems.dart';

void main() {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
        theme: Themes.light,
        darkTheme: Themes.dark);
  }

  initFirebase() {
    Crashlytics.instance.enableInDevMode = true;
    Crashlytics.instance.log('Start');
    FlutterError.onError = Crashlytics.instance.recordFlutterError;

    _firebaseMessaging.getToken().then((token) {});
  }
}
