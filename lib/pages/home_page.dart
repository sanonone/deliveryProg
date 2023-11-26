import 'package:conti_consegne/pages/modifica_page.dart';
import 'package:conti_consegne/pages/subpage_home/consegne_subpage.dart';
import 'package:conti_consegne/pages/subpage_home/spese_subpage.dart';
import 'package:conti_consegne/pages/subpage_home/spese_subpage2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../db/db.dart';
import '../gestione/gestioneData.dart';
import '../oggetti/Consegne.dart';

class HomePage extends StatefulWidget {
  int ind=0;
  HomePage({super.key,required this.ind});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int iniIndex=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: DefaultTabController(
          initialIndex: widget.ind,
          length: 2,
          child: Scaffold(

            appBar: AppBar(
              title: Text("Delivery Cash Manager"),
              leading: Icon(
                Icons.delivery_dining_sharp,
                size: 45,
                color: Colors.grey.shade900,
              ),
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.arrow_downward,color: Colors.green,),
                  text: "Incassato",
                ),
                Tab(
                  icon: Icon(Icons.arrow_upward,color: Colors.red,),
                  text: "Speso",
                ),
              ]),
            ),
            body: TabBarView(children: [
              //Subpage1(),
              ConsegneSubpage(),
              SpeseSubpage2(),


            ]),
          ),
        ));
  }
}
