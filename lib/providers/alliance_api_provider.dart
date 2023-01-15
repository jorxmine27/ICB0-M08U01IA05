import 'package:todo_database/database/database.dart';
import 'package:todo_database/model/alliance.dart';
import 'package:dio/dio.dart';

DatabaseProvider databaseProvider = DatabaseProvider();

class AllianceApiProvider {
  Future<List<Alliance?>> getAllAlliances() async {
    var url = "https://63b898e06f4d5660c6da8203.mockapi.io/alianzas";
    // var url = "http://192.168.1.42:3535/warcryAPI/alianzas";
    Response response = await Dio().get(url);

    return (response.data as List).map((alliance) {
      // ignore: avoid_print
      print('Inserting $alliance');
      databaseProvider.createAlliance(Alliance.fromJson(alliance));
    }).toList();
  }
}
