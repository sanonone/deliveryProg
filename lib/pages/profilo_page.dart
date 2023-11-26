import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfiloPage extends StatefulWidget {
  const ProfiloPage({super.key});

  @override
  State<ProfiloPage> createState() => _ProfiloPageState();
}

class _ProfiloPageState extends State<ProfiloPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  var formatter = DateFormat('dd/MM/yyyy HH:mm'); // Formato della data

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Seleziona Range di Date'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 20),
              if (_startDate != null && _endDate != null)
                Text('Data Iniziale: ${formatter.format(_startDate!)}'), // Formatta e visualizza la data
              if (_startDate == null && _endDate == null)
                Text('Data Iniziale: ${formatter.format(DateTime.now().subtract(Duration(days: 1)))}'),
              if (_startDate != null && _endDate != null)
                Text('Data Finale: ${formatter.format(_endDate!)}'), // Formatta e visualizza la data
              if (_startDate == null && _endDate == null)
                Text('Data Finale: ${formatter.format(DateTime.now())}'),

              ElevatedButton(
                onPressed: () {
                  _selectDateRange(context);
                },
                child: Text('Seleziona Range di Date'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
      initialDateRange: DateTimeRange(start: now, end: now), // Imposta DateTime.now() come data iniziale preselezionata
    );

    if (picked != null && picked.start != null && picked.end != null) {
      print('Data iniziale: ${picked.start}');
      print('Data finale: ${picked.end}');

      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    } else {
      print('Nessun range di date selezionato');
    }


    /*
    return MaterialApp(
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

     */
  }
}
