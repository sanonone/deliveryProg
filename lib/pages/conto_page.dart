import 'dart:io';

import 'package:conti_consegne/oggetti/storicoSpese.dart';
import 'package:conti_consegne/pages/home_schede.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db.dart';
import '../gestione/gestioneData.dart';
import '../oggetti/Consegne.dart';

class ContiPage extends StatefulWidget {
  const ContiPage({Key? key}) : super(key: key);

  @override
  State<ContiPage> createState() => _ContiPageState();
}

class _ContiPageState extends State<ContiPage> {
  TextEditingController textControllerFondo = TextEditingController();
  final List<dynamic> itemsConsegne = [].obs;
  List<Consegne> listaConsegne = [];
  late int lenghtConsegne = 0;
  final List<dynamic> itemsSpese = [].obs;
  List<storicoSpese> listaSpese = [];
  late int lenghtSpese = 0;
  late double ttotaleConsegne = 0;
  late double ttotaleSpese = 0;
  late double ttotaleMenoSpese = 0;
  late double ttotaleFinale = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  late double _fondoCassa = 0.0;
  var formatter = DateFormat('dd/MM/yyyy HH:mm'); // Formato della data
  RewardedAd? _rewardedAd;
  bool adVisto = false;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  /// Loads a rewarded ad.
  void loadAd() {
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            setState(() {
              _rewardedAd = ad;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    loadAd();
    loadListConsegne();
    loadListSpese();
    _loadPreferences();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('lastSearch', textControllerIncasso.text);

    setState(() {
      prefs.setDouble("fondoCassa", _fondoCassa);
    });
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fondoCassa = prefs.getDouble('fondoCassa') ?? 0.0;
    });
    print("fondo cassa");
    print(_fondoCassa);
  }

  void calcolaTotali() {
    _loadPreferences();
    print(textControllerFondo.text);
    var fondoCassa = double.tryParse(textControllerFondo.text);
    //if (fondoCassa == null) fondoCassa = 0;
    if (fondoCassa != null) {
      setState(() {
        _fondoCassa = fondoCassa!;
        _savePreferences();
      });
    }
    double totaleConsegne = 0;
    double totaleSpese = 0;
    for (var ele in listaSpese) {
      totaleSpese += ele.spese!;
    }
    for (var ele in listaConsegne) {
      totaleConsegne += ele.consegna!;
    }
    double totaleMenoSpese = totaleConsegne - totaleSpese;
    double totaleFinale = totaleConsegne - totaleSpese + _fondoCassa!;
    print("totale consegne=" + totaleConsegne.toString());
    print("totale spese=" + totaleSpese.toString());
    print("totale meno spese=" + totaleMenoSpese.toString());
    print("totale finale=" + totaleFinale.toString());
    setState(() {
      ttotaleConsegne = totaleConsegne;
      ttotaleSpese = totaleSpese;
      ttotaleMenoSpese = totaleMenoSpese;
      ttotaleFinale = totaleFinale;
    });
  }

  Future loadListConsegne() async {
    gDb db=gDb();
    DateTime inizio = DateTime(2023, 10, 03);
    DateTime fine = DateTime(2023, 10, 04);
    if (_startDate == null && _endDate == null) {
      _startDate = DateTime.now().subtract(Duration(days: 1));
      _endDate = DateTime.now();
    }
    db.listConsegne(_startDate!, _endDate!, false).then((consegna){
    //GetIt.I<gDb>().listConsegne(_startDate!, _endDate!, false).then((consegna) {
      setState(() {
        itemsConsegne.clear();
        listaConsegne.clear();
        for (var ele in consegna) {
          Consegne ogg = ele;
          print(ele.consegna.toString() + " " + ele.note.toString());
          listaConsegne.add(ogg);
          itemsConsegne.add(ele);
        }
      });
      int l = itemsConsegne.length;
      setState(() {
        lenghtConsegne = itemsConsegne.length;
      });
      print("lunchezza in load list= $l");
    });
  }

