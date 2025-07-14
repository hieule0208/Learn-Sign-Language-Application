import 'package:flutter/material.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class ErrorNotification extends StatelessWidget {
  final VoidCallback onReload; // Callback cho nút "Tải lại"
  final VoidCallback onGoHome; // Callback cho nút "Về trang chủ"
  final bool isOverview;

  const ErrorNotification({
    super.key,
    required this.onReload,
    required this.onGoHome,
    required this.isOverview,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: const Text(
        'Lỗi mạng',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      content: Text(
        'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng và thử lại.',
        style: TextStyle(color: AppColors.textSub, fontSize: 16.0),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onReload(); // Thực thi callback "Tải lại"
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            backgroundColor: AppColors.secondBackground,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
          ),
          child: const Text('Tải lại', style: TextStyle(fontSize: 16.0)),
        ),
        isOverview ? ElevatedButton(
          onPressed: () {
            onGoHome(); // Thực thi callback "Về trang chủ"
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textPrimary,
            foregroundColor: AppColors.secondBackground,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Về trang chủ', style: TextStyle(fontSize: 16.0)),
        ) : Container(),
      ],
    );
  }
}
