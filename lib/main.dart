import 'package:conti_consegne/controller/perDataController.dart';
import 'package:conti_consegne/db/db_spese.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:conti_consegne/db/db.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sqflite/sqflite.dart';
import 'app.dart';
import 'package:get/get.dart';
import 'package:conti_consegne/pages/home_schede.dart';

void main() async{
  gDb x=gDb();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await gDb.crea();
  final dbConnection = await gDb.getDB();
  GetIt.instance.registerSingleton<Database>(dbConnection);

  GetIt.I.registerSingleton<gDb>(gDb());
  GetIt.I.registerSingleton<gDbSpese>(gDbSpese());
  Get.put(PerDataController());

  /*
  final dbConnectionSpese = await gDb.getDBSpese();
  GetIt.instance.registerSingleton(dbConnectionSpese);
  GetIt.I.registerSingleton<gDb>(gDb());
   */

  runApp(App());
}
