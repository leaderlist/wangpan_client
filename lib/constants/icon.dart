import 'package:flutter/material.dart';

enum FileType {
  folder,
  image,
  video,
  audio,
  pdf,
  txt,
}

Map<FileType, Icon> iconMap = {
  FileType.folder: Icon(Icons.folder),
  FileType.image: Icon(Icons.image),
  FileType.video: Icon(Icons.videocam),
  FileType.audio: Icon(Icons.music_note),
  FileType.pdf: Icon(Icons.picture_as_pdf),
  FileType.txt: Icon(Icons.insert_drive_file),
};