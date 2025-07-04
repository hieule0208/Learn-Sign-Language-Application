import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:how_to_use_provider/screens/login/sub_pages/login_email/UI/login_email.dart';

class LoginController {
  void NavigateToLoginEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginEmail()),
    );
  }
}
