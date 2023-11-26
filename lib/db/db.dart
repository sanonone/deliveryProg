import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:conti_consegne/oggetti/Consegne.dart';
import 'package:conti_consegne/oggetti/ImpostazionitbDati.dart';
import 'package:sqflite/sqflite.dart';
import 'package:conti_consegne/oggetti/storicoSpese.dart';


class gDb {
  List<Consegne> valConsegne = [];

  Future<void> inizializzaView() async {
    valConsegne = await GetIt.instance<gDb>().getAll();
  }

  Future<List<Consegne>> listConsegne(DateTime inizio, DateTime fin, bool tutto) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    //print(path);
    DateTime adesso=DateTime.now().add(Duration(days: 1));
    DateTime fine=fin.add(Duration(days: 1));
    print("Data attuale: $adesso, Data inizio: $inizio, Data fine: $fine");
    Database _db = await openDatabase(path);

    if (_db == null) await crea();
    List<Consegne> result = [];
    if(tutto==false) {
      print("entro in false");
      List<Map<String, Object?>> rows = await _db.query(
          "tbconsegne", where: "timestamp<'$fine' AND timestamp>='$inizio'");
      int i = 0;
      for (var row in rows) {
        result.add(Consegne(
          id: row["id"] as int,
          consegna: row["consegna"] as double,
          data: row["data"] as String,
          ora: row["ora"] as String,
          time: row["timestamp"] as String,
          note: row["note"] as String,
        ));
        print(result[i].consegna);
        i++;
      }
      await _db.close();
      return result;
    }
    if(tutto==true) {
      print("entro in true");
      List<Map<String, Object?>> rows = await _db.query(
          "tbconsegne", where: "timestamp<='$adesso'");

      int i = 0;
      for (var row in rows) {
        result.add(Consegne(
          id: row["id"] as int,
          consegna: row["consegna"] as double,
          data: row["data"] as String,
          ora: row["ora"] as String,
          time: row["timestamp"] as String,
          note: row["note"] as String,
        ));
        print(result[i].consegna);
        i++;
      }
      await _db.close();
      return result;
    }
    List<Consegne> resultnull = [];
    //await _db.close();
    return resultnull; //se non torna nulla
  }

  Future<List<storicoSpese>> listSpese(DateTime inizio, DateTime fin, bool tutto) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');
    //print(path);
    DateTime adesso=DateTime.now().add(Duration(days: 1));
    DateTime fine=fin.add(Duration(days: 1));
    print("Data attuale: $adesso, Data inizio: $inizio, Data fine: $fine");

    Database _db = await openDatabase(path);

    if (_db == null) await crea();
    List<storicoSpese> result = [];

    if(tutto==false) {
      List<Map<String, Object?>> rows = await _db.query("tbstoricoSpese", where: "timestamp<'$fine' AND timestamp>='$inizio'");
      //List<Map<String, Object?>> rows = await _db.rawQuery("select * from tbstoricoSpese where id=1");
      int i = 0;
      for (var row in rows) {
        result.add(storicoSpese(
          id: row["id"] as int,
          data: row["data"] as String,
          ora: row["ora"] as String,
          spese: row["spese"] as double,
          time: row["timestamp"] as String,
          note: row["note"] as String,
        ));
        print(result[i].spese);
        i++;
      }
      await _db.close();
      return result;
    }

    if(tutto==true) {
      List<Map<String, Object?>> rows = await _db.query("tbstoricoSpese");
      //List<Map<String, Object?>> rows = await _db.rawQuery("select * from tbstoricoSpese where id=1");
      int i = 0;
      for (var row in rows) {
        result.add(storicoSpese(
          id: row["id"] as int,
          data: row["data"] as String,
          ora: row["ora"] as String,
          spese: row["spese"] as double,
          time: row["timestamp"] as String,
          note: row["note"] as String,
        ));
        print(result[i].spese);
        i++;
      }
      await _db.close();
      return result;
    }
    List<storicoSpese> resultnull = [];
    await _db.close();
    return resultnull; //se non torna nulla

  }




  Future<List<Consegne>> getAll() async {
    final db = await gDb.getDB();
    final rows = await db.query("tbconsegne");
    return rows.map((row) => Consegne.fromMapObject(row)).toList();
  }

  void aggiornaConsegna(Consegne old,String neww) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    //print(path);

    Database database = await openDatabase(path);
    double? val =double.tryParse(neww);
    int? id=old.id;
    print(val.toString()+" " +id.toString());
    List<dynamic> params = [val, id];
    //String sql="UPDATE tbconsegne SET consegna='$val' where id='$id'";
    int res=await database.rawUpdate('''UPDATE tbconsegne SET consegna=? WHERE id=?''', params);
    print("UPDATE FATTA");
    await database.close();
  }

  void aggiornaConsegnaNote(Consegne old,String neww) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    //print(path);

    Database database = await openDatabase(path);
    //double? val =double.tryParse(neww);
    int? id=old.id;
    //print(val.toString()+" " +id.toString());
    List<dynamic> params = [neww, id];
    //String sql="UPDATE tbconsegne SET consegna='$val' where id='$id'";
    int res=await database.rawUpdate('''UPDATE tbconsegne SET note=? WHERE id=?''', params);
    print("UPDATE FATTA");
    await database.close();
  }

  void aggiornaSpesa(storicoSpese old,String neww) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');
    //print(path);

    Database database = await openDatabase(path);
    double? val =double.tryParse(neww);
    int? id=old.id;
    print(val.toString()+" " +id.toString());
    List<dynamic> params = [val, id];
    //String sql="UPDATE tbconsegne SET consegna='$val' where id='$id'";
    int res=await database.rawUpdate('''UPDATE tbstoricoSpese SET spese=? WHERE id=?''', params);
    print("UPDATE FATTA");
    await database.close();
  }

  void aggiornaSpesaNote(storicoSpese old,String neww) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');
    //print(path);

    Database database = await openDatabase(path);
    //double? val =double.tryParse(neww);
    int? id=old.id;
    //print(val.toString()+" " +id.toString());
    List<dynamic> params = [neww, id];
    //String sql="UPDATE tbconsegne SET consegna='$val' where id='$id'";
    int res=await database.rawUpdate('''UPDATE tbstoricoSpese SET note=? WHERE id=?''', params);
    print("UPDATE FATTA");
    await database.close();
  }

  void deleteTbCondegne() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    Database database = await openDatabase(path);

    String sql="DELETE FROM tbconsegne";
    await database.execute(sql);
  }

  void deleteTbSpese() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');
    Database database = await openDatabase(path);

    String sql="DELETE FROM tbstoricoSpese";
    await database.execute(sql);
  }

  void deleteRow(Consegne o) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    //print(path);

    Database database = await openDatabase(path);

    int? id=o.id;
    String sql="DELETE FROM tbconsegne WHERE id=$id";
    await database.execute(sql);
  }

  void deleteRowSpesa(storicoSpese o) async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');
    //print(path);

    Database database = await openDatabase(path);

    int? id=o.id;
    String sql="DELETE FROM tbstoricoSpese WHERE id=$id";
    await database.execute(sql);
  }

  void insertConsegna(Consegne o) async {
    //int id=0;
    double? consegna = o.consegna;
    String? data = o.data;
    String? ora = o.ora;
    String? time = o.time;
    String? note = o.note;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    //print(path);

    Database database = await openDatabase(path);
    // Insert some records in a transaction
    await database.transaction((txn) async {
      String sql =
          '''INSERT INTO tbconsegne(consegna, data, ora, timestamp, note) VALUES(?,?,?,?,?)''';
      List<dynamic> params = [consegna, data, ora, time, note];
      await txn.rawInsert(sql, params);
      print("CONSEGNA INSERITA NEL DB");

    });
    await database.close();
  }

  static Future<Database> getDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbconsegne.db');
    //print(path);
    Database database = await openDatabase(path);
    return database;
  }

  static Future<Database> getDBDati() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbDati.db');
    //print(path);
    Database database = await openDatabase(path);
    return database;
  }

  static Future<Database> getDBSpese() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');
    //print(path);
    Database database = await openDatabase(path);
    return database;
  }

  static Future<bool> crea() async {
    //crea db e tabella

// open the database

      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'dbconsegne.db');
      String path2 = join(databasesPath, 'dbdati.db');
      String path3 = join(databasesPath, 'dbstoricoSpese.db');

      print(path);

