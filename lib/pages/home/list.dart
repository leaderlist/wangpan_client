import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:wangpan_client/components/path_navigator/index.dart';
import 'package:wangpan_client/constants/file.dart';
import 'package:wangpan_client/constants/icon.dart';
import 'package:wangpan_client/interface/fs.dart';
import 'package:wangpan_client/router/index.dart';
import 'package:wangpan_client/store/fs/index.dart';
import 'package:wangpan_client/utils/file.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListState();
}

class _ListState extends State<ListPage> {
  late FsStore _fsStore;
  int pageCount = 1;
  int pageSize = 0;

  late ScrollController _scrollController; // 添加滚动控制器

  List<FsContent> pathList = [];
  FsContent? currentPath;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // 初始化滚动控制器

    _fsStore = Get.put(FsStore(), permanent: true);
    if (!_fsStore.hasFsListData()) {
      _fsStore.getFsList(
        data: {
          "path": "/",
          "password": "",
          "page": pageCount,
          "per_page": pageSize,
          "refresh": false,
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 释放滚动控制器
    super.dispose();
  }

  Future<void> _handlePathItemTap(FsContent path) async {
    List<FsContent> copyPathList = List.from(pathList);
    if (path.is_dir) {
      Map<String, dynamic> data = {
        'page': pageCount,
        'per_page': pageSize,
        'refresh': false,
        'password': '',
      };
      FsContent? copyPath = currentPath;

      if (path.is_dir) {
        copyPathList.add(path);
        copyPath = path;
        data['path'] = '/${copyPathList.map((e) => e.name).join('/')}';
      }

      bool shouldRefresh = await _fsStore.getFsList(data: data);
      if (shouldRefresh) {
        _scrollController.animateTo( // 添加滚动重置
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          pathList = copyPathList;
          currentPath = copyPath;
        });
      }
    } else {
      // 点击文件，支持文件预览
      String filePath = '/${copyPathList.map((e) => e.name).join('/')}/${path.name}';
      bool result =  await _fsStore.getFileData(
        data: {'path': filePath, 'password': ''},
      );

      if (!result) return;
      
      if (mounted) {
        Navigator.pushNamed(context, MyRouter.file_view);
      }
    }
  }

  Future<void> _handlePathTap(FsContent? path) async {
    if (path != null && !path.is_dir) {
      // 点击文件，支持文件预览
      Fluttertoast.showToast(msg: '点击了文件,暂不支持预览～');
      return;
    }
    Map<String, dynamic> data = {
      'page': pageCount,
      'per_page': pageSize,
      'refresh': false,
      'password': '',
    };
    List<FsContent> copyPathList = List.from(pathList);
    FsContent? prePath = currentPath;
    currentPath = path;
    if (path == null) {
      copyPathList.clear();
      data['path'] = '/';
    } else {
      // 点击了路径
      int index = copyPathList.indexOf(path);
      if (index == -1) {
        Fluttertoast.showToast(msg: '路径不存在');
        return;
      }
      FsContent item = copyPathList[index];
      if (item.is_dir) {
        copyPathList.removeRange(index + 1, copyPathList.length);
        data['path'] = copyPathList.map((e) => e.name).join('/');
      } else {
        Fluttertoast.showToast(msg: '路径不存在');
        return;
      }
    }

    bool shouldRefresh = await _fsStore.getFsList(data: data);
    if (shouldRefresh) {
      _scrollController.animateTo( // 添加滚动重置
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        pathList = copyPathList;
      });
    } else {
      setState(() {
        currentPath = prePath;
      });
    }
  }

  Widget _buildContent() {
    int length = _fsStore.fsListResData.value!.content.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(12),
        border: BoxBorder.all(color: Colors.grey),
      ),
      child: ListView.builder(
        itemCount: length,
        shrinkWrap: true, // 让ListView根据内容自适应高度
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController, // 添加控制器
        itemBuilder: (context, index) {
          int itemType = _fsStore.fsListResData.value!.content[index].type;
          String itemTypeStr = getFileType(_fsStore.fsListResData.value!.content[index].name);
          MyFileType fileType = FileTypeExtension.fromExtension(itemTypeStr, sourceType: itemType);
          bool isDir = _fsStore.fsListResData.value!.content[index].is_dir;
          return Container(
            decoration: BoxDecoration(
              border: index != 0
                  ? Border(top: BorderSide(color: Colors.grey))
                  : null,
            ),
            height: 56,
            child: ListTile(
              title: Row(
                children: [
                  Icon(isDir ? Icons.folder : fileType.defaultIcon, color: file_icon_color,),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _fsStore.fsListResData.value!.content[index].name,
                      style: TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              onTap: () {
                _handlePathItemTap(
                  _fsStore.fsListResData.value!.content[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_fsStore.fsListResData.value != null &&
                    _fsStore.fsListResData.value!.content.isNotEmpty)
                  FilePathNavigator(
                    paths: pathList,
                    currentPath: currentPath,
                    onPathTap: _handlePathTap,
                  ),
                SizedBox(height: 24),
                Flexible(
                  child: _fsStore.fsListResData.value?.content != null
                      ? _buildContent()
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
