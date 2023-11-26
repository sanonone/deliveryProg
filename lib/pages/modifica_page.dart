import 'package:conti_consegne/pages/home_schede.dart';
import 'package:conti_consegne/pages/home_schede2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import '../db/db.dart';
import '../gestione/gestioneData.dart';
import '../oggetti/Consegne.dart';

class ModPage extends StatefulWidget {
  ModPage({Key? key, required this.consegna})
      : super(
    key: key,
  );
  Consegne consegna;

  @override
  State<ModPage> createState() => _ModPageState(consegna);
}

class _ModPageState extends State<ModPage> {
  TextEditingController textControllerIncasso = TextEditingController();
  TextEditingController textControllerIncassoNote = TextEditingController();

  //TextEditingController textControllerIncassoNote;

  _ModPageState(this.consegnaa);

  Consegne consegnaa;
  gDb x = gDb();

  @override
  void initState() {
    super.initState();
    textControllerIncassoNote = TextEditingController(text: consegnaa.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("Modifica consegna"),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                        hintText: consegnaa.consegna.toString(),

                        //border: OutlineInputBorder(),
                        //labelText: '0.0',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: 80,
                      child: TextField(
                        minLines: 1,
                        maxLines: null,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        controller: textControllerIncassoNote,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration.collapsed(
                            hintText: "Note"
                        ),
                      ),
                    ),
                  ),
                ),

                /*
            TextField(
              controller:nameController ,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: consegnaa.consegna.toString(),

              ),
            ),

             */
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () =>
                          {
                            x.aggiornaConsegna(
                                consegnaa, textControllerIncasso.text),
                            x.aggiornaConsegnaNote(
                                consegnaa, textControllerIncassoNote.text),
                            print("STO MODIFICANDOOOOOOO"),
                            Future.delayed(Duration(milliseconds: 400), () {
                              // Codice da eseguire dopo l'attesa di 2 secondi
                              Get.to(HomeSchede(
                                indSchede: 0,
                                subpageHome: 0,
                              ));
                              print("Sono passati 2 secondi!");
                            }),

                          },
                          child: Text("Modifica"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.greenAccent.shade400),
                          )),
                      ElevatedButton(
                          onPressed: () =>
                          {
                            x.deleteRow(consegnaa),
                            Future.delayed(Duration(milliseconds: 400), () {
                              // Codice da eseguire dopo l'attesa di 2 secondi
                              Get.to(HomeSchede(
                                indSchede: 0,
                                subpageHome: 0,
                              ));
                              print("Sono passati 2 secondi!");
                            }),
                          },
                          child: Text("Elimina"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.greenAccent.shade400),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
