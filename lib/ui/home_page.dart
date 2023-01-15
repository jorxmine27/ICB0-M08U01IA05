import 'package:todo_database/builder/alliance_builder.dart';
import 'package:todo_database/database/database.dart';
import 'package:todo_database/providers/alliance_api_provider.dart';
import 'package:flutter/material.dart';

var allianceAPIProvider = AllianceApiProvider();
var databaseProvider = DatabaseProvider();

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: mainHomePageBar(context),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : createAllianceList(context),
        floatingActionButton: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: (() async {
                  await _loadFromApi();
                }),
                child: const Icon(
                  Icons.settings_input_antenna_sharp,
                  size: 32,
                ))));
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    await allianceAPIProvider.getAllAlliances();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }
}
