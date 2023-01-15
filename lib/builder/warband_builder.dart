import 'package:flutter/material.dart';
import 'package:todo_database/ui/warband_page.dart';
import 'package:todo_database/bloc/warband_bloc.dart';
import 'package:todo_database/dao/warband_dao.dart';
import 'package:todo_database/model/warband.dart';
import 'package:todo_database/database/database.dart';

var alliance;
final importAlliance = ImportAlliance();
final DatabaseProvider databaseProvider = DatabaseProvider();
final warbandDao = WarbandDao();

// Preparing th magic

final WarbandBloc warbandBloc = WarbandBloc();
const DismissDirection _dismissDirection = DismissDirection.horizontal;

// Filter
class ImportAlliance {
  late int id = allianceChooser(alliance);
  Map<int, String> name = {
    1: "Grand Alliance of Order",
    2: "Cities of Sigmar",
    3: "Grand Alliance of Chaos",
    4: "Grand Alliance of Death",
    5: "Grand Alliance of Destruction"
  };
  int allianceChooser(String alliance) {
    switch (alliance) {
      case "Grand Alliance of Order":
        id = 1;
        break;
      case "Cities of Sigmar":
        id = 2;
        break;
      case "Grand Alliance of Chaos":
        id = 3;
        break;
      case "Grand Alliance of Death":
        id = 4;
        break;
      default:
        id = 5;
        break;
    }

    return id;
  }
}

class WarbandWidgets {
  mainWarbandsBar(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Row(children: [
          Container(
            height: 100,
            width: screenWidth * 0.15,
            color: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 32,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
              height: 100, 
              width: screenWidth * 0.55, 
              color: Colors.black
            ),
          Container(
              height: 100,
              width: screenWidth * 0.15,
              color: Colors.black,
              child: IconButton(
                icon: const Icon(Icons.search),
                iconSize: 32,
                color: Colors.white,
                onPressed: (() {
                  _showWarbandSearchSheet(context, importAlliance.id);
                }),
              )),
          Container(
              height: 100,
              width: screenWidth * 0.15,
              color: Colors.black,
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: 32,
                color: Colors.white,
                onPressed: (() {
                  _showAddWarbandSheet(context);
                }),
              )),
        ]));
  }

  Widget getWarbandCardWidget(int id) {
    int idFaction;
    return FutureBuilder(
        future: warbandDao.getWarbandsByIdAlliance(id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isNotEmpty
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, itemPosition) {
                      Warband warband = snapshot.data![itemPosition];
                      final Widget dismissibleCard = Dismissible(
                          background: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                          ),
                          onDismissed: (direction) {
                            warbandBloc.deleteWarband(warband.id_faction!);
                          },
                          direction: _dismissDirection,
                          key: ObjectKey(warband),
                          child: Card(
                              elevation: 5,
                              child: InkWell(
                                child: SizedBox(
                                  height: 100,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16),
                                                child: Text(
                                                  "${snapshot.data![itemPosition].warband}",
                                                  style: const TextStyle(
                                                      fontSize: 19),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16),
                                                child: Text(
                                                  "${snapshot.data![itemPosition].alliance}",
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                                onTap: () {
                                  idFaction = snapshot.data[itemPosition].id_faction;
                                  _showUpdateWarbandSheet(context, idFaction);
                                },
                              )));
                      return dismissibleCard;
                    },
                  )
                : Center(
                    child: noTodoMessageWidget(),
                  );
          } else {
            return Center(
              child: loadingData(),
            );
          }
        });
  }

  void _showAddWarbandSheet(BuildContext context) {
    final warbansNameFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: warbansNameFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Creat new Warband',
                                  labelText: 'Warband name',
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 28,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  size: 32,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  var newWarband = Warband(
                                      id: importAlliance.id,
                                      warband: warbansNameFormController.value.text,
                                      alliance: importAlliance.name[importAlliance.id]
                                      );
                                  if (newWarband.warband != null) {
                                    warbandBloc.addWarband(newWarband);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showUpdateWarbandSheet(BuildContext context, int idFaction) {
    final warbansNameFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: warbansNameFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'Edit Warband name',
                                  labelText: 'New name',
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 28,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 32,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  var updateWarband = Warband(
                                      id: importAlliance.id,
                                      id_faction: idFaction,
                                      warband: warbansNameFormController.value.text,
                                      alliance: importAlliance.name[importAlliance.id]);
                                  if (updateWarband.warband != null) {
                                    warbandBloc.updateWarband(updateWarband, idFaction);
                                    getWarbandWidget(importAlliance.id);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showWarbandSearchSheet(BuildContext context, int idFaction) {
    final warbandSearchName = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: warbandSearchName,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for warband...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String? value) {
                                return value!.contains('@')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 28,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 32,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  warbandAPIProvider.getWarband(importAlliance.id);
                                  warbandBloc.deleteWarbandByNameNotEqual(
                                      warbandSearchName.value.text
                                    );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getWarbandWidget(int id) {
    return StreamBuilder(
        stream: warbandBloc.warbands,
        builder: (context, snapshot) {
          return getWarbandCardWidget(id);
        });
  }

  Widget loadingData() {
    //pull todos again
    warbandBloc.getWarbands();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text("Loading...",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return const Center(
        child: SizedBox(
      height: 256,
      width: 256,
      child: Image(
        image: AssetImage('assets/images/warhammer.png'),
      ),
    ));
  }

  dispose() {
    /*close the stream in order
  to avoid memory leaks
  */
    warbandBloc.dispose();
  }
}
