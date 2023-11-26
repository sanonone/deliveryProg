import 'dart:io';

import 'package:conti_consegne/db/db_spese.dart';
import 'package:conti_consegne/pages/modifica_page_spese.dart';
import 'package:flutter/material.dart';
import 'package:conti_consegne/db/db.dart';
import 'package:conti_consegne/gestione/gestioneData.dart';
import 'package:conti_consegne/oggetti/Consegne.dart';
import 'package:conti_consegne/pages/modifica_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/perDataController.dart';
import '../../oggetti/storicoSpese.dart';

class SpeseSubpage2 extends StatefulWidget {
  const SpeseSubpage2({super.key});

  @override
  State<SpeseSubpage2> createState() => _SpeseSubpage2State();
}

class _SpeseSubpage2State extends State<SpeseSubpage2> {
  final PerDataController perDataController = Get.find();
  bool primoIngresso=true;
  bool _oggi = false;
  late int _vediOggiOre;
  bool _tutto = false;
  bool _perData = false;
  DateTime? _startDate;
  DateTime? _endDate;
  String _dataIniziale = "...";
  String _dataFinale = "...";
  var formatter = DateFormat('dd/MM/ '); // Formato della data
  var formatterCompleto = DateFormat('dd/MM/yyyy HH:mm'); // Formato della data


  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final adUnitId = Platform.isAndroid
  //'ca-app-pub-3940256099942544/6300978111' TEST
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {
          debugPrint('ad loaded');
        },
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          debugPrint('ad closed');
        },
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {
          debugPrint('ad impression');
        },
      ),
    )..load();
  }


  @override
  void initState() {
    super.initState();
    loadAd();
    _loadPreferences();
    loadList();
  }

  TextEditingController textControllerNote = TextEditingController();
  bool _isButtonDisabled = false;
  TextEditingController textControllerSpesa = TextEditingController();
  final List<dynamic> items = [].obs; //lista spese db
  List<storicoSpese> listaSpese = [];
  final List<String> dataoraSpese = <String>[""];
  late int lenght = 0;
  storicoSpese modifica = storicoSpese();
  gDb query = gDb();
  int _selectedIndex = 0;

  //var con=RxDouble(modifica.consegna);

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _tutto = prefs.getBool('vediTutto') ?? false;
      _oggi = prefs.getBool('vediOggi') ?? false;
      _perData = prefs.getBool("perData") ?? false;
      _vediOggiOre = prefs.getInt('vediOggiOre') ?? 9;
      //_dataIniziale = prefs.getString("dataIniziale") ?? '...';
      //_dataFinale = prefs.getString("dataFinale") ?? '...';
      if(_perData==true) {
        _dataIniziale =
            formatter.format(perDataController.dataRicercaIni.value);
        _dataFinale = formatter.format(perDataController.dataRicercaFin.value);
      }
      else{
        _dataIniziale="...";
        _dataFinale="...";
      }

