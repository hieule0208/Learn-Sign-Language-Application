import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/login/sub_pages/login_email/controller/login_email_controller.dart'
    show LoginEmailController;
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';
import 'package:how_to_use_provider/widgets/text_form_field_custom.dart';

class LoginEmail extends StatefulHookConsumerWidget {
  const LoginEmail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginEmailState();
}

class _LoginEmailState extends ConsumerState<LoginEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          flexibleSpace: Center(
            child: Image.asset("lib/assets/image/gestura_logo.png"),
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
                    (value) => LoginEmailController.validateEmail(value!),
                    false,
                    _emailController,
                  ),
                  SizedBox(height: 20),
                  TextFormFieldCustom(
                    "Mật khẩu",
                    "Mật khẩu",
                    (value) => LoginEmailController.validatePassword(value!),
                    true,
                    _passwordController,
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButtonCustom(
                      "Đăng nhập",
                      () => LoginEmailController().loginEmail(
                        context,
                        _emailController.text,
                        _passwordController.text,
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
