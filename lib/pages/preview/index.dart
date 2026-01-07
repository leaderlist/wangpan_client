import 'package:flutter/material.dart';
import 'package:wangpan_client/constants/style.dart';

class MyPreviewPage extends StatefulWidget {
  const MyPreviewPage({super.key});

  @override
  State<MyPreviewPage> createState() => _MyPreviewPageState();
}

class _MyPreviewPageState extends State<MyPreviewPage> {
  final _scrollController = ScrollController();

  List<dynamic> _fileList = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // TODO: 滚动监听
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 60 &&
        !_isLoading &&
        _hasMore) {
      // 滑动到底部时加载更多
      _fetchData();
    }
  }

  void _fetchData() async {
    // TODO: 获取数据
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _fileList.addAll(
        List.generate(
          20,
          (index) => {"name": "${index + _fileList.length + 1}.txt"},
        ),
      );
      _isLoading = false;
      _fileList = _fileList; // 重新赋值以触发UI更新
      _hasMore = _fileList.length < 100;
    });
  }

  Widget _renderTitle() {
    return Container(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(221, 175, 186, 180),
              width: 2.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(
                  Icons.folder,
                  color: const Color.fromARGB(255, 215, 152, 34),
                  size: 48,
                ),
                Container(
                  margin: EdgeInsets.only(left: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('文件名', style: titleStyles),
                      Text('资源来源: ${'百度网盘'}', style: subtitleStyles),
                      Text(
                        '${'2026-01-04'}  过期时间: ${'30'}天后',
                        style: descriptionStyles,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _renderContent() {
    return Expanded(child: Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("全部文件"),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _fileList.length + 1,
              itemBuilder: (context, index) {
                if (index == _fileList.length && _hasMore) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text('加载中...'),
                  );
                }
                return Container(child: Text(_fileList[index]['name']));
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget _renderBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_renderTitle(), _renderContent()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(179, 154, 145, 145),
        title: Text('文件详情'),
      ),
      body: Center(child: Padding(padding: EdgeInsets.all(12), child: _renderBody(),)),
    );
  }
}
