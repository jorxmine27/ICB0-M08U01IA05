import 'package:todo_database/builder/warband_builder.dart';
import 'package:todo_database/providers/warband_api_provider.dart';
import 'package:flutter/material.dart';

var allianceId = ImportAlliance();
var warbandAPIProvider = WarbandApiProvider();
var warbandWidgets = WarbandWidgets();
var icon = const Icon(Icons.settings_input_antenna_sharp, size: 32);

class WarbandPage extends StatefulWidget {
  const WarbandPage({Key? key, required String title}) : super(key: key);

  @override
  _WarbandPage createState() => _WarbandPage();
}

class _WarbandPage extends State<WarbandPage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: warbandWidgets.mainWarbandsBar(context),
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : warbandWidgets.getWarbandCardWidget(allianceId.id),
        floatingActionButton: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: (() async {
                  _loadFromApi(importAlliance.id);
                }),
                child: icon)));
  }

  _loadFromApi(warbandFilter) async {
    setState(() {
      isLoading = true;
    });

    await warbandAPIProvider.getWarband(warbandFilter);

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }
}
