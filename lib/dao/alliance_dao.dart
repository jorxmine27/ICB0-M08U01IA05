import 'dart:async';
import 'package:todo_database/database/database.dart';
import 'package:todo_database/model/alliance.dart';

var allianceTable = 'Alliance';

class AllianceDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Todo records  !!!
  Future<Future<int>?> createAlliance(Alliance alliance) async {
    var db = await dbProvider.database;
    var result = db?.insert(allianceTable, alliance.toJson());
    return result;
  }
  
}
