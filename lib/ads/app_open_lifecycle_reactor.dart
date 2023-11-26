import 'package:conti_consegne/ads/app_open_admanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    //appOpenAdManager.showAdIfAvailable();
    print('New AppState state OpenApp: $appState');

    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}