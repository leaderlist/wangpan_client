import "package:flutter/material.dart";
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:wangpan_client/request/index.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  // 是否自动播放
  final bool autoPlay;
  // 是否网络视频
  final bool isNetVideo;

  const VideoPlayer({
    Key? key,
    required this.videoUrl,
    this.autoPlay = false,
    this.isNetVideo = true,
  });

  @override
  State<StatefulWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoController();
  }

  Future<void> _initVideoController() async {
    if (widget.isNetVideo) {
      final headers = {
        'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        // 'Referer': 'https://www.apple.com', // 填写服务器允许的Referer（如你的域名）
        'Accept':
            'video/mp4,video/webm,video/*;q=0.9,application/ogg;q=0.8,audio/*;q=0.7,*/*;q=0.5',
        'Range': 'bytes=0-',
      };
      // 方式1：播放网络视频（支持mp4/m3u8等格式）
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        httpHeaders: headers,
        // 可选：设置http头（比如带token的视频链接）
        // httpHeaders: {"Authorization": "Bearer your_token"},
      );

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.hasError) {
          debugPrint(
            '视频播放错误详情：${_videoPlayerController.value.errorDescription}',
          );
        }
      });
    } else {
      // 方式2：播放本地视频（assets/本地文件）
      // _videoPlayerController = VideoPlayerController.asset("assets/videos/test.mp4");
      // _videoPlayerController = VideoPlayerController.file(File("/sdcard/test.mp4"));
    }
    print(
      'init video controller -- ${DateTime.now().millisecondsSinceEpoch} --- url = ${widget.videoUrl}',
    );
    // 初始化控制器并加载视频
    await _videoPlayerController.initialize();
    print(
      'video controller inited -- ${DateTime.now().millisecondsSinceEpoch}',
    );

    // 2. 初始化chewie控制器（配置播放UI）
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay, // 是否自动播放
      looping: false, // 是否循环播放
      aspectRatio: _videoPlayerController.value.aspectRatio, // 视频比例（自动适配）
      // 播放控制UI配置
      customControls: CupertinoControls(
        backgroundColor: Colors.black,
        iconColor: Colors.white,
      ),
      // 全屏配置
      fullScreenByDefault: false, // 是否默认全屏
      allowedScreenSleep: false, // 播放时是否允许屏幕休眠
    );

    // 更新UI
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // 关键：释放资源，避免内存泄漏
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _videoPlayerController.value.isInitialized
        ? Chewie(controller: _chewieController!) // 渲染chewie播放器
        : const Center(child: CircularProgressIndicator()); // 加载中占位
  }
}
