import 'package:conti_consegne/pages/modifica_page_spese.dart';
import 'package:flutter/material.dart';
import 'package:conti_consegne/db/db.dart';
import 'package:conti_consegne/gestione/gestioneData.dart';
import 'package:conti_consegne/oggetti/Consegne.dart';
import 'package:conti_consegne/pages/modifica_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../oggetti/storicoSpese.dart';

class SpeseSubpage extends StatefulWidget {
  const SpeseSubpage({super.key});

  @override
  State<SpeseSubpage> createState() => _SpeseSubpageState();
}

class _SpeseSubpageState extends State<SpeseSubpage> {
  @override
  void initState() {
    super.initState();
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

  Future loadList() async {
    DateTime inizio=DateTime(2023,10,03);
    DateTime fine=DateTime(2023,10,04,24,59,59,59,000);
    GetIt.I<gDb>().listSpese(inizio,fine,true).then((spesa) {
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
            time: formattedDatetime,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: IconButton(icon: Icon(Icons.update),onPressed: ()=>{loadList},alignment: Alignment.topRight,),
      //floatingActionButton: ElevatedButton(onPressed: ()=>{}, child: Icon(Icons.update_rounded),clipBehavior: Clip.none,style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,disabledBackgroundColor: Colors.transparent),),
      body: Column(children: <Widget>[

        Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 0,bottom: 8,right: 8,left: 8),
                itemCount: lenght,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Container(
                      //color: Colors.indigo,
                      child: ListTile(
                        onTap: () => {
                          cambiaPag(listaSpese[index]),
                          print(items[index])
                        },
                        leading: CircleAvatar(
                          child: Icon(Icons.euro),
                          backgroundColor: Colors.red,
                        ),
                        title: Text(listaSpese[index].spese.toString(),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),) /*Text(items[index].toString())*/,
                        subtitle: Text("${index+1}°) "+listaSpese[index].note.toString()),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top:10.0),
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
                })),
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
          padding: const EdgeInsets.all(8.0),
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
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send_sharp,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: _isButtonDisabled ? null : invioInput,
                ),
              ),
            ),
          ),
        )

        /*
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: textControllerSpesa
            ,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Speso',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                child: Text('Add'),
                onPressed: () => {invioInput()},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ElevatedButton(
                  onPressed: () => {query.deleteTbCondegne(), loadList()},
                  child: Text("reset")),
            ),

          ],
        ),
        */
      ]),
    );
  }
}
