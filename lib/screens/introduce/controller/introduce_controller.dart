import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IntroduceController {
  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, "/sign_up");
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }
}
