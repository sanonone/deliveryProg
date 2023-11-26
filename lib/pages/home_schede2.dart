import 'package:conti_consegne/pages/calcoli_page.dart';
import 'package:conti_consegne/pages/conto_page.dart';
import 'package:conti_consegne/pages/home_page.dart';
import 'package:conti_consegne/pages/modifica_page.dart';
import 'package:conti_consegne/pages/pagina_prova.dart';
import 'package:conti_consegne/pages/profilo_page.dart';
import 'package:conti_consegne/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ads/app_open_admanager.dart';
import '../ads/app_open_lifecycle_reactor.dart';


class HomeSchede extends StatefulWidget {
  int indSchede=0;
  int subpageHome=0;
  HomeSchede({super.key, required this.indSchede, required this.subpageHome});

  @override
  State<HomeSchede> createState() => _HomeSchedeState();
}

class _HomeSchedeState extends State<HomeSchede> {

  //int currentindSchedeex=widget.indSchede;



  late List screens=[
    HomePage(ind: widget.subpageHome,),
    ContiPage(),
    SettingsPage(),
    //ProfiloPage()
  ];


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: screens[widget.indSchede],
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade400,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 16.0,
        unselectedFontSize:  13.0,
        type: BottomNavigationBarType.shifting,
        //fa cambiare il colore della barra con quelli dell'item
        currentIndex: widget.indSchede,
        onTap: (indSchedeex) => setState(() {
          widget.indSchede = indSchedeex;

        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Aggiungi consegna",
              backgroundColor: Colors.orange),

          BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              label: "Conti",
              backgroundColor: Colors.orange),

          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Impostazioni",
              backgroundColor: Colors.orange),

          /*BottomNavigationBarItem(
              icon: Icon(Icons.face),
              label: "Profilo",
              backgroundColor: Colors.orange),

           */
        ],
      ),
    );
  }
}
