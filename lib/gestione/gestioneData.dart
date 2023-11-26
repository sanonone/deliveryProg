import 'package:intl/intl.dart';

class GestioneData{


  String getData(){
    DateTime now=DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String data = formatter.format(now);
    return data;
  }

  String getOra(){
    DateTime now=DateTime.now();
    String ora= DateFormat.Hms().format(now);
    return ora;
  }

}