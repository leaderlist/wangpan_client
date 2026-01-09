import "package:flutter/material.dart";
import "package:wangpan_client/components/fs_view/util.dart";
import "package:wangpan_client/constants/file.dart";

class FSView extends StatelessWidget {
  final MyFileType fileType;
  final String? filePath;

  const FSView({super.key, required this.fileType, required this.filePath});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsetsGeometry.all(14),
        child: filePath == null ? null : getRenderer(fileType, filePath!),
      ),
    );
  }
}
