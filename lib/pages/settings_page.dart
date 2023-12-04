import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/db.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late String _selectedValue='9'; // Valore predefinito selezionato
  late int _vediOggiOre;



  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }


  Future<void> savePreferences() async {
    int scelta=int.parse(_selectedValue);
    print(scelta);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('vediOggiOre', scelta);
    });


  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _vediOggiOre = prefs.getInt('vediOggiOre') ?? 9;
      _selectedValue=_vediOggiOre.toString();
    });

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
          body:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                ListTile(
                  leading: Text("Range ricerca\n[vedi oggi]",style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("Es: 9 per visualizzare tutte le consegne e spese effettuate nelle ultime 9 ore"),
                  trailing: DropdownButton<String>(
                    value: _selectedValue, // Valore attualmente selezionato
                    items: <String>[
                      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19','20','21','22', '23','24',

                      // Aggiungi altre opzioni come necessario
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState((){
                        _selectedValue = newValue!; // Aggiorna il valore selezionato
                      });
                      savePreferences();
                    },
                  ),
                ),
                ListTile(
                  leading: Text("Elimina tutte\nle consegne",style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("elimina tutte le consegne dal database (attenzione, non reversibile)"),
                  trailing: IconButton(onPressed: () {GetIt.I<gDb>().deleteTbCondegne();  }, icon: Icon(Icons.delete_forever,color: Colors.red,size: 30,),splashColor: Colors.red,),

                ),
                ListTile(
                  leading: Text("Elimina tutte\nle spese",style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("elimina tutte le spese dal database (attenzione, non reversibile)"),
                  trailing: IconButton(onPressed: () {GetIt.I<gDb>().deleteTbSpese();  }, icon: Icon(Icons.delete_forever,color:Colors.red,size: 30,),splashColor: Colors.red,),
                ),
                /*ElevatedButton(
                  onPressed: () async {
                    // Mostra il selettore di orario
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(), // Orario iniziale preselezionato
                    );

                    // Verifica se l'utente ha selezionato un orario
                    if (selectedTime != null) {
                      print('Orario selezionato: ${selectedTime.format(context)}');
                    }
                  },
                  child: Text('Seleziona Orario inizio'),
                ),
                 */
              ],
            ),
          ),

        )
    );
  }
}
