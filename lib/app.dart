import 'package:conti_consegne/pages/home_schede2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:conti_consegne/pages/home_schede.dart';

import 'ads/app_open_admanager.dart';
import 'ads/app_open_lifecycle_reactor.dart';

class App extends StatefulWidget{



  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    print("stampo "+appOpenAdManager.toString());
    appOpenAdManager.showAdIfAvailable();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }


  Widget build(BuildContext context){


    return GetMaterialApp(
      title: "Conti fattorino",
      /*
        theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
       */
      home: HomeSchede(indSchede: 0,subpageHome: 0,)
    );
  }
}