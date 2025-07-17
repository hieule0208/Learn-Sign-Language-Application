import 'package:flutter/material.dart';
import 'package:how_to_use_provider/screens/login/sub_pages/login_email/UI/login_email.dart';

class LoginController {
  void navigateToLoginEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginEmail()),
    );
  }
}
