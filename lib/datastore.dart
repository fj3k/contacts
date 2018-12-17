import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
// import 'package:flutter/services.dart' show rootBundle;
import 'constants.dart';

/// Abstract class for representing rows in a database table
abstract class DataStorable {
  final DatabaseTable table = null;
  int id;

  DataStorable();

  Map<String, dynamic> toMap();
  fromMap(Map<String, dynamic> map);

  DataStorable.load({int id, DataStore dataStore}) {
    if (dataStore == null) dataStore = new DataStore();
    if (id != null) {
      dataStore.load(this);
    }
  }

  save({DataStore dataStore}) {
    if (dataStore == null) dataStore = new DataStore();
    dataStore.save(this);
  }

  // static List<DataStorable> getAll();
}

/// Manger for the database connexion.
///
/// This class is accessed by the ...Data classes; which manage individual tables.
/// The ...Data classes are in turn managed by classes responsible for tying the data together.
class DataStore {
  static final DataStore _singleton = new DataStore._internal();
  Database db;
  final int version = 1;
  bool isOpening = false;

  Future open() async {
    if (db != null || isOpening) return;
    isOpening = true;

    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'contacts.db');

    db = await openDatabase(path, version: version, onCreate: (Database db, int version) async {
      // String createSQL = await rootBundle.loadString('assets/schema/create_v$version.sql');
      // await db.execute(createSQL);
    });
  }

  Future<int> save(DataStorable data) async {
    if (data.id == null) {
      data.id = await db.insert(data.table.name, data.toMap());
      return data.id;
    }
    return await db.update(data.table.name, data.toMap(), where: '${data.table.idColumn} = ?', whereArgs:[data.id]);
  }

  load(DataStorable data) async {
    if (data.id == null) return;
    List<Map> map = await db.query(data.table.name, columns: data.table.columns, where: '${data.table.idColumn} = ?', whereArgs: [data.id]);
    data.fromMap(map.first);
  }

  Future<List<Map>> list(String table, List<String> columns, Map<String, dynamic> where) {
    if (where.isEmpty) {
      return db.query(table, columns: columns);
    }
    String whereCond = where.keys.join(' = ? AND ');
    List<dynamic> whereVals = where.values;
    return db.query(table, columns: columns, where: "$whereCond = ?", whereArgs: whereVals);
  }

  factory DataStore() {
    _singleton.open();
    return _singleton;
  }
  DataStore._internal();
}
