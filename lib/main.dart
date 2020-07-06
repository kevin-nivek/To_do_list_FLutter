import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/home_screen.dart';

import 'data/tarefas.dart';

void main() {
  runApp(MyApp());
}

final Color color_personal = Colors.blue;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do Lista',
      theme: ThemeData(
        backgroundColor: Colors.cyan,
        primarySwatch: color_personal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,

    );
  }
}
