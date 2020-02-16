import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';

import 'data/remote_config_data.dart';

class AdManager {
  String _appId = 'ca-app-pub-4272857293285960~2971187629';
  String _mainBlockId = 'ca-app-pub-4272857293285960/3422613768';
  String _fullScreenId = 'ca-app-pub-4272857293285960/8464147257';

  BannerAd mainBanner;

  MobileAdTargetingInfo targetingInfo;

  StreamController<bool> isMainBannerShowedStream = StreamController<bool>();
  bool isMainBannerShowed = false;
  bool canLaunchAd = true;

  InterstitialAd fullScreenAd;

  AdManager() {
    isMainBannerShowedStream.add(false);
    FirebaseAdMob.instance.initialize(appId: _appId);

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['учеба', 'студент', 'микронаушники', 'университет'],
      contentUrl: 'https://www.mitso.by',
      childDirected: false,
    );

    fullScreenAd = InterstitialAd(
      adUnitId: _fullScreenId,
      targetingInfo: targetingInfo,
    );
    _loadFullScreen();
  }

  showMainBanner(RemoteConfigData remoteConfigData) {
    if (!remoteConfigData.showAd || isMainBannerShowed) {
      return;
    }
    isMainBannerShowed = true;
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      print('call show ad');
      if (!remoteConfigData.showAd || !isMainBannerShowed) {
        return;
      }
      mainBanner = BannerAd(
          adUnitId: _mainBlockId,
          size: AdSize.smartBanner,
          targetingInfo: targetingInfo,
          listener: (MobileAdEvent event) {
            switch (event) {
              case MobileAdEvent.loaded:
                break;
              case MobileAdEvent.failedToLoad:
                break;
              case MobileAdEvent.clicked:
                hideMainBanner();
                break;
              case MobileAdEvent.impression:
                break;
              case MobileAdEvent.opened:
                hideMainBanner();
                break;
              case MobileAdEvent.leftApplication:
                break;
              case MobileAdEvent.closed:
                hideMainBanner();
                break;
            }
          });
      mainBanner.load().then((result) {
        print('loaded');
        if (result && isMainBannerShowed && canLaunchAd)
          mainBanner.show(anchorOffset: 60.0).then((_) {
            print('showed');
            if (!isMainBannerShowed && !canLaunchAd)
              hideMainBanner();
            else
              isMainBannerShowedStream.sink.add(true);
          });
      });
    });
  }

  showFullScreen(RemoteConfigData remoteConfigData) async {
    if (!remoteConfigData.showAd) {
      return;
    }
    if (await fullScreenAd.isLoaded()) {
      fullScreenAd.show();
    } else {
      await _loadFullScreen();
      fullScreenAd.show();
    }
  }

  Future _loadFullScreen() async {
    return fullScreenAd.load();
  }

  hideMainBanner({bool repeat = true}) async {
    int intervalMs = 100;
    int seconds = 1;
    await Future.delayed(Duration(milliseconds: 1000));
    _disposeAdBanner();
    for (int i = 0; i < seconds * 8; i++) {
      await Future.delayed(Duration(milliseconds: intervalMs));
      _disposeAdBanner();
    }
  }

  _disposeAdBanner() {
    try {
      isMainBannerShowed = false;
      isMainBannerShowedStream.add(false);
      mainBanner.dispose();
      mainBanner = null;
    } catch (e) {}
  }
}
