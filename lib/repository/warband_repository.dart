import 'package:todo_database/dao/warband_dao.dart';
import 'package:todo_database/model/warband.dart';

class WarbandRepository {
  final warbandDao = WarbandDao();

  Future getAllWarbands({String? query}) => warbandDao.getAllWarbands();

  Future deleteAllWarband({String? query}) => warbandDao.deleteAllWarbands();

  Future insertWarband(Warband warband) => warbandDao.createWarband(warband);

  Future updateWarband(Warband warband, int idFaction) => warbandDao.updateWarband(warband, idFaction);

  Future deleteWarbandById(int id) => warbandDao.deleteWarbands(id);

  Future deleteWarbandByNameNotEqualTo(String warband) => warbandDao.deleteWarbandsByNameNotEqualTo(warband);
}
