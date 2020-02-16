import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

class RemoteConfigData {
  String actualVersion;
  String secondActualVersion;
  final bool showAd;

  RemoteConfigData(
      {@required this.showAd,
      @required this.actualVersion,
      @required this.secondActualVersion});

  static Future<RemoteConfigData> setupRemoteConfig() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
    remoteConfig.setDefaults(<String, dynamic>{
      'android_actual_version': packageInfo.version,
      'android_second_actual_version': packageInfo.version,
      'android_show_ad': false,
    });
    await remoteConfig
        .fetch(expiration: const Duration(seconds: 0))
        .catchError((_) {});
    await remoteConfig.activateFetched();
    return RemoteConfigData(
      showAd: remoteConfig.getBool('android_show_ad'),
      actualVersion: remoteConfig.getString('android_actual_version'),
      secondActualVersion:
          remoteConfig.getString('android_second_actual_version'),
    );
  }
}
