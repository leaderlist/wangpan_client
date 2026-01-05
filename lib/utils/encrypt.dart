import 'dart:convert'; // 用于字符串转字节
import 'dart:typed_data'; // 处理字节数据
import 'package:crypto/crypto.dart'; // SHA256 核心类

/// 对字符串进行 SHA256 加密，返回十六进制结果
String sha256Encrypt(String input) {
  // 1. 将字符串转为 UTF-8 字节数组（加密的核心是处理字节）
  List<int> bytes = utf8.encode(input);
  
  // 2. 计算 SHA256 哈希值（返回 Digest 类型）
  Digest digest = sha256.convert(bytes);
  
  // 3. 转为十六进制字符串（常用格式，如 64 位小写字符串）
  String result = digest.toString();
  // 或手动转十六进制（等效）：hex.encode(digest.bytes)
  
  return result;
}