import 'package:flutter/material.dart';

/// 覆盖主流文件类型的枚举
enum MyFileType {
  // ========== 文档类 ==========
  doc, // Word 文档
  docx, // Word 文档（新版）
  txt, // 纯文本
  pdf, // PDF 文档
  xls, // Excel 表格
  xlsx, // Excel 表格（新版）
  ppt, // PPT 演示
  pptx, // PPT 演示（新版）
  csv, // 逗号分隔值
  json, // JSON 配置
  xml, // XML 配置
  md, // Markdown 文档
  rtf, // 富文本
  pages, // Mac 文档
  numbers, // Mac 表格
  keynote, // Mac 演示

  // ========== 图片类 ==========
  jpg, // JPG 图片
  jpeg, // JPEG 图片
  png, // PNG 图片
  gif, // GIF 动图
  bmp, // BMP 图片
  tiff, // TIFF 图片
  webp, // WebP 图片
  svg, // SVG 矢量图
  ico, // 图标文件
  heic, // HEIC 图片（苹果）

  // ========== 视频类 ==========
  mp4, // MP4 视频
  avi, // AVI 视频
  mov, // MOV 视频（苹果）
  mkv, // MKV 视频
  flv, // FLV 视频
  wmv, // WMV 视频
  webm, // WebM 视频
  m4v, // M4V 视频
  t_s, // TS 视频
  mpeg, // MPEG 视频
  mpg, // MPG 视频

  // ========== 音频类 ==========
  mp3, // MP3 音频
  wav, // WAV 音频
  flac, // FLAC 无损音频
  aac, // AAC 音频
  m4a, // M4A 音频
  ogg, // OGG 音频
  wma, // WMA 音频
  amr, // AMR 音频

  // ========== 压缩包类 ==========
  zip, // ZIP 压缩包
  rar, // RAR 压缩包
  sevenZ, // 7Z 压缩包
  tar, // TAR 压缩包
  gz, // GZ 压缩包
  bz2, // BZ2 压缩包
  iso, // ISO 镜像
  dmg, // DMG 镜像（Mac）

  // ========== 代码类 ==========
  js, // JavaScript
  ts, // TypeScript
  html, // HTML
  css, // CSS
  dart, // Dart
  java, // Java
  kotlin, // Kotlin
  swift, // Swift
  c, // C
  cpp, // C++
  cs, // C#
  py, // Python
  php, // PHP
  go, // Go
  rb, // Ruby
  sh, // Shell
  bat, // Bat 脚本
  sql, // SQL

  // ========== 安装包/可执行文件 ==========
  exe, // Windows 可执行文件
  msi, // Windows 安装包
  apk, // Android 安装包
  ipa, // iOS 安装包
  dll, // Windows 动态库
  so, // Linux/Mac 动态库
  app, // Mac 应用
  deb, // Debian 安装包
  rpm, // RPM 安装包

  // ========== 字体类 ==========
  ttf, // TTF 字体
  otf, // OTF 字体
  woff, // WOFF 字体
  woff2, // WOFF2 字体

  // ========== 数据库类 ==========
  db, // 通用数据库
  sqlite, // SQLite
  mysql, // MySQL 备份
  postgres, // PostgreSQL 备份

  // ========== 其他/未知 ==========
  unknown, // 未知文件类型
}

/// 枚举扩展：提供实用方法
extension FileTypeExtension on MyFileType {
  /// 1. 根据文件扩展名（如 "jpg"、"pdf"）匹配对应的枚举值
  static MyFileType fromExtension(String? extension, {int sourceType = 0}) {
    if (extension == null || extension.isEmpty) {
      return MyFileType.unknown;
    }
    // 统一转为小写，避免大小写问题
    final String lowerExt = extension.toLowerCase();
    try {
      // 直接通过扩展名匹配枚举
      return MyFileType.values.firstWhere(
        (type) {
          if (lowerExt == '7z') {
            return type.name == 'sevenz';
          } else if (lowerExt == 'ts') {
            return sourceType == 0 ? type.name == 't_s' : type.name == 'ts';
          } else {
            return type.name == lowerExt;
          }
        },
        // 匹配不到则返回未知类型
        orElse: () => MyFileType.unknown,
      );
    } catch (e) {
      return MyFileType.unknown;
    }
  }

