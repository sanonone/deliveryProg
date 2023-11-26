import 'package:get/get.dart';

class PerDataController extends GetxController {
  late Rx<DateTime> dataRicercaIni=DateTime.now().subtract(Duration(days: 1)).obs;
  late Rx<DateTime> dataRicercaFin=DateTime.now().obs;

  void updateStartDate(DateTime ini, DateTime fin){
    dataRicercaIni.value=ini;
    dataRicercaFin.value=fin;
  }
}