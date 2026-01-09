import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wangpan_client/constants/key.dart';
import 'package:wangpan_client/interface/login.dart';
import 'package:wangpan_client/request/index.dart';
import 'package:wangpan_client/storage/index.dart';

class LoginStore extends GetxController {
  // 登录状态
  RxBool isLogin = false.obs;
  RxString token = ''.obs;
  RxBool isLoading = false.obs;

  final HttpUtil http = HttpUtil();
  final Storage localStore = Storage(); // 本地存储

  // 登录
  void login(LoginRequestData data, { Function? loginCallback,bool syncLocal = true }) {
    isLoading.value = true;
    EasyLoading.show(
      status: "登录中...",
      maskType: EasyLoadingMaskType.black,
    );

    http.post<dynamic, dynamic>('/auth/login/hash', data: data.toMap())
        .then((result) async {
          if (result['code'] == 200) {
            print('登录成功：--${result}--$syncLocal');
            isLogin.value = true;
            token.value = result['data']!['token'];
            await Future.delayed(Duration(seconds: 1));
            print('token.value：--${token.value}');
            loginCallback?.call(result['data']);
            if (!syncLocal) return;

            // 同步本地存储
            localStore.setString(TOKEN, token.value);
          }
        }).catchError((error) {
          print('登录请求失败： --${error}');
        }).whenComplete(() {
          isLoading.value = false;
          EasyLoading.dismiss();
        });
  }

  // 获取token
  String getToken() {
    print('获取token1：--${token.value}');
    if (token.value.isEmpty) {
      String tokenValue = localStore.getString(TOKEN) ?? '';
      Future.delayed(Duration(seconds: 1), () {
        token.value = tokenValue;
      });
      return tokenValue;
    }
    print('获取token2：--${token.value}');
    return token.value;
  }

  // 登出
  void logout({ Function? logoutCallback,bool syncLocal = true }) {
    isLogin.value = false;
    token.value = '';

    if (syncLocal) {
      localStore.remove(TOKEN);
    }
    logoutCallback?.call();
    print('登出成功：--${token.value}');
  }
}