import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/sign_up/controller/sign_up_controller.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/sign_in_out_button.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulHookConsumerWidget {
  const SignUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Image.asset(
                            "lib/assets/image/vietnam_logo.png",
                            width: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Việt Nam",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SignInOutButton(
                      "Đăng ký với Apple",
                      () => SignUpController().signUpApple(context),
                      Icon(FontAwesomeIcons.apple, color: Colors.white),
                      Colors.black,
                      
                    ),
                    SignInOutButton(
                      "Đăng ký với Google",
                      () => SignUpController().signUpGoogle(context),
                      Icon(
                        FontAwesomeIcons.google,
                        color: AppColors.textPrimary,
                      ),
                      AppColors.secondBackground,
                      
                    ),
                    SignInOutButton(
                      "Đăng ký với Facebook",
                      () => SignUpController().signUpFacebook(context),
                      Icon(FontAwesomeIcons.facebook, color: Colors.white),
                      Color(0xFF0866FF),
                      
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: 40,
                      child: Center(
                        child: Text(
                          "or",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SignInOutButton(
                      "Đăng ký với Email",
                      () => SignUpController().navigateToSignUpEmail(context),
                      Icon(FontAwesomeIcons.envelope, color: Colors.white),
                      AppColors.textPrimary,
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Khi đăng kí bạn đồng ý với",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: " Điều khoản sử dụng ",
                          style: TextStyle(color: Colors.blue, fontSize: 15),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = Uri.parse('https://example.com');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    print('Không thể mở URL: $url');
                                  }
                                },
                        ),
                        TextSpan(
                          text: "của chúng tôi.",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "Tìm hiểu về cách chúng tôi thu thập, sử dụng và chia sẻ dữ liệu của bạn trong ",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: "Chính sách về quyền riêng tư ",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () async {
                                  final url = Uri.parse('https://example.com');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    print('Không thể mở URL: $url');
                                  }
                                },
                        ),
                        TextSpan(
                          text: "của chúng tôi.",
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
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
