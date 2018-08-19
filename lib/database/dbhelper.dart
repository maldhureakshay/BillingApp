import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reciept_generator_app/model/Record.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Record(id INTEGER PRIMARY KEY, customerName TEXT, orderNo TEXT,mobileNo TEXT, totalAmount TEXT,paidAmount TEXT,date INTEGER)");
    print("Created tables");
  }

  void saveRecord(DRecord record) async {
    var dbClient = await db;
    
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Record(customerName, orderNo,mobileNo, totalAmount, paidAmount, date) VALUES(\'${record.customerName}\',\'${record.orderNo}\',\'${record.mobileNo}\',\'${record.totalAmount}\', \'${record.paidAmount}\',\'${record.date}\')'
      );
    });
  }

  Future<List<DRecord>> getRecords() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Record order by date DESC');
    List<DRecord> records = new List();
    for (int i = 0; i < list.length; i++) {
      records.add(new DRecord(list[i]["customerName"], list[i]["orderNo"],list[i]["mobileNo"], list[i]["totalAmount"], list[i]["paidAmount"], list[i]["date"]));
    }
    print(records.length);
    return records;
  }
}