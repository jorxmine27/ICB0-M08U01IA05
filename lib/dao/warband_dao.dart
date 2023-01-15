import 'dart:async';
import 'package:todo_database/database/database.dart';
import 'package:todo_database/model/warband.dart';

var warbandTable = 'Warband';

class WarbandDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Warband records  !!!
  Future<Future<int>?> createWarband(Warband warband) async {
    var db = await dbProvider.database;
    var result = db?.insert(warbandTable, warband.toJson());
    return result;
  }

    Future<List<Warband?>> getAllWarbands() async {
    final db = await dbProvider.database;
    var result = await db?.rawQuery("SELECT * FROM $warbandTable");

    List<Warband> list = result!.isNotEmpty
        ? result.map((c) => Warband.fromJson(c)).toList()
        : [];

    return list;
  }

  //Update Todo record
  Future<int> updateWarband(Warband warband, int idFaction) async {
    final db = await dbProvider.database;

    var result = await db!.update(warbandTable, warband.toJson(),
        where: "id_faction = ?", whereArgs: [idFaction]);

    return result;
  }

  //Delete Todo records
  Future<int> deleteWarbands(int id) async {
    final db = await dbProvider.database;
    var result = await db!.delete(warbandTable, where: 'id_faction = ?', whereArgs: [id]);

    return result;
  }

  Future<int> deleteWarbandsByNameNotEqualTo(String warband) async {
    final db = await dbProvider.database;
    var result = await db!.delete(
    warbandTable, 
    where: 'warband NOT LIKE ?', 
    whereArgs: ["%$warband%"]
    );

    return result;
  }

  Future deleteAllWarbands() async {
    final db = await dbProvider.database;
    var result = await db!.delete(
      warbandTable,
    );

    return result;
  }

  Future<List<Warband>> getWarbandsByIdAlliance(int id) async {
    final db = await dbProvider.database;
    var result =
        await db?.rawQuery("SELECT * FROM $warbandTable WHERE id = $id");

    List<Warband> list = result!.isNotEmpty
        ? result.map((c) => Warband.fromJson(c)).toList()
        : [];

    return list;
  }
  
}
