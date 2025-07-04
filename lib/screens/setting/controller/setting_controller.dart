import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:how_to_use_provider/models/singleton_classes/app_singleton.dart';

class SettingController {
  AppSingleton appSingleton = AppSingleton();
  Future<void> signOut(BuildContext context) async {
    try {
      // Hiển thị vòng loading (tùy chọn)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Gọi phương thức đăng xuất của Firebase
      await FirebaseAuth.instance.signOut();

      // Đóng dialog loading
      Navigator.of(context).pop();

      // Cập nhật trạng thái trong AppSingleton
      appSingleton.logout();

      // Hiển thị thông báo đăng xuất thành công

      // Điều hướng về màn hình đăng nhập
      navigateToLogin(context);
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      Navigator.of(context).pop();

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi đăng xuất: $e')));
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', // Đường dẫn tới màn hình đăng nhập
      (Route<dynamic> route) => false,
    );
  }
}
