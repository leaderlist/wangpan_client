import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:wangpan_client/pages/home/index.dart";
import 'package:wangpan_client/pages/login/index.dart';
import 'package:wangpan_client/request/index.dart';
import 'package:wangpan_client/router/index.dart';
import 'package:wangpan_client/storage/index.dart';
import 'package:wangpan_client/components/MessengerService/index.dart';
import 'package:wangpan_client/store/login/index.dart';

void main() {
  runApp(MyApp());
  initApp(); // 初始化
}

void initApp () async {
  Storage().init();
  HttpUtil().init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final LoginStore loginStore = Get.put(LoginStore());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      scaffoldMessengerKey: MessengerService.messengerKey,
      home: Obx(() {
        // 1. 首次加载：显示加载页（模拟 1 秒延迟，可选）
        if (loginStore.isLoading.value) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text("加载中......")
                ],
              ),
            ),
          );
        }

        // 2. 实时判断登录状态（响应式）
        return loginStore.getToken().isNotEmpty ? MyHomePage() : MyLoginPage();
      }),
      routes: MyRouter().routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
