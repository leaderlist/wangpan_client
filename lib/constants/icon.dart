import 'package:flutter/material.dart';

const file_icon_color = Color.fromARGB(255, 24, 144, 255);

enum FileType {
  folder,
  image,
  video,
  audio,
  pdf,
  txt,
}

class FileTypeUtil {
  // 枚举 → 数值
  static const Map<FileType, int> enumToInt = {
    FileType.pdf: 0,
    FileType.folder: 1,
    FileType.video: 2,
    FileType.audio: 3,
    FileType.txt: 4,
    FileType.image: 5, // 可能只是.jpg
  };

  // 数值 → 枚举
  static const Map<int, FileType> intToEnum = {
    0: FileType.pdf,
    1: FileType.folder,
    2: FileType.video,
    3: FileType.audio,
    4: FileType.txt,
    5: FileType.image,
  };

  // 数值 -> icon
  static const Map<int, Icon> intToIcon = {
    0: Icon(Icons.insert_drive_file, color: file_icon_color),
    1: Icon(Icons.folder, color: file_icon_color),
    2: Icon(Icons.videocam, color: file_icon_color),
    3: Icon(Icons.music_note, color: file_icon_color),
    4: Icon(Icons.description, color: file_icon_color),
    5: Icon(Icons.image, color: file_icon_color),
  };
}

Map<FileType, Icon> iconMap = {
  FileType.folder: Icon(Icons.folder, color: file_icon_color),
  FileType.image: Icon(Icons.image, color: file_icon_color),
  FileType.video: Icon(Icons.videocam, color: file_icon_color),
  FileType.audio: Icon(Icons.music_note, color: file_icon_color),
  FileType.pdf: Icon(Icons.insert_drive_file, color: file_icon_color),
  FileType.txt: Icon(Icons.description, color: file_icon_color),
};