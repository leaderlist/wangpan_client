import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderFlex;
import 'package:wangpan_client/interface/fs.dart';

class _FilePathNavigatorState extends State<FilePathNavigator> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  void didUpdateWidget(FilePathNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当paths长度变化时，自动滚动到最后
    if (widget.paths.length > oldWidget.paths.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildPathSegment({
    required BuildContext context,
    FsContent? path,
    required Widget label,
    bool isFirst = false,
  }) {
    bool isCurrent = path == widget.currentPath;
    return InkWell(
      onTap: () => isCurrent ? null : widget.onPathTap(path),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: label,
      ),
    );
  }

  Widget _buildSeparator() {
    return widget.separatorIcon ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Icon(
            Icons.chevron_right,
            size: 16,
            color: widget.separatorColor ?? Colors.grey,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 42,child: Scrollbar(
      controller: _scrollController,
      thickness: 6.0, // 滚动条厚度
      radius: const Radius.circular(3.0), // 滚动条圆角
      scrollbarOrientation: ScrollbarOrientation.bottom, // 滚动条位置
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 根目录
            _buildPathSegment(
              context: context,
              path: null,
              label: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: widget.currentPath == null
                        ? Color.fromARGB(255, 7, 47, 133)
                        : Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '根目录',
                    style: TextStyle(
                      color: widget.currentPath == null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              isFirst: true,
            ),
            // 其他路径段
            ...widget.paths.map((pathItem) {
              bool isCurrent = pathItem == widget.currentPath;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSeparator(),
                  _buildPathSegment(
                    context: context,
                    path: pathItem,
                    label: Text(
                      pathItem.name,
                      style:
                          widget.textStyle ??
                          TextStyle(
                            color: isCurrent
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            fontSize: 14,
                          ),
                    ),
                    // pathItem.name,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    ));
  }
}

class FilePathNavigator extends StatefulWidget {
  final List<FsContent> paths;
  final FsContent? currentPath;
  final Function(FsContent? path) onPathTap;
  final TextStyle? textStyle;
  final Color? separatorColor;
  final Widget? separatorIcon;

  const FilePathNavigator({
    super.key,
    required this.paths,
    required this.currentPath,
    required this.onPathTap,
    this.textStyle,
    this.separatorColor,
    this.separatorIcon,
  });

  @override
  State<StatefulWidget> createState() => _FilePathNavigatorState();
}
