import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:wangpan_client/components/fs_view/index.dart";

import "package:wangpan_client/constants/file.dart";
import "package:wangpan_client/interface/fs.dart";
import "package:wangpan_client/store/fs/index.dart";
import "package:wangpan_client/utils/file.dart";

class MyFileViewPage extends StatefulWidget {
  const MyFileViewPage({super.key});

  @override
  State<MyFileViewPage> createState() => _FileViewState();
}

class _FileViewState extends State<MyFileViewPage> {
  // MyFileType? _fileType;
  // String? _filePath;

  late FsStore _fsStore;

  @override
  void initState() {
    super.initState();

    _fsStore = Get.put(FsStore());

    // 延迟读取参数（initState中直接读会报错）
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // var paramsJson = Get.arguments as Map<String, dynamic>;
      // var filePath = FileViewRouterParams.fromJson(paramsJson);
      // setState(() {
      //   _filePath = filePath;
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fsStore.clearFileData(); // 清除文件数据
    Get.delete<FsStore>();
  }

  @override
  Widget build(BuildContext context) {
    GetFsDataResponse? filedata = _fsStore.fileData.value;
    MyFileType fileType = FileTypeExtension.fromExtension(getFileType(filedata?.name));
    String? filePath = filedata?.raw_url;

    return GetBuilder<FsStore>(
      init: _fsStore,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    filedata?.name ?? "",
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: fileType != MyFileType.unknown && filePath != null
              ? FSView(
                  fileType: fileType,
                  filePath: filePath,
                )
              : CircularProgressIndicator(),
        );
      },
    );
  }
}
