import 'package:flutter/material.dart';
import 'package:how_to_use_provider/screens/sign_up/sub_page/sign_up_email/UI/sign_up_email.dart';

class SignUpController {
  void navigateToSignUpEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpEmail()),
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (Route<dynamic> route) => false,
    );
  }

  void signUpApple(BuildContext context) {
    navigateToHome(context);
  }

  void signUpGoogle(BuildContext context) {
    navigateToHome(context);
  }

  void signUpFacebook(BuildContext context) {
    navigateToHome(context);
  }
}
