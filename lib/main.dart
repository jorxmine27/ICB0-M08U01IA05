import 'package:flutter/material.dart';
import 'package:todo_database/ui/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reactive Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        backgroundColor: Colors.white70
      ),
      //Our only screen/page we have
      home: const HomePage(title: 'Warcry API'),
    );
  }
}
