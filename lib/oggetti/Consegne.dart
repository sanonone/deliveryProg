

class Consegne{
  Consegne({ this.id, this.consegna, this.data, this.ora, this.time, this.note});
  late int? id;
  late double? consegna;
  late String? data;
  late String? ora;
  late String? time;
  late String? note;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'consegna': consegna,
      'data': data,
      'ora': ora,
      'time':time,
      'note' : note,

    };
  }

  Consegne.fromMapObject(Map<String, dynamic> oggMap)
      : id = oggMap['id'],
        consegna = oggMap['consegna'],
        data = oggMap['data'],
        ora = oggMap['ora'],
        time = oggMap['time'],
        note = oggMap['note'];



  @override
  String toString() {
    return 'Oggetto{id: $id, consegna: $consegna, data: $data, ora: $ora, time: $time, note: $note}';
  }

}