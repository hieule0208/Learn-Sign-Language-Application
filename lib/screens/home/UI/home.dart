import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/main.dart';
import 'package:how_to_use_provider/screens/conversation/UI/conservation.dart';
import 'package:how_to_use_provider/screens/home/controller/home_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page3/UI/practise_page3.dart';
import 'package:how_to_use_provider/screens/overview/UI/overview.dart';
import 'package:how_to_use_provider/screens/scenario/UI/scenario.dart';
import 'package:how_to_use_provider/screens/video/UI/video.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/bottom_nav_bar_custom.dart';

class Home extends StatefulHookConsumerWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _isDictPressed = false;
  bool _isSettingPressed = false;

  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Overview(),
    const Scenario(),
    const Video(),
    const Conservation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
          decoration: BoxDecoration(),
          child: Row(
            children: [
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: AppColors.textSub),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Image.asset("lib/assets/image/vietnam_logo.png"),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isDictPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _isDictPressed = false;
              });
              HomeController().navigateToDictionary(context);
            },
            onTapCancel: () {
              setState(() {
                _isDictPressed = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: AnimatedScale(
                scale: _isDictPressed ? 0.85 : 1.0,
                duration: Duration(milliseconds: 100),
                child: Icon(
                  FontAwesomeIcons.book,
                  color: AppColors.textPrimary,
                  size: 28,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isSettingPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _isSettingPressed = false;
              });
              HomeController().navigateToSetting(context);
            },
            onTapCancel: () {
              setState(() {
                _isSettingPressed = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textPrimary, width: 2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: AnimatedScale(
                    scale: _isSettingPressed ? 0.85 : 1.0,
                    duration: Duration(milliseconds: 100),
                    child: Icon(
                      FontAwesomeIcons.gear,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBarCustom(
        onTabChange: (index) => navigateBottomBar(index),
      ),
    );
  }
}
