/*
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import '../db/db.dart';
import '../gestione/gestioneData.dart';
import '../oggetti/Consegne.dart';
import 'modifica_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  final List<dynamic> items = [].obs; //lista consegne db
  List<Consegne> listaConsegne = [];
  final List<String> dataoraConsegne = <String>[""];
  late int lenght = 0;
  Consegne modifica = Consegne();
  gDb query = gDb();
  int _selectedIndex = 0;

  //var con=RxDouble(modifica.consegna);

  Future loadList() async {
    GetIt.I<gDb>().listConsegne().then((consegna) {
      setState(() {
        items.clear();
        listaConsegne.clear();
        for (var ele in consegna) {
          Consegne ogg=ele;
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
    final ele = nameController.text;
    print("valore text : $ele");
    if (ele == "") {
      null;
    } else {
      double numEle = double.parse(ele);
      Consegne c =
      Consegne(consegna: numEle, data: d.getData(), ora: d.getOra());
      mandaConsegna_db(c);
      //addItemToList(c);
      loadList();
      nameController.clear();
    }
  }

  void addItemToList(Consegne e) {
    setState(() {
      Consegne ele = e;

      items.insert(0, ele); //0 per mettere in alto alla pila
      //dataoraConsegne.insert(0, "");
      nameController.clear(); //pulisce il campo di input dopo add
      print("FACCIO ADDITEM");
    });
  }

  void mandaConsegna_db(Consegne c) {
    final GestioneData d = GestioneData();
    gDb db = gDb();
    db.insertConsegna(c);
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      loadList();
      int l = items.length;
      print("lunghezza $l");
      i = 1;
    }

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Conti fattorino"),
          ),
          body: Center(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Incasso consegna',
                  ),
                ),
              ),
              ElevatedButton(
                child: Text('Add'),
                onPressed: () => {invioInput()},
              ),
              ElevatedButton(
                  onPressed: () => {query.deleteTbCondegne(), loadList()},
                  child: Text("reset")),
              Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: lenght,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            color: Colors.indigo,
                            child: ListTile(
                              onTap: () =>
                              {cambiaPag(listaConsegne[index]), print(items[index])},
                              title:Text(listaConsegne[index].consegna.toString()) /*Text(items[index].toString())*/,
                            ),
                          ),
                        );
                      })),
            ]),
          ),


          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() {
              currentIndex = index;

            }),
            items: const <BottomNavigationBarItem>[

              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: "Aggiungi consegna",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calculate_outlined), label: "Fai conti"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Impostazioni"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.face), label: "Impostazioni"),
            ],
          ),

        ),
      /*
            BottomNavigationBar(
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: "Aggiungi consegna",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calculate_outlined), label: "Fai conti"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Impostazioni"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.face), label: "Impostazioni"),
              ],
            ),*/

    );
  }

  final screens=[
    HomePage(),
    //ModPage(consegna: ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Get.to(HomePage());
          break;
        case 1:
          Get.to(ModPage(consegna: modifica));
          break;
        case 2:
          ModPage(consegna: modifica);
          break;

        case 3:
          break;
      }
    });
  }
}
*/