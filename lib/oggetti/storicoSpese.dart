class storicoSpese {

  storicoSpese({ this.id = 0, this.data, this.ora, this.spese, this.time, this.note});

  late int? id;
  late String? data;
  late String? ora;
  late double? spese;
  late String? time;
  late String? note;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'ora': ora,
      'spese': spese,
      'time' : time,
      'note':note,

    };
  }

  storicoSpese.fromMapObject(Map<String, dynamic> oggMap)
      : id = oggMap['id'],
        data = oggMap['data'],
        ora = oggMap['ora'],
        spese= oggMap['spese'],
        time = oggMap['time'],
        note = oggMap['note'];


  @override
  String toString() {
    return 'Oggetto{id: $id, data: $data, ora: $ora, spese: $spese, time: $time, note: $note}';
  }

}