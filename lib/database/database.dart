import 'dart:async';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_database/model/alliance.dart';
import 'package:todo_database/model/warband.dart';

const todoTABLE = 'Todo';
const warbandTable = 'Warband';
const allianceTable = 'Alliance';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "warcryAPI.db");

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute(
        'CREATE TABLE Alliance( id INTEGER PRIMARY KEY, name TEXT, warbands INTEGER, icon TEXT )');
    await database.execute(
        'CREATE TABLE Warband( id INTEGER, id_faction INTEGER PRIMARY KEY, alliance TEXT, warband TEXT)');
    // await database.execute("CREATE TABLE $todoTABLE ("
    //     "id INTEGER PRIMARY KEY, "
    //     "description TEXT, "
    //     /*SQLITE doesn't have boolean type
    //     so we store isDone as integer where 0 is false
    //     and 1 is true*/
    //     "is_done INTEGER "
    //     ")");
  }

  // Insert alliance on database
  createAlliance(Alliance newAlliance) async {
    await deleteAllAlliances();
    final db = await database;
    final res = await db?.insert(allianceTable, newAlliance.toJson());

    return res;
  }

  // Delete all alliances
  Future<int?> deleteAllAlliances() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM Alliance');

    return res;
  }

  Future<List<Alliance?>> getAllAlliance() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM ALLIANCE");

    List<Alliance> list =
        res!.isNotEmpty ? res.map((c) => Alliance.fromJson(c)).toList() : [];

    return list;
  }

  // Insert warband on database
  createWarbands(Warband newWarband) async {
    await deleteAllWarbands();
    final db = await database;
    final res = await db?.insert(warbandTable, newWarband.toJson());

    return res;
  }

  // Delete all alliances
  Future<int?> deleteAllWarbands() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM Warband');

    return res;
  }

  Future<int?> deleteWarbandById(int id) async {
    final db = await database;
    final res =
        await db?.rawDelete('DELETE FROM Warband WHERE id_faction = $id');

    return res;
  }
}
