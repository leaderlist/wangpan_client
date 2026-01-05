import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wangpan_client/components/MessengerService/index.dart';
import 'package:fluttertoast/fluttertoast.dart';

Map<String, String> _resErrorMsgMap = {
  'password is incorrect': '密码错误',
};

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  HttpUtil._internal();

  late Dio dio;
  final CancelToken _cancelToken = CancelToken();

  // 初始化
  void init({
    String baseUrl = 'http://0.0.0.0:5244/api',
    int connectTimeout = 15000,
    int receiveTimeout = 15000,
    List<Interceptor>? interceptors,
  }) {
    print(_instance);
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 添加默认拦截器
    dio.interceptors.addAll([
      // 请求拦截器
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 在这里可以添加token等公共参数
          // options.headers['Authorization'] = 'Bearer $token';
          if (kDebugMode) {
            print('请求url: ${options.uri}');
            print('请求头: ${options.headers}');
            print('请求参数: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('响应数据111: ${response.data}');
          }

          late String msg;

          print('response.statusCode---${response.statusCode}---response.data---${response.data}');
          try {
          if (response.data.containsKey('code')) {
            switch (response.data['code']) {
              case 200:
                break;
              case 400:
                msg = _resErrorMsgMap[response.data['message']] ?? response.data['message'];
              case 429:
                msg = '请求过于频繁,请稍后重试！';
              default:
                msg = '未知错误';
            }
          }
          print('msg---$msg');

          if (msg != null) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('这是一个消息提示'),
            //     duration: Duration(seconds: 2),
            //     backgroundColor: Colors.blue,
            //   ),
            // );
            // MessengerService.showError(msg);
            Fluttertoast.showToast(
              msg: msg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
          } catch (e) {
            print('e---$e');
          }

          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('请求错误: ${error.message}');
          }
          // 统一错误处理
          handleError(error);
          handler.next(error);
        },
      ),
      // 自定义拦截器
      ...interceptors ?? [],
    ]);
  }

  // 错误处理
  void handleError(DioError error) {
    // switch (error.type) {
    //   case DioErrorType.connectionTimeout:
    //     throw Exception('连接超时');
    //   case DioErrorType.sendTimeout:
    //     throw Exception('请求超时');
    //   case DioErrorType.receiveTimeout:
    //     throw Exception('响应超时');
    //   case DioErrorType.badResponse:
    //     final statusCode = error.response?.statusCode;
    //     switch (statusCode) {
    //       case 400:
    //         throw Exception('请求语法错误');
    //       case 401:
    //         throw Exception('没有权限');
    //       case 403:
    //         throw Exception('服务器拒绝执行');
    //       case 404:
    //         throw Exception('无法连接服务器');
    //       case 405:
    //         throw Exception('请求方法被禁止');
    //       case 500:
    //         throw Exception('服务器内部错误');
    //       case 502:
    //         throw Exception('无效的网关');
    //       case 503:
    //         throw Exception('服务不可用');
    //       case 504:
    //         throw Exception('网关超时');
    //       default:
    //         throw Exception('未知错误');
    //     }
    //   case DioErrorType.cancel:
    //     throw Exception('请求取消');
    //   case DioErrorType.unknown:
    //     throw Exception('网络异常');
    //   default:
    //     throw Exception('未知错误');
    // }
    print("error---$error");
  }

  // GET请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }

  // POST请求
  Future<T> post<T, D>(
    String path, {
    D? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }

  // PUT请求
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE请求
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: _cancelToken,
      );
      return response.data!;
    } catch (e) {
      rethrow;
    }
  }

  // 取消所有请求
  void cancelAllRequests() {
    _cancelToken.cancel('取消所有请求');
  }
}
