import 'package:conti_consegne/db/db.dart';
import 'package:conti_consegne/oggetti/storicoSpese.dart';
import 'package:conti_consegne/oggetti/storicoSpese.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_schede2.dart';

class ModPageSpese extends StatefulWidget {
  ModPageSpese({Key? key, required this.spese})
      : super(
          key: key,
        );
  storicoSpese spese;

  @override
  State<ModPageSpese> createState() => _ModPageSpeseState(spese);
}

class _ModPageSpeseState extends State<ModPageSpese> {
  TextEditingController textControllerSpesa = TextEditingController();
  TextEditingController textControllerSpesaNote = TextEditingController();

  _ModPageSpeseState(this.spesaa);

  storicoSpese spesaa;
  gDb x = gDb();

  @override
  void initState() {
    super.initState();
    textControllerSpesaNote = TextEditingController(text: spesaa.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Modifica consegna"),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
        color: Colors.red,
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
                  controller: textControllerSpesa,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: spesaa.spese.toString(),

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
                    controller: textControllerSpesaNote,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration.collapsed(hintText: "Note"),
                  ),
                ),
              ),
            ),
            /*TextField(
              controller: nameController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: spesaa.spese.toString(),
              ),
            ),

             */
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => {
                            x.aggiornaSpesa(spesaa, textControllerSpesa.text),
                            x.aggiornaSpesaNote(
                                spesaa, textControllerSpesaNote.text),
                            print("STO MODIFICANDOOOOOOO"),
                            Future.delayed(Duration(milliseconds: 400), () {
                              // Codice da eseguire dopo l'attesa di 2 secondi
                              Get.to(HomeSchede(
                                indSchede: 0,
                                subpageHome: 1,
                              ));
                              print("Sono passati 2 secondi!");
                            }),
                          },
                      child: Text("Modifica"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                      )),
                  ElevatedButton(
                      onPressed: () => {
                            x.deleteRowSpesa(spesaa),
                            Future.delayed(Duration(milliseconds: 400), () {
                              // Codice da eseguire dopo l'attesa di 2 secondi
                              Get.to(HomeSchede(
                                indSchede: 0,
                                subpageHome: 1,
                              ));
                              print("Sono passati 2 secondi!");
                            }),
                          },
                      child: Text("Elimina"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
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