  /// 2. 获取文件类型的中文描述（便于UI展示）
  String get chineseDescription {
    switch (this) {
      // 文档类
      case MyFileType.doc:
      case MyFileType.docx:
        return "Word 文档";
      case MyFileType.txt:
        return "纯文本文件";
      case MyFileType.pdf:
        return "PDF 文档";
      case MyFileType.xls:
      case MyFileType.xlsx:
        return "Excel 表格";
      case MyFileType.ppt:
      case MyFileType.pptx:
        return "PPT 演示文稿";
      case MyFileType.csv:
        return "CSV 表格";
      case MyFileType.json:
        return "JSON 配置文件";
      case MyFileType.xml:
        return "XML 配置文件";
      case MyFileType.md:
        return "Markdown 文档";
      case MyFileType.rtf:
        return "富文本文件";
      case MyFileType.pages:
        return "Pages 文档";
      case MyFileType.numbers:
        return "Numbers 表格";
      case MyFileType.keynote:
        return "Keynote 演示文稿";

      // 图片类
      case MyFileType.jpg:
      case MyFileType.jpeg:
      case MyFileType.png:
      case MyFileType.gif:
      case MyFileType.bmp:
      case MyFileType.tiff:
      case MyFileType.webp:
      case MyFileType.heic:
        return "图片文件";
      case MyFileType.svg:
        return "SVG 矢量图";
      case MyFileType.ico:
        return "图标文件";

      // 视频类
      case MyFileType.mp4:
      case MyFileType.avi:
      case MyFileType.mov:
      case MyFileType.mkv:
      case MyFileType.flv:
      case MyFileType.wmv:
      case MyFileType.webm:
      case MyFileType.m4v:
      case MyFileType.t_s:
      case MyFileType.mpeg:
      case MyFileType.mpg:
        return "视频文件";

      // 音频类
      case MyFileType.mp3:
      case MyFileType.wav:
      case MyFileType.flac:
      case MyFileType.aac:
      case MyFileType.m4a:
      case MyFileType.ogg:
      case MyFileType.wma:
      case MyFileType.amr:
        return "音频文件";

      // 压缩包类
      case MyFileType.zip:
      case MyFileType.rar:
      case MyFileType.sevenZ:
      case MyFileType.tar:
      case MyFileType.gz:
      case MyFileType.bz2:
        return "压缩包文件";
      case MyFileType.iso:
      case MyFileType.dmg:
        return "镜像文件";

      // 代码类
      case MyFileType.js:
      case MyFileType.ts:
      case MyFileType.html:
      case MyFileType.css:
      case MyFileType.dart:
      case MyFileType.java:
      case MyFileType.kotlin:
      case MyFileType.swift:
      case MyFileType.c:
      case MyFileType.cpp:
      case MyFileType.cs:
      case MyFileType.py:
      case MyFileType.php:
      case MyFileType.go:
      case MyFileType.rb:
      case MyFileType.sh:
      case MyFileType.bat:
      case MyFileType.sql:
        return "代码文件";

      // 安装包/可执行文件
      case MyFileType.exe:
        return "Windows 可执行文件";
      case MyFileType.msi:
        return "Windows 安装包";
      case MyFileType.apk:
        return "Android 安装包";
      case MyFileType.ipa:
        return "iOS 安装包";
      case MyFileType.dll:
        return "Windows 动态库";
      case MyFileType.so:
        return "Linux/Mac 动态库";
      case MyFileType.app:
        return "Mac 应用程序";
      case MyFileType.deb:
        return "Debian 安装包";
      case MyFileType.rpm:
        return "RPM 安装包";

      // 字体类
      case MyFileType.ttf:
      case MyFileType.otf:
      case MyFileType.woff:
      case MyFileType.woff2:
        return "字体文件";

      // 数据库类
      case MyFileType.db:
      case MyFileType.sqlite:
      case MyFileType.mysql:
      case MyFileType.postgres:
        return "数据库文件";

      // 未知类型
      case MyFileType.unknown:
        return "未知文件类型";
    }
  }

