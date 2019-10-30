import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  String _appId = 'ca-app-pub-4272857293285960~2971187629';
  String _mainBlockId = 'ca-app-pub-4272857293285960/3422613768';

  BannerAd mainBanner;

  MobileAdTargetingInfo targetingInfo;

  StreamController<bool> isMainBannerShowedStream = StreamController<bool>();
  bool isMainBannerShowed = false;

  AdManager() {
    isMainBannerShowedStream.add(false);
    FirebaseAdMob.instance.initialize(appId: _appId);

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['учеба', 'студент', 'микронаушники', 'университет'],
      contentUrl: 'https://www.mitso.by',
      childDirected: false,
    );
  }

  showMainBanner() {
    if (mainBanner != null) {
      return;
    }
    isMainBannerShowed = true;
    mainBanner = BannerAd(
        adUnitId: _mainBlockId,
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) async {
          switch (event) {
            case MobileAdEvent.loaded:
              if (!isMainBannerShowed)
                hideMainBanner();
              else
                isMainBannerShowedStream.add(true);
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
    Future.delayed(const Duration(milliseconds: 500), () {
      isMainBannerShowed = false;
      isMainBannerShowedStream.add(false);
      mainBanner?.dispose();
      mainBanner = null;
    });
  }
}
