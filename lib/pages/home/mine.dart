import 'package:flutter/material.dart';
import 'package:wangpan_client/store/login/index.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  final _loginStore = LoginStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ElevatedButton(onPressed: () {
        _loginStore.logout(syncLocal: true, logoutCallback: () {
          // 退出登录
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        });
      }, child: Text('退出登录')))
    );
  }
}