import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  // 1. 核心数据源（初始加载10条）
  List<int> _dataList = List.generate(10, (index) => index);
  // 加载状态控制
  bool _isLoading = false; // 是否正在加载
  bool _hasMore = true; // 是否还有更多数据（模拟分页，比如最多加载50条）
  int _page = 1; // 当前页码

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // 监听应用切换到前台的动作
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this); // 移除监听器
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      // 应用从后台切换到前台时，重新加载页面数据
      print(222222);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 60 &&
        !_isLoading &&
        _hasMore) {
      // 滑动到底部时加载更多
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    // todo, 加载更多
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // 模拟网络请求延迟（1秒）
      await Future.delayed(const Duration(seconds: 1));

      // 模拟分页数据：每次加载10条，最多加载50条
      int newPage = _page + 1;
      int start = _page * 10;
      int end = newPage * 10;

      // 模拟“没有更多数据”的场景（加载到50条后停止）
      if (end > 50) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      // 生成新数据并追加到数据源
      List<int> newData = List.generate(10, (index) => start + index);
      setState(() {
        _dataList.addAll(newData); // 追加数据
        _page = newPage; // 更新页码
        _isLoading = false; // 加载完成
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 请求失败，上报埋点
    }
  }

  Widget _renderContent() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Text(
                "推荐资源",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(134, 104, 38, 38),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                itemCount: _dataList.length + (_isLoading ? 1 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  if (index == _dataList.length) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    int item = _dataList[index];
                    return Container(
                      color: Colors.blue[100 + (item % 9) * 100],
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // todo, 点击事件
                          print('点击了 $item');
                          Navigator.pushNamed(context, '/preview', arguments: { 'id': item });
                        },
                        child: Center(
                          child: Text(
                            '$item',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 42,
                child: TextField(
                  style: TextStyle(fontSize: 14, height: 1.0),
                  decoration: InputDecoration(
                    hintText: "请输入网盘链接或关键字",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  onSubmitted: (value) {
                    // todo, 输入完成后切换到搜索结果页（该页面也带搜索框）
                    print(value);
                  },
                ),
              ),
              _renderContent(),
            ],
          ),
        ),
      ),
    );
  }
}
