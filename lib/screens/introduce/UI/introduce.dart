import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/introduce/controller/introduce_controller.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';

class Introduce extends StatefulHookConsumerWidget {
  const Introduce({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntroduceState();
}

class _IntroduceState extends ConsumerState<Introduce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Điều gì khiến Gestura khác biệt?",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 35,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      ListTileCustom(
                        FontAwesomeIcons.trophy,
                        "Ứng dụng học ngôn ngữ ký hiệu đầu tiên",
                      ),
                      ListTileCustom(
                        FontAwesomeIcons.bookOpen,
                        "Tư liệu thực tế, chất lượng",
                      ),
                      ListTileCustom(
                        FontAwesomeIcons.robot,
                        "Hỗ trợ thực hành ngôn ngữ cùng AI ",
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButtonCustom(
                          "Bắt đầu",
                          () => IntroduceController().navigateToSignUp(context),
                          Colors.white,
                          AppColors.primary,
                          20,
                          true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButtonCustom(
                            "Tôi đã có tài khoản",
                            () => IntroduceController().navigateToLogin(context),
                            AppColors.primary,
                            Colors.transparent,
                            16,
                            false,
                          ),
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

class ListTileCustom extends HookConsumerWidget {
  final IconData icon;
  final String text;
  const ListTileCustom(this.icon, this.text, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 20,),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
