import 'package:flutter/material.dart';
import 'package:todo_database/model/alliance.dart';
import 'package:todo_database/database/database.dart';
import 'package:todo_database/ui/warband_page.dart';
import 'package:todo_database/builder/warband_builder.dart';

final Alliance alliance = Alliance();
final DatabaseProvider databaseProvider = DatabaseProvider();

mainHomePageBar(BuildContext context) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Warcry API",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ));
}

createAllianceList(BuildContext context) {
  int id;
  double screenWidth = MediaQuery.of(context).size.width;
  String allianceName;
  return FutureBuilder(
    future: databaseProvider.getAllAlliance(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              child: InkWell(
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: screenWidth * 0.70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Center(
                                        child: Text(
                                          snapshot.data[index].name,
                                          style: const TextStyle(fontSize: 19),
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text(
                                      "It has ${snapshot.data[index].warbands} warbands",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              225, 150, 150, 150)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: screenWidth * 0.25,
                          child: IconButton(
                            icon: Image(
                              image: AssetImage(snapshot.data[index].icon),
                              height: 64,
                              width: 64,
                            ),
                            onPressed: () {
                              allianceId.id = importAlliance.allianceChooser(snapshot.data[index].name);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WarbandPage(
                                            title: 'Warband view',
                                          )));
                            },
                          ),
                        )
                      ],
                    ))
                  ],
                )),
              ),
            );
          },
        );
      }
    },
  );
}