import 'dart:async';
import 'package:todo_database/model/warband.dart';
import 'package:todo_database/repository/warband_repository.dart';

class WarbandBloc {
  final _warbandRepository = WarbandRepository();
  final _warbandController = StreamController<List<Warband>>.broadcast();

  get warbands => _warbandController.stream;

  WarbandBloc() {
    getWarbands();
  }

  getWarbands({String? query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _warbandController.sink
        .add(await _warbandRepository.getAllWarbands(query: query));
  }

  addWarband(Warband warband) async {
    await _warbandRepository.insertWarband(warband);
    getWarbands();
  }

  updateWarband(Warband warband, int idFaction) async {
    await _warbandRepository.updateWarband(warband, idFaction);
    getWarbands();
  }

  deleteWarband(int id) async {
    _warbandRepository.deleteWarbandById(id);
    getWarbands();
  }

  deleteWarbandByNameNotEqual(String warband) async {
    _warbandRepository.deleteWarbandByNameNotEqualTo(warband);
  }

  dispose() {
    _warbandController.close();
  }
}
