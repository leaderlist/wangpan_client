import 'package:flutter/material.dart';
import 'package:wangpan_client/constants/user.dart';
import 'package:wangpan_client/store/login/index.dart';
import 'package:wangpan_client/store/user/index.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  final _loginStore = LoginStore();
  final _userStore = UserStore();

  @override
  void initState() {
    super.initState();
    print('userinfo = ${_userStore.getUserInfo()}');
  }

  Widget _buildUserBox() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 201, 207, 73),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 14),
          Icon(Icons.account_circle, size: 64, color: Colors.grey),
          SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '用户名：${_userStore.getUserInfo()?['username']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '权限：  ${userRoles[_userStore.getUserInfo()?['role']![0]] ?? '游客'}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 201, 207, 73),
          width: 1,
        ),
      ),
      margin: EdgeInsets.only(top: 24),
      height: 240,
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('选项${index + 1}'),
            onTap: () {
              // TODO: 点击事件
              print('点击了选项${index + 1}');
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              _buildUserBox(),
              _buildOptionsBox(),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _loginStore.logout(logoutCallback: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    });
                  },
                  label: Text('退出登录'),
                  icon: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