/*
      if(primoIngresso==true && _tutto==false && _oggi==false && _perData==false){
        _oggi=true;
        primoIngresso=false;
      }
*/
      //_tutto = true; //PROVVISORIO
      //_oggi = false;//PROVVISORIO
    });
    loadList();
  }

  void _saveSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('lastSearch', textControllerIncasso.text);

    setState(() {
      prefs.setBool('vediTutto', _tutto);
      prefs.setBool('vediOggi', _oggi);
      prefs.setBool('perData', _perData);
      print("per data in loadPref Spese= $_perData");
      if (_startDate != null && _endDate != null) {
        prefs.setString("dataIniziale", formatter.format(_startDate!));
        prefs.setString("dataFinale", formatter.format(_endDate!));
      } else {
        prefs.setString("dataIniziale", _dataIniziale);
        prefs.setString("dataFinale", _dataFinale);
        //prefs.setBool('perData', true);
      }
    });
  }

  Future loadList() async {
    print("[loadlist spese]DATE CONTROLLER: ini=${perDataController.dataRicercaIni}, fin=${perDataController.dataRicercaFin}");
    print("[loadlist spese]tutto=$_tutto, oggi=$_oggi, per data=$_perData");
    //DateTime inizio = DateTime(2023, 10, 03);
    //DateTime fine = DateTime(2023, 10, 04, 24, 59, 59, 59, 000);
    //Future<List<storicoSpese>> spesa;
    gDb db=gDb();
    if (_tutto == true) {
      db.listSpese(DateTime.now(), DateTime.now(), true).then((spesa){

      //GetIt.I<gDbSpese>().listSpese(DateTime.now(), DateTime.now(), true).then((spesa) {
        setState(() {
          items.clear();
          listaSpese.clear();
          for (var ele in spesa) {
            storicoSpese ogg = ele;
            //print(ele.spese.toString()+" "+ele.note.toString());
            listaSpese.add(ogg);
            items.add(ele
                /*
            ListTile(
              title: Text(
                  ele.id.toString() + " " + ele.consegna.toString() + " " +
                      ele.data.toString() + " " + ele.ora.toString()),
              onTap: () {},),
          */
                );
          }
        });
        int l = items.length;
        setState(() {
          lenght = items.length;
        });
        print("lunchezza in load list= $l");
      });
    }
    if(_oggi==true){
      print("spese nelle ultime $_vediOggiOre ore");
      DateTime inizio=DateTime.now().subtract(Duration(hours: _vediOggiOre));
      DateTime fine=DateTime.now();
      db.listSpese(inizio, fine, false).then((spesa){
      //GetIt.I<gDbSpese>().listSpese(inizio, fine, false).then((spesa) {
        setState(() {
          items.clear();
          listaSpese.clear();
          for (var ele in spesa) {
            storicoSpese ogg = ele;
            //print(ele.spese.toString()+" "+ele.note.toString());
            listaSpese.add(ogg);
            items.add(ele
              /*
            ListTile(
              title: Text(
                  ele.id.toString() + " " + ele.consegna.toString() + " " +
                      ele.data.toString() + " " + ele.ora.toString()),
              onTap: () {},),
          */
            );
          }
        });
        int l = items.length;
        setState(() {
          lenght = items.length;
        });
        print("lunchezza in load list= $l");
      });
    }
    if(_perData==true){
      print("faccio ricerca in spese per data");
      db.listSpese(perDataController.dataRicercaIni.value, perDataController.dataRicercaFin.value, false).then((spesa){
      //GetIt.I<gDbSpese>().listSpese(perDataController.dataRicercaIni.value, perDataController.dataRicercaFin.value, false).then((spesa) {
        setState(() {
          items.clear();
          listaSpese.clear();
          for (var ele in spesa) {
            storicoSpese ogg = ele;
            //print(ele.spese.toString()+" "+ele.note.toString());
            listaSpese.add(ogg);
            items.add(ele
              /*
            ListTile(
              title: Text(
                  ele.id.toString() + " " + ele.consegna.toString() + " " +
                      ele.data.toString() + " " + ele.ora.toString()),
              onTap: () {},),
          */
            );
          }
        });
        int l = items.length;
        setState(() {
          lenght = items.length;
        });
        print("lunchezza in load list= $l");
      });

    }
  }

  void cambiaPag(storicoSpese c) {
    print("print in funzione");
    //print(c.consegna.toString());
    print(c.id.toString());
    Get.to(ModPageSpese(
      spese: c,
    ));
  }

  void invioInput() {
    final GestioneData d = GestioneData();
    final ele = textControllerSpesa.text;
    final note = textControllerNote.text;
    print("valore text : $ele");
    if (ele == "" || ele == 0) {
      null;
    } else {
      if (!_isButtonDisabled) {
        // Disabilita il pulsante
        setState(() {
          _isButtonDisabled = true;
        });

        // Simula un'azione asincrona, ad esempio un ritardo di 2 secondi
        double numEle = double.parse(ele);
        DateTime time = DateTime.now();
        String formattedDatetime = time.toLocal().toIso8601String();
        storicoSpese c = storicoSpese(
            spese: numEle,
            data: d.getData(),
            ora: d.getOra(),
            //time: formattedDatetime,
            time:time.toString(),
            note: note);
        mandaSpesa_db(c);
        //addItemToList(c);
        loadList();
        textControllerSpesa.clear();
        textControllerNote.clear();

        // Riabilita il pulsante
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  void addItemToList(storicoSpese e) {
    setState(() {
      storicoSpese ele = e;

      items.insert(0, ele); //0 per mettere in alto alla pila
      //dataorastoricoSpese.insert(0, "");
      textControllerSpesa.clear(); //pulisce il campo di input dopo add
    });
  }

  void mandaSpesa_db(storicoSpese c) {
    final GestioneData d = GestioneData();
    gDb db = gDb();
    db.insertSpesa(c);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
      initialDateRange: DateTimeRange(start: now, end: now),
      // Imposta DateTime.now() come data iniziale preselezionata
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red,
            // Cambia il colore delle date selezionate a rosso
            colorScheme: ColorScheme.light(primary: Colors.orangeAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked.start != null && picked.end != null) {
      print('Data iniziale: ${picked.start}');
      print('Data finale: ${picked.end}');

      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _dataIniziale = formatter.format(_startDate!);
        _dataFinale = formatter.format(_endDate!);
        perDataController.updateStartDate(_startDate!, _endDate!);
        _oggi = false;
        _tutto = false;
        _perData = true;
      });
      _saveSearch();
      loadList();
    } else {
      print('Nessun range di date selezionato');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: IconButton(icon: Icon(Icons.update),onPressed: ()=>{loadList},alignment: Alignment.topRight,),
      //floatingActionButton: ElevatedButton(onPressed: ()=>{}, child: Icon(Icons.update_rounded),clipBehavior: Clip.none,style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,disabledBackgroundColor: Colors.transparent),),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            onPressed: () => {_isButtonDisabled ? null : invioInput()},
            child: Icon(
              Icons.send,
              color: Colors.white,
            )),
      ),
      body: Column(children: <Widget>[
        SafeArea(
            bottom: true,
            //right: true,
            //top: true,
            //left: true,
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
        ),
        Container(
          color: Colors.grey.shade200,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 4, top: 0, right: 0, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => {_selectDateRange(context)},
                        child: Text("Per data")),
                    Text("dal $_dataIniziale"),
                    Text("al $_dataFinale"),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Row(
                  children: [
                    Text("Vedi tutto"),
                    Checkbox(
                      value: _tutto,
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            _tutto = value ?? false;
                            _oggi = false;
                            _perData = false;
                            _dataIniziale = '...';
                            _dataFinale = '...';
                          });
                          _saveSearch();
                          loadList();
                        } else {
                          setState(() {
                            _tutto = value ?? false;
                          });
                          _saveSearch();
                          loadList();
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Vedi oggi"),
                    Checkbox(
                      value: _oggi,
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            _oggi = value ?? false;
                            _tutto = false;
                            _perData = false;
                            _dataIniziale = '...';
                            _dataFinale = '...';
                          });
                          _saveSearch();
                          loadList();
                        } else {
                          setState(() {
                            _oggi = value ?? false;
                            //_tutto=false;
                          });
                          _saveSearch();
                          loadList();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: loadList,
            child: ListView.builder(
                //padding: const EdgeInsets.only(top: 0, bottom: 8, right: 8, left: 8),
                itemCount: lenght,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Container(
                      //color: Colors.indigo,
                      child: ListTile(
                        onTap: () =>
                            {cambiaPag(listaSpese[index]), print(items[index])},
                        leading: CircleAvatar(
                          child: Icon(Icons.euro),
                          backgroundColor: Colors.red,
                        ),
                        title: Text(
                          listaSpese[index].spese.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ) /*Text(items[index].toString())*/,
                        subtitle: Text("${index + 1}°) " +
                            listaSpese[index].note.toString()),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(listaSpese[index].data.toString()),
                              Text(listaSpese[index].ora.toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            height: 60,
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              controller: textControllerSpesa,
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration.collapsed(
                hintText: "0.0",

                //border: OutlineInputBorder(),
                //labelText: '0.0',
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 8, bottom: 8, right: 85),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TextFormField(
              autocorrect: false,
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              controller: textControllerNote,
              decoration: InputDecoration(
                filled: true,
                hintText: "Note (opzionale)",
                border: UnderlineInputBorder(),
                /*
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send_sharp,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: _isButtonDisabled ? null : invioInput,
                ),
                 */
              ),
            ),
          ),
        ),

      ]),
    );
  }
}
