import 'dart:io';

import 'package:conti_consegne/controller/perDataController.dart';
import 'package:conti_consegne/db/db.dart';
import 'package:conti_consegne/gestione/gestioneData.dart';
import 'package:conti_consegne/oggetti/Consegne.dart';
import 'package:conti_consegne/pages/modifica_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsegneSubpage extends StatefulWidget {
  const ConsegneSubpage({super.key});

  @override
  State<ConsegneSubpage> createState() => _ConsegneSubpageState();
}

class _ConsegneSubpageState extends State<ConsegneSubpage> {
  final PerDataController perDataController = Get.find();
  bool primoIngresso=true;
  bool _oggi=false;
  late int _vediOggiOre;
  bool _tutto=false;
  bool _perData=false;
  DateTime? _startDate;
  DateTime? _endDate;
  String _dataIniziale="...";
  String _dataFinale="...";
  var formatter = DateFormat('dd/MM/ '); // Formato della data
  var formatterCompleto = DateFormat('dd/MM/yyyy HH:mm:ss'); // Formato della data


  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final adUnitId = Platform.isAndroid
  //? 'ca-app-pub-7615185660697607/7299348047'
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

  TextEditingController textControllerIncasso = TextEditingController();
  TextEditingController textControllerNote = TextEditingController();
  bool _isButtonDisabled = false;
  final List<dynamic> items = [].obs; //lista consegne db
  List<Consegne> listaConsegne = [];
  final List<String> dataoraConsegne = <String>[""];
  late int lenght = 0;
  Consegne modifica = Consegne();
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
    setState(() {

      prefs.setBool('vediTutto', _tutto);
      prefs.setBool('vediOggi', _oggi);
      prefs.setBool('perData', _perData);
      print("per data in loadPref Consegne= $_perData");
      if(_startDate != null && _endDate!= null) {
        prefs.setString("dataIniziale", formatter.format(_startDate!));
        prefs.setString("dataFinale", formatter.format(_endDate!));
      }
      else{
        prefs.setString("dataIniziale", _dataIniziale);
        prefs.setString("dataFinale", _dataFinale);
        //prefs.setBool('perData', true);
      }
    });
  }

  Future loadList() async {
    print("[loadlist consegne]DATE CONTROLLER: ini=${perDataController.dataRicercaIni}, fin=${perDataController.dataRicercaFin}");
    //DateTime inizio = DateTime(2023, 10, 03);
    //DateTime fine = DateTime(2023, 10, 04, 24, 59, 59, 59, 000);
    print("[loadlist consegne]tutto=$_tutto, oggi=$_oggi, per data=$_perData");

    gDb db=gDb();
    if(_tutto==true){

      db.listConsegne(DateTime.now(), DateTime.now(), true).then((consegna){
      //GetIt.I<gDb>().listConsegne(DateTime.now(), DateTime.now(), true).then((consegna) {
        setState(() {
          items.clear();
          listaConsegne.clear();
          for (var ele in consegna) {
            Consegne ogg = ele;
            print(ele.consegna.toString() + " " + ele.note.toString());
            listaConsegne.add(ogg);
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
      print("consegne nelle ultime $_vediOggiOre ore");
      DateTime inizio=DateTime.now().subtract(Duration(hours: _vediOggiOre));
      DateTime fine=DateTime.now();
      db.listConsegne(inizio, fine, false).then((consegna){
      //GetIt.I<gDb>().listConsegne(inizio, fine, false).then((consegna) {
        setState(() {
          items.clear();
          listaConsegne.clear();
          for (var ele in consegna) {
            Consegne ogg = ele;
            print(ele.consegna.toString() + " " + ele.note.toString());
            listaConsegne.add(ogg);
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
      print("faccio ricerca per data consegne");
      db.listConsegne(perDataController.dataRicercaIni.value, perDataController.dataRicercaFin.value, false).then((consegna){
      //GetIt.I<gDb>().listConsegne(perDataController.dataRicercaIni.value, perDataController.dataRicercaFin.value, false).then((consegna) {
        setState(() {
          items.clear();
          listaConsegne.clear();
          for (var ele in consegna) {
            Consegne ogg = ele;
            print(ele.consegna.toString() + " " + ele.note.toString());
            listaConsegne.add(ogg);
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

  void cambiaPag(Consegne c) {
    print("print in funzione");
    print(c.consegna.toString());
    print(c.id.toString());
    Get.to(ModPage(
      consegna: c,
    ));
  }

  void invioInput() {
    final GestioneData d = GestioneData();
    final ele = textControllerIncasso.text;
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
        Future.delayed(Duration(milliseconds: 200), () {
          // Completa l'azione
          double numEle = double.parse(ele);
          DateTime time = DateTime.now();
          String formattedDatetime = formatterCompleto.format(time);
          Consegne c = Consegne(
              consegna: numEle,
              data: d.getData(),
              ora: d.getOra(),
              //time: formattedDatetime,
              time: time.toString(),
              note: note);
          mandaConsegna_db(c);
          //addItemToList(c);
          loadList();
          textControllerIncasso.clear();
          textControllerNote.clear();
          // Riabilita il pulsante
          setState(() {
            _isButtonDisabled = false;
          });
        });
      }
    }
  }

  void addItemToList(Consegne e) {
    setState(() {
      Consegne ele = e;

      items.insert(0, ele); //0 per mettere in alto alla pila
      //dataoraConsegne.insert(0, "");
      textControllerIncasso.clear(); //pulisce il campo di input dopo add
      print("FACCIO ADDITEM");
    });
  }

  void mandaConsegna_db(Consegne c) {
    final GestioneData d = GestioneData();
    gDb db = gDb();
    db.insertConsegna(c);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
      initialDateRange: DateTimeRange(
          start: now,
          end: now), // Imposta DateTime.now() come data iniziale preselezionata
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.red, // Cambia il colore delle date selezionate a rosso
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
        _oggi=false;
        _tutto=false;
        _perData=true;

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: () =>
                {_isButtonDisabled ? null : invioInput(), _saveSearch()},
            child: Icon(
              Icons.send,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          SafeArea(
              bottom: true,
              //right: true,
              //top: true,
              //left: true,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                //child: AdWidget(ad: _bannerAd!),
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
                      ElevatedButton(onPressed: () => {_selectDateRange(context)}, child: Text("Per data")),
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
                          if(value==true){
                            setState(() {
                              _tutto = value ?? false;
                              _oggi = false;
                              _perData = false;
                              _dataIniziale='...';
                              _dataFinale='...';
                            });
                            _saveSearch();
                            loadList();
                          }else{
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
                          if(value==true){
                            setState(() {
                              _oggi = value ?? false;
                              _tutto=false;
                              _perData = false;
                              _dataIniziale='...';
                              _dataFinale='...';
                            });
                            _saveSearch();
                            loadList();
                          }
                          else{
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
                    //padding: const EdgeInsets.all(8),
                    itemCount: lenght,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 10),
                        child: Container(
                          //color: Colors.indigo,
                          child: ListTile(
                            onTap: () => {
                              cambiaPag(listaConsegne[index]),
                              print(items[index])
                            },
                            leading: CircleAvatar(
                              child: Icon(Icons.euro),
                              backgroundColor: Colors.green,
                            ),
                            title: Text(
                                listaConsegne[index].consegna.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        18)) /*Text(items[index].toString())*/,
                            subtitle: Text("${index + 1}°) " +
                                listaConsegne[index].note.toString()),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Text(listaConsegne[index].data.toString()),
                                  Text(listaConsegne[index].ora.toString())
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              height: 60,
              child: TextField(
                autofocus: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: textControllerIncasso,
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
                    icon: Icon(Icons.send_sharp,color: Colors.green,size: 30,),
                    onPressed: _isButtonDisabled ? null : invioInput,

                  ),
                   */
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
