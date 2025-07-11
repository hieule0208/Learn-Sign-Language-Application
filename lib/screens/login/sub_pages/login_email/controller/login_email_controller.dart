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

class LoginEmailController {
  AppSingleton appSingleton = AppSingleton();

  static String? validateEmail(String value) {
    if (value == null) {
      return "Phải nhập đầy đủ thông tin";
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value == null) {
      return "Phải nhập đầy đủ thông tin";
    }
    return null;
  }

  Future<void> loginEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (validateEmail(email) == null && validatePassword(password) == null) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        Navigator.of(context).pop(); // Đóng dialog loading

        await credential.user?.sendEmailVerification();

        appSingleton.setUserId(FirebaseAuth.instance.currentUser?.uid);
        appSingleton.setLoginStatus(true);
        navigateToHome(context);
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Đóng dialog loading
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'Tài khoản chưa tồn tại';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Tài khoản hoặc mật khẩu sai';
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
