import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import "package:wangpan_client/pages/home/index.dart";
import 'package:wangpan_client/pages/login/index.dart';
import 'package:wangpan_client/request/index.dart';
import 'package:wangpan_client/router/index.dart';
import 'package:wangpan_client/storage/index.dart';
import 'package:wangpan_client/store/global/index.dart';
import 'package:wangpan_client/store/login/index.dart';

void main() {
  Storage().init();
  runApp(MyApp());
  HttpUtil().init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // 1. 创建全局 key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final LoginStore loginStore = Get.put(LoginStore());
  final GlobalStore globalStore = Get.put(GlobalStore());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      builder: EasyLoading.init(),
      home: Obx(() {
        // 1. 首次加载：显示加载页（模拟 1 秒延迟，可选）
        if (loginStore.isLoading.value || !globalStore.isStorageInitialized.value) {
          print(11111);
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
        print(22222);
        // 2. 实时判断登录状态（响应式）
        return MyHomePage();
      }),
      routes: MyRouter().routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
