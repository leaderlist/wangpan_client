import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wangpan_client/request/index.dart';

class PDFPlayer extends StatefulWidget {
  final String pdfUrl;
  final bool isAsset;

  const PDFPlayer({super.key, required this.pdfUrl, this.isAsset = false});

  @override
  State<PDFPlayer> createState() => _PDFPlayerState();
}

class _PDFPlayerState extends State<PDFPlayer> {
  final Completer<PDFViewController> _pdfController = Completer();
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = true;
  String _localPdfPath = ""; // 本地PDF路径（网络PDF下载后存储）

  late HttpUtil http = HttpUtil();

  @override
  void initState() {
    super.initState();
    _initPdfPath();
  }

  /// 初始化PDF路径（处理网络PDF/Assets PDF）
  Future<void> _initPdfPath() async {
    try {
      if (widget.isAsset) {
        // 处理Assets中的PDF（需要先复制到本地）
        final byteData = await DefaultAssetBundle.of(context).load(widget.pdfUrl);
        final file = File('${(await getTemporaryDirectory()).path}/temp.pdf');
        await file.writeAsBytes(byteData.buffer.asUint8List());
        _localPdfPath = file.path;
      } else if (widget.pdfUrl.startsWith('http')) {
        // 处理网络PDF（先下载到本地）
        _localPdfPath = await _downloadPdf(widget.pdfUrl);
      } else {
        // 本地文件路径
        _localPdfPath = widget.pdfUrl;
      }
      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF加载失败：$e')),
          );
        });
      }
    }
  }

  /// 下载网络PDF到本地临时目录
  Future<String> _downloadPdf(String url) async {
     // 1. 如果是分享链接，先获取真实的下载链接（复用你的getDirectUrl方法）
    String? realUrl = await HttpUtil.getDirectUrl(url);
    realUrl ??= url;

    // 2. 获取临时目录
    final tempDir = await getTemporaryDirectory();
    final pdfFile = File('${tempDir.path}/downloaded_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
    
    // 3. 使用Dio下载文件（避免文件名重复）
    await HttpUtil().dio.download(
      realUrl,
      pdfFile.path,
      // 可选：添加下载进度监听
      onReceiveProgress: (received, total) {
        if (total != -1) {
          double progress = received / total;
          if (kDebugMode) {
            print('PDF下载进度：${(progress * 100).toStringAsFixed(1)}%');
          }
        }
      },
      // 禁用重定向（如果需要自定义处理）
      options: Options(
        followRedirects: true, // 根据你的需求调整
        responseType: ResponseType.stream,
      ),
    );

    return pdfFile.path;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildPdfView(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// 构建PDF视图
  Widget _buildPdfView() {
    return PDFView(
      filePath: _localPdfPath,
      enableSwipe: true, // 允许滑动翻页
      swipeHorizontal: false, // 垂直滑动（true为水平）
      autoSpacing: true,
      pageFling: true, // 快速翻页
      pageSnap: true, // 页面吸附
      defaultPage: 0, // 默认显示第1页（索引从0开始）
      fitPolicy: FitPolicy.WIDTH, // 按宽度适配
      preventLinkNavigation: false, // 允许点击PDF中的链接
      onRender: (pages) {
        // PDF渲染完成回调
        setState(() {
          _totalPages = pages ?? 0;
        });
      },
      onError: (error) {
        // 渲染错误回调
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF渲染错误：$error')),
        );
      },
      onPageError: (page, error) {
        // 单页渲染错误
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('第$page页渲染错误：$error')),
        );
      },
      onViewCreated: (controller) {
        // PDF控制器创建完成
        _pdfController.complete(controller);
      },
      onPageChanged: (page, total) {
        // 页面切换回调
        setState(() {
          _currentPage = page ?? 0;
        });
      },
    );
  }

  /// 构建底部页码栏
  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _gotoPreviousPage,
            disabledColor: Colors.grey,
          ),
          Text('第 ${_currentPage + 1} 页 / 共 $_totalPages 页'),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _gotoNextPage,
            disabledColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  /// 上一页
  Future<void> _gotoPreviousPage() async {
    if (_currentPage <= 0) return;
    final controller = await _pdfController.future;
    controller.setPage(_currentPage - 1);
  }

  /// 下一页
  Future<void> _gotoNextPage() async {
    if (_currentPage >= _totalPages - 1) return;
    final controller = await _pdfController.future;
    controller.setPage(_currentPage + 1);
  }

  /// 显示页码跳转弹窗
  Future<void> _showPageJumpDialog() async {
    final textController = TextEditingController(
      text: (_currentPage + 1).toString(),
    );
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('跳转到指定页码'),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '输入1-$_totalPages之间的数字',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final page = int.tryParse(textController.text) ?? 1;
              if (page < 1 || page > _totalPages) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('页码超出范围')),
                );
                return;
              }
              final controller = await _pdfController.future;
              controller.setPage(page - 1); // 索引从0开始
              if (mounted) Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}