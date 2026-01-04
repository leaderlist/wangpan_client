import 'package:flutter/material.dart';
// import "package:wangpan_client/pages/home.dart";
import 'package:wangpan_client/pages/preview/index.dart';

class MyRouter {
  Map<String, Widget Function(BuildContext)> routes =
    // {
    //   '/home': (context) => const MyHomePage(),
    // },
    {
      '/preview': (context) => const MyPreviewPage(),
    };

  MyRouter();
}