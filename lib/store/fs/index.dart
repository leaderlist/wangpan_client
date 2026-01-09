import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:wangpan_client/interface/fs.dart";
import "package:wangpan_client/request/index.dart";
import "package:wangpan_client/store/login/index.dart";

class FsStore extends GetxController {
  static final FsStore _instance = FsStore._internal();
  factory FsStore() => _instance;
  FsStore._internal();

  final HttpUtil _http = HttpUtil();
  final LoginStore _loginStore = Get.put(LoginStore());

  // 文件目录（渲染当前展示目录）
  Rx<FsListResponseData?> fsListResData = Rx<FsListResponseData?>(null);
  // 当前预览文件信息
  Rx<GetFsDataResponse?> fileData = Rx<GetFsDataResponse?>(null);

  // 获取文件目录
  Future<bool> getFsList({required Map<String, dynamic> data}) async {
    try {
      final {
        'code': code as int,
        'data': resData as Map<String, dynamic>?,
      } = await _http.post<Map<String, dynamic>, Map<String, dynamic>>(
        '/fs/list',
        data: data,
        options: Options(headers: {'Authorization': _loginStore.getToken()}),
      );

      print('getFsList: $code - $resData');

      if (code == 200 && resData != null) {
        if (resData['content'] == null) {
          Fluttertoast.showToast(msg: '文件夹为空～');
          return false;
        }
        fsListResData.value = FsListResponseData.fromJson(resData);
        return true;
      }
    } catch (e) {
      print('getFsList: $e');
      return false;
    }
    return false;
  }

  bool hasFsListData() {
    return fsListResData.value != null;
  }

  Future<bool> getFileData({required Map<String, dynamic> data}) async {
    try {
      final {
        'code': code as int,
        'data': resData as Map<String, dynamic>?,
      } = await _http.post<Map<String, dynamic>, Map<String, dynamic>>(
        '/fs/get',
        data: data,
        options: Options(headers: {'Authorization': _loginStore.getToken()}),
      );

      print('getFileData: $code - $resData');
      if (code == 200 && resData != null) {
        fileData.value = GetFsDataResponse.fromJson(resData);
        print('getFileData: ${fileData.value?.toJson()}');
        return true;
      } else {
        Fluttertoast.showToast(msg: '获取文件失败');
        return false;
      }
    } catch (e) {
      print('getFileData: $e');
      return false;
    }
  }

  void clearFileData() {
    fileData.value = null;
  }

  void clearFsStore () {
    fsListResData.value = null;
    fileData.value = null;
  }
}
