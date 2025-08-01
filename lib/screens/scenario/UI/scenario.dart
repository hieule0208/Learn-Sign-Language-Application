import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_controller.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_provider.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';
import 'package:how_to_use_provider/widgets/scenario_progress_list_tile.dart';
import 'package:how_to_use_provider/widgets/search_bar.dart';

class Scenario extends StatefulHookConsumerWidget {
  const Scenario({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScenarioState();
}

class _ScenarioState extends ConsumerState<Scenario> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  String _searchQuery = '';
  Timer? _debounce;

  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  void changeSelectedCard(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearchMasterChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _onSearchLearnChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final topicData = ref.watch(topicDataStateProvider);
    List<TopicModel>? inProgressTopics =
        ScenarioController().categorizeTopics(topicData)["inProgressTopics"];
    List<TopicModel>? exploreTopics =
        ScenarioController().categorizeTopics(topicData)["exploreTopics"];
    List<TopicModel>? finishTopics =
        ScenarioController().categorizeTopics(topicData)["finishTopics"];

    return topicData.isNotEmpty
        ? Column(
          children: [
            SizedBox(height: 10),

            // Tab bar
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
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
                          "Học từ mới",
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
                          "Luyện tập",
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
            //search bar
            SearchBarCustom(
              _searchController,
              _selectedIndex == 0
                  ? _onSearchMasterChanged
                  : _onSearchLearnChanged,
            ),
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselSliderController,
                items: [
                  //trang 1
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Progress
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Đang học",
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: inProgressTopics!.length,
                          itemBuilder: (context, index) {
                            return ScenarioProgressListTile(
                              inProgressTopics[index],
                              () => ScenarioController().goDetailTopic(
                                inProgressTopics[index],
                                context,
                                ref,
                              ),
                            );
                          },
                        ),
                        //Explore
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Khám phá",
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: exploreTopics!.length,
                          itemBuilder: (context, index) {
                            return ScenarioProgressListTile(
                              exploreTopics[index],
                              () => ScenarioController().goDetailTopic(
                                exploreTopics[index],
                                context,
                                ref,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  //Trang 2
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Ôn tập",
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: finishTopics!.length,
                          itemBuilder: (context, index) {
                            return ScenarioProgressListTile(
                              finishTopics[index],
                              () => ScenarioController().goDetailTopic(
                                finishTopics[index],
                                context,
                                ref,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: double.infinity,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    changeSelectedCard(index);
                  },
                ),
              ),
            ),
          ],
        )
        : Center(
          child: LoadingState(
            imagePath: 'lib/assets/image/gestura_logo.png',
            size: 150,
          ),
        );
  }
}