  /// 3. 获取文件类型对应的默认图标（Flutter 内置图标，便于UI展示）
  IconData get defaultIcon {
    switch (this) {
      // 文档类
      case MyFileType.doc:
      case MyFileType.docx:
      case MyFileType.rtf:
        return Icons.description;
      case MyFileType.txt:
        return Icons.text_snippet;
      case MyFileType.pdf:
        return Icons.picture_as_pdf;
      case MyFileType.xls:
      case MyFileType.xlsx:
      case MyFileType.csv:
        return Icons.table_chart;
      case MyFileType.ppt:
      case MyFileType.pptx:
        return Icons.slideshow;
      case MyFileType.json:
      case MyFileType.xml:
      case MyFileType.md:
        return Icons.code;
      case MyFileType.pages:
        return Icons.document_scanner;
      case MyFileType.numbers:
        return Icons.table_chart;
      case MyFileType.keynote:
        return Icons.slideshow;

      // 图片类

      // 图片类
      case MyFileType.jpg:
      case MyFileType.jpeg:
      case MyFileType.png:
      case MyFileType.gif:
      case MyFileType.bmp:
      case MyFileType.tiff:
      case MyFileType.webp:
      case MyFileType.heic:
      case MyFileType.svg:
        return Icons.image;
      case MyFileType.ico:
        return Icons.insert_emoticon;

      // 视频类
      case MyFileType.mp4:
      case MyFileType.avi:
      case MyFileType.mov:
      case MyFileType.mkv:
      case MyFileType.flv:
      case MyFileType.wmv:
      case MyFileType.webm:
      case MyFileType.m4v:
      case MyFileType.t_s:
      case MyFileType.mpeg:
      case MyFileType.mpg:
        return Icons.video_library;

      // 音频类
      case MyFileType.mp3:
      case MyFileType.wav:
      case MyFileType.flac:
      case MyFileType.aac:
      case MyFileType.m4a:
      case MyFileType.ogg:
      case MyFileType.wma:
      case MyFileType.amr:
        return Icons.audio_file;

      // 压缩包类
      case MyFileType.zip:
      case MyFileType.rar:
      case MyFileType.sevenZ:
      case MyFileType.tar:
      case MyFileType.gz:
      case MyFileType.bz2:
      case MyFileType.iso:
      case MyFileType.dmg:
        return Icons.archive;

      // 代码类
      case MyFileType.js:
      case MyFileType.ts:
      case MyFileType.html:
      case MyFileType.css:
      case MyFileType.dart:
      case MyFileType.java:
      case MyFileType.kotlin:
      case MyFileType.swift:
      case MyFileType.c:
      case MyFileType.cpp:
      case MyFileType.cs:
      case MyFileType.py:
      case MyFileType.php:
      case MyFileType.go:
      case MyFileType.rb:
      case MyFileType.sh:
      case MyFileType.bat:
      case MyFileType.sql:
        return Icons.code;

      // 安装包/可执行文件
      case MyFileType.exe:
      case MyFileType.msi:
      case MyFileType.apk:
      case MyFileType.ipa:
      case MyFileType.deb:
      case MyFileType.rpm:
        return Icons.install_desktop;
      case MyFileType.dll:
      case MyFileType.so:
        return Icons.build;
      case MyFileType.app:
        return Icons.apps;

      // 字体类
      case MyFileType.ttf:
      case MyFileType.otf:
      case MyFileType.woff:
      case MyFileType.woff2:
        return Icons.font_download;

      // 数据库类
      case MyFileType.db:
      case MyFileType.sqlite:
      case MyFileType.mysql:
      case MyFileType.postgres:
        return Icons.storage;

      // 未知类型
      case MyFileType.unknown:
        return Icons.insert_drive_file;
    }
  }
}
