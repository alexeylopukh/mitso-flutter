import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mitso/data/app_scope_data.dart';
import 'package:mitso/presentation/components/navigation_bar.dart';
import 'package:mitso/presentation/components/scaffold.dart';
import 'package:vibration/vibration.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appScope = AppScopeWidget.of(context);
    return GeneralScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        flexibleSpace: NavigationBar(
          showButtonTitle: false,
          onTap: () => backPressed(),
          child: Text(
            'Настройки',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            MergeSemantics(
              child: ListTile(
                title: Text('Вибрация'),
                trailing: CupertinoSwitch(
                  value:
                      AppScopeWidget.of(context).appSettings.isVibrationEnabled,
                  onChanged: (bool value) {
                    if (value) {
                      Vibration.hasVibrator().then((hasVibrator) {
                        if (hasVibrator) Vibration.vibrate(duration: 10);
                      });
                    }
                    appScope.appSettings.isVibrationEnabled = value;
                    appScope.saveAppSettings();
                    setState(() {});
                  },
                ),
                onTap: () {
                  setState(() {
                    appScope.appSettings.isVibrationEnabled =
                        !appScope.appSettings.isVibrationEnabled;
                  });
                  if (appScope.appSettings.isVibrationEnabled) {
                    Vibration.hasVibrator().then((hasVibrator) {
                      if (hasVibrator) Vibration.vibrate(duration: 10);
                    });
                  }
                },
              ),
            ),
            MergeSemantics(
              child: ListTile(
                title: Text('Выйти из личного кабинета'),
                onTap: () {
                  appScope.setPersonInfo(null);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  backPressed() => Navigator.of(context).pop();
}
