import 'package:todo_database/model/warband.dart';
import 'package:todo_database/database/database.dart';
import 'package:dio/dio.dart';

DatabaseProvider databaseProvider = DatabaseProvider();

class WarbandApiProvider {
  Future<List<Warband?>> getWarband(int id) async {
    var url = "https://63b898e06f4d5660c6da8203.mockapi.io/facciones?id=$id";
    Response response = await Dio().get(url);

    return (response.data as List).map((warband) {
      // ignore: avoid_print
      print('Inserting $warband');
      databaseProvider.createWarbands(Warband.fromJson(warband));
    }).toList();
  }
}
