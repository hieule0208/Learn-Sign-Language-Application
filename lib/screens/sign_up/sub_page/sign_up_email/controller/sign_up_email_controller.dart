import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'
    show
        CircularProgressIndicator,
        Navigator,
        ScaffoldMessenger,
        SnackBar,
        showDialog;
import 'package:flutter/widgets.dart';
import 'package:how_to_use_provider/models/singleton_classes/app_singleton.dart';

class SignUpEmailController {
  AppSingleton appSingleton = AppSingleton();

  static String? validateEmail(String value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    // Biểu thức chính quy để kiểm tra định dạng email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length <= 8) {
      return 'Mật khẩu phải dài hơn 8 ký tự';
    }
    // Kiểm tra chữ hoa
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một chữ hoa';
    }
    // Kiểm tra chữ thường
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một chữ thường';
    }
    // Kiểm tra số
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một số';
    }
    // Kiểm tra ký tự đặc biệt
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt';
    }
    return null;
  }

  static String? validateAgainPassword(String value, String password) {
    if (value != password) {
      return ("Chưa trùng khớp với mật khẩu");
    }
    return null;
  }

  Future<void> signUpEmail(
    BuildContext context,
    String email,
    String password,
    String againPassword,
  ) async {
    if (validateEmail(email) == null &&
        validatePassword(password) == null &&
        validateAgainPassword(againPassword, password) == null) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        Navigator.of(context).pop(); // Đóng dialog loading

        await credential.user?.sendEmailVerification();
        appSingleton.setUserId(FirebaseAuth.instance.currentUser?.uid);
        appSingleton.setLoginStatus(true);
        
        navigateToHome(context);
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Đóng dialog loading
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'Mật khẩu quá yếu.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Email đã được sử dụng.';
        } else {
          errorMessage = 'Đã có lỗi xảy ra: ${e.message}';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        Navigator.of(context).pop(); // Đóng dialog loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi không xác định: $e')));
      }
    }
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (Route<dynamic> route) => false,
    );
  }
}
