import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool isAsset; // Xác định videoPath là asset hay network

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.isAsset = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    // Khởi tạo VideoPlayerController dựa trên loại video
    _videoPlayerController = widget.isAsset
        ? VideoPlayerController.asset(widget.videoPath)
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));

    try {
      await _videoPlayerController.initialize();
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: false, // Không tự động phát
          looping: false, // Không lặp lại
          aspectRatio: _videoPlayerController.value.aspectRatio,
          showControls: true,
          allowedScreenSleep: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                'Lỗi: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        );
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized && _chewieController != null
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}