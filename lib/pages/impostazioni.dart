import 'package:conti_consegne/pages/home_schede.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import '../db/db.dart';
import '../gestione/gestioneData.dart';
import '../oggetti/Consegne.dart';

class ImpostazioniPage extends StatefulWidget {
  const ImpostazioniPage({Key? key}) : super(key: key);

  @override
  State<ImpostazioniPage> createState() => _ImpostazioniPageState();
}

class _ImpostazioniPageState extends State<ImpostazioniPage> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Scaffold(
        appBar: AppBar(
        title: Text("Delivery wallet"),
    leading: Icon(
    Icons.delivery_dining_sharp,
    size: 45,
    color: Colors.grey.shade900,
    ),
    ),));
  }
}
