import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FirebaseAnalyticsHelper {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver _analyticsObserver =
      FirebaseAnalyticsObserver(analytics: _analytics);

  FirebaseAnalyticsObserver get analyticsObserver => _analyticsObserver;

  FirebaseAnalyticsHelper()
      : _analyticsObserver = FirebaseAnalyticsObserver(analytics: _analytics);

  void sendCurrentScreenToAnalytics(
      String category, String name, String screen) {
    _analyticsObserver.analytics.logEvent(
      name: name.replaceAll(' ', '_'),
      parameters: <String, dynamic>{
        'Category': category,
        'Type': 'Pageview',
        'Screen': screen,
      },
    );
  }

  void sendButtonEventToAnalytics(
      String category, String name, String screen, String buttonName) {
    _analyticsObserver.analytics.logEvent(
      name: name.replaceAll(' ', '_'),
      parameters: <String, dynamic>{
        'Category': category,
        'Type': 'Button',
        'Screen': screen,
        'Action_button': buttonName,
      },
    );
  }
}

enum EventsType { Pageview, Button }
