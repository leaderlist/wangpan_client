import "dart:convert";
import "package:get/get.dart";
import 'package:dio/dio.dart';

import "package:wangpan_client/request/index.dart";
import "package:wangpan_client/storage/index.dart";
import "package:wangpan_client/store/login/index.dart";
import "package:wangpan_client/interface/user.dart";
import "package:wangpan_client/constants/key.dart";

class UserStore extends GetxController {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal();

  // 用户信息
  final Rx<UserResponseData?> _userInfo = Rx<UserResponseData?>(null);

  HttpUtil http = HttpUtil();
  LoginStore loginStore = Get.put(LoginStore());
  final Storage localStore = Storage(); // 本地存储

  // 设置用户信息
  void setUserInfo(UserResponseData data) {
    _userInfo.value = data;
  }

  // 清除用户信息
  void clearUserInfo() {
    _userInfo.value = null;
    localStore.remove(USER_INFO);
  }

  Map<String, dynamic>? getUserInfo() {
    if (_userInfo.value == null) {
      String userInfoString = localStore.getString(USER_INFO) ?? '';
      return userInfoString == '' ? null : jsonDecode(userInfoString);
    } else {
      return _userInfo.value!.toJson();
    }
  }

  bool isAdmin () {
    return getUserInfo()?['role'].contains(2);
  }

  Future<dynamic> fetchUserInfo() async {
    String token = loginStore.getToken();
    final { 'code': code, 'data': data, 'message': msg } = await http.get<Map<String, dynamic>>('/me', options: Options(
      headers: {
        'Authorization': token,
      }
    ));
    if (code == 200 && data != null && data is Map<String, dynamic>) {
      localStore.setString(USER_INFO, jsonEncode(data));
      setUserInfo(UserResponseData.fromJson(data));
    }
  }
}