import 'package:flutter/material.dart';
// import "package:wangpan_client/pages/home.dart";
import 'package:wangpan_client/pages/preview/index.dart';
import 'package:wangpan_client/pages/login/index.dart';
import 'package:wangpan_client/pages/file_view/index.dart';

class MyRouter {
  Map<String, Widget Function(BuildContext)> routes =
    // {
    //   '/home': (context) => const MyHomePage(),
    // },
    {
      '/preview': (context) => const MyPreviewPage(),
      '/login': (context) => const MyLoginPage(),
      '/file_view': (context) => const MyFileViewPage(),
    };

  MyRouter();

  static const String home = '/';
  static const String preview = '/preview';
  static const String login = '/login';
  static const String file_view = '/file_view';
}

