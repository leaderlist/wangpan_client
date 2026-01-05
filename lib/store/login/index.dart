import 'package:get/get.dart';
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
  void login(LoginRequestData data, { Function? loginCallback,bool syncLocal = false }) {
    isLoading.value = true;
    print('登录请求参数：--${data.toMap()}');
    http.post<dynamic, dynamic>('/auth/login/hash', data: data.toMap())
        .then((result) async {
          print('登录请求结果：--${result}');
          if (result['code'] == 200) {
            isLogin.value = true;
            token.value = result['data']!['token'];
            await Future.delayed(Duration(seconds: 2));
            loginCallback?.call(result['data']);
            print('登录成功：--${token.value}--and syncLocal: $syncLocal');
            if (!syncLocal) return;

            // 同步本地存储
            localStore.setString('token', token.value);
          }
        }).catchError((error) {
          print('登录请求失败： --${error}');
        }).whenComplete(() {
          isLoading.value = false;
        });
  }

  // 获取token
  String getToken() {
    print('获取token：--${token.value}');
    if (token.value.isEmpty) {
      token.value = localStore.getString('token') ?? '';
    }
    print('获取token：--${token.value}');
    return token.value;
  }

  // 登出
  void logout({ Function? logoutCallback,bool syncLocal = false }) {
    isLogin.value = false;
    token.value = '';

    if (syncLocal) {
      localStore.remove('token');
    }
    logoutCallback?.call();
    print('登出成功：--${token.value}');
  }
}