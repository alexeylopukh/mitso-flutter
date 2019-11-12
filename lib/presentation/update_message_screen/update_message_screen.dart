import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mitso/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateMessageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateMessageScreenState();
  }
}

class _UpdateMessageScreenState extends State<UpdateMessageScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MAIN_COLOR_2,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MAIN_COLOR_2,
        systemNavigationBarIconBrightness: Brightness.light));
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: MAIN_COLOR_2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Ваша версия приложения устралера\nДля корректной работы, пожалуйста, обновите.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              OutlineButton(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  shape: StadiumBorder(),
                  child: Text('Обновить',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  onPressed: () {
                    _launchURL(
                        'https://play.google.com/store/apps/details?id=com.schedule.mitso');
                  })
            ],
          ),
        ),
      ),
    ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).backgroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    super.dispose();
  }
}
