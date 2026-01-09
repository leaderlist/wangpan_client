import 'package:flutter/material.dart';
import 'package:wangpan_client/components/fs_view/audio_view.dart';
import 'package:wangpan_client/components/fs_view/pdf_view.dart';
import 'package:wangpan_client/components/fs_view/video_view.dart';
import 'package:wangpan_client/components/fs_view/image_view.dart';
import 'package:wangpan_client/constants/file.dart';

Widget getRenderer(MyFileType type, String path) {
  switch (type) {
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
      return VideoPlayer(videoUrl: path);
    case MyFileType.jpg:
    case MyFileType.jpeg:
    case MyFileType.png:
    case MyFileType.gif:
    case MyFileType.bmp:
    case MyFileType.tiff:
    case MyFileType.webp:
    case MyFileType.heic:
      return ImagePlayer(imgUrl: path);
    case MyFileType.pdf:
      return PDFPlayer(pdfUrl: path);
    case MyFileType.mp3:
    case MyFileType.wav:
    case MyFileType.flac:
    case MyFileType.aac:
    case MyFileType.m4a:
    case MyFileType.ogg:
    case MyFileType.wma:
    case MyFileType.amr:
      return AudioPlayer(audioUrl: path);
    default:
      return Container(
        child: Text('暂不支持该文件类型'),
      );
  }
}