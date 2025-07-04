import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/sign_up/sub_page/sign_up_email/controller/sign_up_email_controller.dart';
import 'package:how_to_use_provider/screens/sign_up/sub_page/sign_up_email/controller/sign_up_email_provider.dart';

import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';
import 'package:how_to_use_provider/widgets/text_form_field_custom.dart';

class SignUpEmail extends StatefulHookConsumerWidget {
  const SignUpEmail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends ConsumerState<SignUpEmail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            child: Center(
              child: Image.asset("lib/assets/image/gestura_logo.png"),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextFormFieldCustom(
                    "Email",
                    "Email",
                    (value) => SignUpEmailController.validateEmail(value!),
                    false,
                    _emailController,
                  ),
                  SizedBox(height: 20),
                  TextFormFieldCustom(
                    "Mật khẩu",
                    "Mật khẩu",
                    (value) => SignUpEmailController.validatePassword(value!),
                    true,
                    _passwordController,
                  ),
                  SizedBox(height: 20),
                  TextFormFieldCustom(
                    "Nhập lại mật khẩu",
                    "Nhập lại mật khẩu",
                    (value) => SignUpEmailController.validateAgainPassword(
                      value!,
                      _passwordController.text,
                    ),
                    true,
                    _passwordAgainController,
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButtonCustom(
                      "Đăng kí tài khoản",
                      () => SignUpEmailController().signUpEmail(
                        context,
                        _emailController.text,
                        _passwordController.text,
                        _passwordAgainController.text,
                      ),
                      AppColors.secondBackground,
                      AppColors.textPrimary,
                      16,
                      true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
