import 'package:flutter/material.dart';
import "package:wangpan_client/pages/home/index.dart";
import 'package:wangpan_client/router/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      routes: MyRouter().routes,
    );
  }
}

