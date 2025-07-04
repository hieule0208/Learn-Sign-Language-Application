import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/models/singleton_classes/app_singleton.dart';
import 'package:how_to_use_provider/screens/setting/controller/setting_controller.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/dictionary_word_list_item.dart';

class Setting extends StatefulHookConsumerWidget {
  const Setting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  AppSingleton appSingleton = AppSingleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Cài đặt",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Sign out
            ListTile(
              onTap: ()=> SettingController().signOut(context),
              tileColor: AppColors.secondBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: Icon(FontAwesomeIcons.rightFromBracket),
              title: Text(
                "Đăng xuất",
                style: TextStyle(color: AppColors.primary),
              ),
              selectedColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
