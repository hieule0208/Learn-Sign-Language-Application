import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerWidget({
    super.key,
    required this.videoPlayerController,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      // Đảm bảo controller đã được khởi tạo trước khi sử dụng
      if (!widget.videoPlayerController.value.isInitialized) {
        await widget.videoPlayerController.initialize();
      }
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: widget.videoPlayerController,
          autoPlay: false, // Không tự động phát
          looping: false, // Không lặp lại
          aspectRatio: widget.videoPlayerController.value.aspectRatio,
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
    // Chỉ dispose ChewieController, không dispose VideoPlayerController
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized && _chewieController != null
        ? AspectRatio(
            aspectRatio: widget.videoPlayerController.value.isInitialized
                ? widget.videoPlayerController.value.aspectRatio
                : 16 / 9,
            child: Chewie(controller: _chewieController!),
          )
        : AspectRatio(
            aspectRatio: 16 / 9,
            child: const Center(child: CircularProgressIndicator()),
          );
  }
}