  Future loadListSpese() async {
    gDb db=gDb();
    if (_startDate == null && _endDate == null) {
      _startDate = DateTime.now().subtract(Duration(days: 1));
      _endDate = DateTime.now();
    }
    db.listSpese(_startDate!, _endDate!, false).then((spesa){
    //GetIt.I<gDb>().listSpese(_startDate!, _endDate!, false).then((spesa) {
      setState(() {
        itemsSpese.clear();
        listaSpese.clear();
        for (var ele in spesa) {
          storicoSpese ogg = ele;
          //print(ele.spese.toString()+" "+ele.note.toString());
          listaSpese.add(ogg);
          itemsSpese.add(ele);
        }
      });
      int l = itemsSpese.length;
      setState(() {
        lenghtSpese = itemsSpese.length;
      });
      print("lunchezza in load list= $l");
    });
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
            colorScheme: ColorScheme.light(primary: Colors.red),
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
      });
      loadListConsegne();
      loadListSpese();
    } else {
      print('Nessun range di date selezionato');
    }
  }

  void apriAd() {
    _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // ignore: avoid_print
      print('Reward amount: ${rewardItem.amount}');
      setState(() => adVisto = true);
    });
    print(adVisto);
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Scaffold(

          appBar: AppBar(
            title: Text("Delivery Cash Manager"),
            leading: Icon(
              Icons.delivery_dining_sharp,
              size: 45,
              color: Colors.grey.shade900,
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Report incasso",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 250.0, top: 10),
                child: Text(
                  "Fondo Cassa",
                  style: TextStyle(fontSize: 18, color: Colors.orange),
                ),
              ),
              Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(right: 250.0, top: 5),
                  child: TextField(
                    onSubmitted: (String value) => {},
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: textControllerFondo,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "$_fondoCassa",

                      //border: OutlineInputBorder(),
                      //labelText: '0.0',
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.delivery_dining,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.orangeAccent.shade200,
                ),
                title: Text(
                  "Totale Consegne",
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text("${itemsConsegne.length} consegne effettuate"),
                trailing: Text(
                  "$ttotaleConsegne€",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.red,
                  ),
                  backgroundColor: Colors.orangeAccent.shade200,
                ),
                title: Text(
                  "Totale Spese",
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text("${itemsSpese.length} spese effettuate"),
                trailing: Text(
                  "$ttotaleSpese€",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.arrow_downward,
                    color: Colors.green,
                  ),
                  backgroundColor: Colors.orangeAccent.shade200,
                ),
                title: Text(
                  "Totale Incasso",
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text("Totale consegne-Totale spese"),
                trailing: Text(
                  "$ttotaleMenoSpese€",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.wallet,
                    color: Colors.yellowAccent,
                  ),
                  backgroundColor: Colors.orangeAccent.shade200,
                ),
                title: Text(
                  "Totale Incasso + Fondo cassa",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Text(
                  "$ttotaleFinale€",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              if (_startDate != null && _endDate != null)
                Text('Data Iniziale: ${formatter.format(_startDate!)}'),
              // Formatta e visualizza la data
              if (_startDate == null && _endDate == null)
                Text(
                    'Data Iniziale: ${formatter.format(DateTime.now().subtract(Duration(days: 1)))}'),
              if (_startDate != null && _endDate != null)
                Text('Data Finale: ${formatter.format(_endDate!)}'),
              // Formatta e visualizza la data
              if (_startDate == null && _endDate == null)
                Text('Data Finale: ${formatter.format(DateTime.now())}'),
              ElevatedButton(
                onPressed: () {
                  _selectDateRange(context);
                },
                child: Text('Seleziona Range di Date'),
              ),
              Visibility(
                visible: true,
                  child: TextButton(
                onPressed: () {
                  loadAd();
                  apriAd();

                },
                child: const Text("Vedi il video per calcolare l'incasso"),
              )),
              Visibility(
                  visible: adVisto,
                  child: ElevatedButton(
                    onPressed: () {
                      calcolaTotali();
                      setState(() {
                        //adVisto=false;
                      });
                    },
                    child: const Text('Calcola'),
                  ))
            ],
          ),
        ));
  }
}
