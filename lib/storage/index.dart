
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:wangpan_client/store/global/index.dart';

class Storage {
  static final Storage _instance = Storage._internal();
  factory Storage() => _instance;
  Storage._internal();

  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    final globalStore = Get.put(GlobalStore());
    _sharedPreferences = await SharedPreferences.getInstance();
    globalStore.changeStorageInitialized(true);
  }

  Future<bool> setString(String key, String value) async {
    return await _sharedPreferences.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _sharedPreferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _sharedPreferences.setInt(key, value);
  }

  int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _sharedPreferences.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _sharedPreferences.getDouble(key);
  }

  Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  Future<bool> clear() async {
    return await _sharedPreferences.clear();
  }

  Future<bool> containsKey(String key) async {
    return _sharedPreferences.containsKey(key);
  }
}