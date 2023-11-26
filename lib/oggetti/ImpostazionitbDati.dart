class ImpostazionitbDati{

  ImpostazionitbDati({ this.id = 0, required this.data, required this.ora,required this.fondo, this.time});

  late int id;
  late String data;
  late String ora;
  late double fondo;

  late String? time;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'ora': ora,
      'fondo': fondo,
      'time' : time,

    };
  }

  ImpostazionitbDati.fromMapObject(Map<String, dynamic> oggMap)
      : id = oggMap['id'],
        data = oggMap['data'],
        ora = oggMap['ora'],
        fondo = oggMap['fondo'],
        time = oggMap['time'];


  @override
  String toString() {
    return 'Oggetto{id: $id, data: $data, ora: $ora, time: $time}';
  }



}