// open the database
      Database databasex =
          await openDatabase(path, version: 1, //tabella consegne
              onCreate: (databasex, int version) async {
        // When creating the db, create the table
        await databasex.execute(
            "CREATE TABLE tbconsegne(id INTEGER PRIMARY KEY AUTOINCREMENT, consegna double NOT NULL, data TEXT, ora TEXT, timestamp DATETIME, note STRING)");
      });

      Database database2 = await openDatabase(path2,
          version: 1, //tabella impostazioni fondo spese
          onCreate: (database2, int version) async {
        // When creating the db, create the table
        await database2.execute(
            'CREATE TABLE tbdati(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT, ora TEXT, fondo double NOT NULL, timestamp DATETIME)');
      });


      Database database3 =
          await openDatabase(path3, version: 1, //tabella per storico spese
              onCreate: (database3, int version) async {
        // When creating the db, create the table
        await database3.execute(
            'CREATE TABLE tbstoricoSpese(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT, ora TEXT, spese double NOT NULL, timestamp DATETIME, note STRING)');
      });

      await databasex.close();
      await database2.close();
      await database3.close();

      print("DB CREATO");
      return true;

    }


  void insertSpesa(storicoSpese s) async {
    int id = 0;
    String? data = s.data;
    String? ora = s.ora;
    double? spese = s.spese;
    String? time = s.time;
    String? note = s.note;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbstoricoSpese.db');

    Database database = await openDatabase(path);
    // Insert some records in a transaction
    await database.transaction((txn) async {
      String sql =
          '''INSERT INTO tbstoricoSpese(data, ora, spese, timestamp, note) VALUES(?,?,?,?,?)''';
      List<dynamic> params = [data, ora, spese, time, note];
      await txn.rawInsert(sql, params);
    });
    await database.close();
  }

  void insertImpostazionitbDati(ImpostazionitbDati i) async {
    int id = 0;
    String data = i.data;
    String ora = i.ora;
    double fondo = i.fondo;
    String? time = i.time;

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dbdati.db');

    Database database = await openDatabase(path);
    // Insert some records in a transaction
    await database.transaction((txn) async {
      String sql =
          '''INSERT INTO tbdati(data, ora, fondo, timestamp) VALUES(?,?,?,?,?)''';
      List<dynamic> params = [data, ora, fondo, time];
      await txn.rawInsert(sql, params);
    });
  }

}
