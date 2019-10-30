import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  String _appId = 'ca-app-pub-4272857293285960~2971187629';
  String _mainBlockId = 'ca-app-pub-4272857293285960/3422613768';

  BannerAd mainBanner;

  MobileAdTargetingInfo targetingInfo;

  StreamController<bool> isMainBannerShowed = StreamController<bool>();

  AdManager() {
    isMainBannerShowed.add(false);
    FirebaseAdMob.instance.initialize(appId: _appId);

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['учеба', 'студент', 'микронаушники', 'университет'],
      contentUrl: 'https://www.mitso.by',
      childDirected: false,
    );
  }

  showMainBanner() {
    mainBanner = BannerAd(
        adUnitId: _mainBlockId,
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          switch (event) {
            case MobileAdEvent.loaded:
              isMainBannerShowed.add(true);
              break;
            case MobileAdEvent.failedToLoad:
              // TODO: Handle this case.
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
              // TODO: Handle this case.
              break;
            case MobileAdEvent.closed:
              hideMainBanner();
              break;
          }
        });

    mainBanner
      ..load()
      ..show(
        anchorOffset: 60.0,
      );
  }

  hideMainBanner() {
    mainBanner.dispose().then((_) {
      isMainBannerShowed.add(false);
    });
    mainBanner = null;
  }
}
