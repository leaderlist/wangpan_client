import 'package:flutter/material.dart';
import "package:wangpan_client/pages/Home/list.dart";
import "package:wangpan_client/pages/home/admin.dart";
import "package:wangpan_client/pages/home/home.dart";
import "package:wangpan_client/pages/home/mine.dart";
import "package:wangpan_client/store/user/index.dart";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserStore _userStore = UserStore();

  int _currentIndex = 0;

  final _pages = [
    const Home(),
    const ListPage(),
    const Mine(),
    if (UserStore().isAdmin())
      const Admin()
  ].cast<Widget>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 224, 228),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 32, 64, 180),
        backgroundColor: const Color.fromARGB(179, 200, 198, 198),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          const BottomNavigationBarItem(icon: Icon(Icons.list), label: "列表"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
          if (_userStore.isAdmin())
            const BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: "管理"),
        ],
      ),
    );
  }
}
