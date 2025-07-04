import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class BottomNavBarCustom extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBarCustom({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20, top: 5),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        onTabChange: (value) => onTabChange!(value),
        tabs: [
          GButton(
            icon: FontAwesomeIcons.house,
            text: "Trang chủ",
            haptic: true,
            gap: 12,
            iconActiveColor: AppColors.textPrimary,
            textColor: AppColors.textPrimary,
          ),
          GButton(
            icon: FontAwesomeIcons.peopleArrows,
            text: "Chủ đề",
            haptic: true,
            gap: 12,
            iconActiveColor: AppColors.textPrimary,
            textColor: AppColors.textPrimary,
          ),
          GButton(
            icon: FontAwesomeIcons.photoFilm,
            text: "Videos",
            haptic: true,
            gap: 12,
            iconActiveColor: AppColors.textPrimary,
            textColor: AppColors.textPrimary,
          ),
          GButton(
            icon: FontAwesomeIcons.solidComments,
            text: "Hội thoại",
            haptic: true,
            gap: 12,
            iconActiveColor: AppColors.textPrimary,
            textColor: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
