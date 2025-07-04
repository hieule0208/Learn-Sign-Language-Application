import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:how_to_use_provider/screens/dictionary/controller/dict_controller.dart';
import 'package:how_to_use_provider/screens/dictionary/controller/dict_provider.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/dictionary_word_list.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';

class Dictionary extends StatefulHookConsumerWidget {
  const Dictionary({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DictionaryState();
}

class _DictionaryState extends ConsumerState<Dictionary> {
  int _selectedIndex = 0;

  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  void changeListViewIndex(index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dictData = ref.watch(dictDataProvider);

    return dictData.when(
      data: (dictData) {

        final masteredList = DictController().categorizeWords(dictData)["masteredList"];
        final learnedList = DictController().categorizeWords(dictData)["learnedList"];
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(220),
            child: Stack(
              children: [
                Container(
                  height: 250,
                  padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  decoration: BoxDecoration(color: AppColors.primary),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        FontAwesomeIcons.book,
                        color: AppColors.background,
                        size: 90,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //button
                      GestureDetector(
                        onTap: () => DictController().navigateToHome(context),
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.secondBackground,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Icon(FontAwesomeIcons.arrowLeft),
                        ),
                      ),
                      //title
                      SizedBox(height: 20),
                      Text(
                        "Từ vựng của tôi",
                        style: TextStyle(
                          color: AppColors.secondBackground,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //info
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Đã hoàn thành",
                                  style: TextStyle(
                                    color: AppColors.secondBackground,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  masteredList!.length.toString(),
                                  style: TextStyle(
                                    color: AppColors.secondBackground,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bắt đầu học",
                                  style: TextStyle(
                                    color: AppColors.secondBackground,
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),

                                Text(
                                  learnedList!.length.toString(),
                                  style: TextStyle(
                                    color: AppColors.secondBackground,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
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
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(height: 15),
                //tab control
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeListViewIndex(0);
                          _carouselSliderController.animateToPage(
                            0,
                            duration: Durations.medium1,
                            curve: Curves.ease,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    _selectedIndex == 0
                                        ? AppColors.textPrimary
                                        : Colors.transparent,
                                width: _selectedIndex == 0 ? 3.0 : 0.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Đã thành thạo",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeListViewIndex(1);
                          _carouselSliderController.animateToPage(
                            1,
                            duration: Durations.medium1,
                            curve: Curves.ease,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    _selectedIndex == 1
                                        ? AppColors.textPrimary
                                        : Colors.transparent,
                                width: _selectedIndex == 1 ? 3.0 : 0.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Bắt đầu học",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: CarouselSlider(
                    carouselController: _carouselSliderController,
                    items: [
                      DictionaryWordList(masteredList, 0),
                      DictionaryWordList(learnedList, 1),
                    ],
                    options: CarouselOptions(
                      height: double.infinity,

                      initialPage: 0,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        changeListViewIndex(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButtonCustom(
                    "Ôn tập",
                    () {},
                    AppColors.secondBackground,
                    AppColors.primary,
                    23,
                    true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      loading: () => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
