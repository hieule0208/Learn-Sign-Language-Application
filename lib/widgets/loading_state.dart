import 'package:flutter/material.dart';

class LoadingState extends StatefulWidget {
  final String imagePath; // Đường dẫn tới ảnh trong assets
  final double size; // Kích thước ảnh (chiều rộng và chiều cao)
  final Duration duration; // Thời gian một chu kỳ animation
  final double bounceHeight; // Độ cao nhấp nhô

  const LoadingState({
    super.key,
    required this.imagePath,
    this.size = 100.0,
    this.duration = const Duration(milliseconds: 800),
    this.bounceHeight = 20.0,
  });

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Khởi tạo AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true); // Lặp lại và đảo chiều

    // Tạo animation nhấp nhô
    _animation = Tween<double>(begin: 0, end: widget.bounceHeight)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_animation.value), // Di chuyển ảnh lên xuống
            child: Image.asset(
              widget.imagePath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}