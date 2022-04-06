import 'package:flutter/material.dart';
import 'package:playreversi/pages/game.dart';
import 'package:playreversi/pages/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayReversi',
      theme: ThemeData(
        primarySwatch: Colors.green,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      home: const WelcomePage(),
    );
  }
}

