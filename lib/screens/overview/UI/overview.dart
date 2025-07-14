import "dart:async";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/overview/controller/overview_controller.dart';
import 'package:how_to_use_provider/screens/overview/controller/overview_provider.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/error_notification.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';
import 'package:how_to_use_provider/widgets/over_view_info_card.dart';
import 'package:how_to_use_provider/widgets/over_view_slider_item.dart';

class Overview extends StatefulHookConsumerWidget {
  const Overview({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OverviewState();
}

class _OverviewState extends ConsumerState<Overview> {
  int _selectedIndex = 0;
  bool _isPressed = false;
  bool _isTimeOut = false;
  Timer? _timer;

  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _startTimer(); // Khởi động timer trong initState
  }

  // Hàm khởi động timer
  void _startTimer() {
    _timer?.cancel(); // Hủy timer cũ nếu đang chạy
    _timer = Timer(const Duration(seconds: 7), () {
      if (!mounted) return;
      final metric = ref.read(userMetricOverviewStateProvider);
      if (metric.currentTopic == "") {
        setState(() {
          _isTimeOut = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi widget dispose
    super.dispose();
  }

  void changeSelectedCard(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final metric = ref.watch(userMetricOverviewStateProvider);

    int totalScore = metric.totalScore;
    int level = OverviewController().getCurrentLevelInfo(totalScore)["level"];

    int scoreNextLevel =
        OverviewController().getCurrentLevelInfo(totalScore)["nextLevelScore"];
    String rank = OverviewController().getCurrentLevelInfo(totalScore)["title"];

    if (metric.currentTopic == "") {
      return Center(
        child:
            _isTimeOut
                ? ErrorNotification(
                  onReload: () {
                    ref
                        .read(userMetricOverviewStateProvider.notifier)
                        .initialize();
                    setState(() {
                      _isTimeOut = false;
                      _startTimer();
                    });
                  },
                  onGoHome: () {},
                  isOverview: false,
                )
                : LoadingState(
                  imagePath: "lib/assets/image/gestura_logo.png",
                  size: 150,
                ),
      );
    } else {
      return Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/image/home-background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _isPressed = false;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                _isPressed
                                    ? Colors.grey[200]
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(left: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Danh hiệu
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidFlag,
                                    size: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    rank,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                              //Level
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Việt Nam - Level",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.textPrimary,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      level.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //Exp
                              SizedBox(height: 10),
                              SizedBox(
                                width: 200,
                                child: LinearProgressIndicator(
                                  value: totalScore / scoreNextLevel,
                                  minHeight: 10,
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.textPrimary,
                                  backgroundColor: Colors.grey[350],
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Text(
                                      "To level ${level + 1}",
                                      style: TextStyle(
                                        color: AppColors.textSub,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${OverviewController().formatNumber(totalScore)}/${OverviewController().formatNumber(scoreNextLevel)}",
                                      style: TextStyle(
                                        color: AppColors.textSub,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(90), // Màu bóng
                          spreadRadius: 0, // Độ lan của bóng
                          blurRadius: 16, // Độ mờ của bóng
                          offset: Offset(
                            0,
                            0,
                          ), // Độ dịch chuyển của bóng (x, y)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // Score
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Điểm của tôi",
                                style: TextStyle(
                                  color: AppColors.secondBackground,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${OverviewController().formatNumber(totalScore)} điểm",
                                style: TextStyle(
                                  color: AppColors.secondBackground,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              OverViewInfoCard(
                                Icon(
                                  FontAwesomeIcons.peopleArrows,
                                  color: AppColors.learnPrimary,
                                  size: 20,
                                ),
                                OverviewController().formatNumber(
                                  metric.wordScore,
                                ),
                                "Học từ vựng",
                                "Từ thành thạo",
                                "Từ bắt đầu học",
                                OverviewController().formatNumber(
                                  metric.masteredWords,
                                ),
                                OverviewController().formatNumber(
                                  metric.learnedWords,
                                ),
                                0,
                                () {
                                  changeSelectedCard(0);
                                  _carouselSliderController.animateToPage(
                                    0,
                                    duration: Durations.medium1,
                                    curve: Curves.ease,
                                  );
                                },
                                _selectedIndex,
                                AppColors.learnBackground,
                                AppColors.background,
                              ),
                              OverViewInfoCard(
                                Icon(
                                  FontAwesomeIcons.photoFilm,
                                  color: AppColors.watchPrimary,
                                  size: 20,
                                ),
                                OverviewController().formatNumber(
                                  metric.videoScore,
                                ),
                                "Xem từ vựng",
                                "Video đã xem",
                                "Đã xem lại",
                                OverviewController().formatNumber(
                                  metric.masteredVideos,
                                ),
                                OverviewController().formatNumber(
                                  metric.learnedVideos,
                                ),
                                1,
                                () {
                                  changeSelectedCard(1);
                                  _carouselSliderController.animateToPage(
                                    1,
                                    duration: Durations.medium1,
                                    curve: Curves.ease,
                                  );
                                },
                                _selectedIndex,
                                AppColors.watchBackground,
                                AppColors.background,
                              ),
                              OverViewInfoCard(
                                Icon(
                                  FontAwesomeIcons.solidComments,
                                  color: AppColors.aiPrimary,
                                  size: 20,
                                ),
                                OverviewController().formatNumber(
                                  metric.practiseScore,
                                ),
                                "Dùng từ vựng",
                                "Hội thoại đã hoàn thành",
                                "Đã luyện tập lại",
                                OverviewController().formatNumber(
                                  metric.masteredConversation,
                                ),
                                OverviewController().formatNumber(
                                  metric.learnedConversation,
                                ),
                                2,
                                () {
                                  changeSelectedCard(2);
                                  _carouselSliderController.animateToPage(
                                    2,
                                    duration: Durations.medium1,
                                    curve: Curves.ease,
                                  );
                                },
                                _selectedIndex,
                                AppColors.aiBackground,
                                AppColors.background,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //slide
              CarouselSlider(
                carouselController: _carouselSliderController,
                items: [
                  OverViewSliderItem(
                    Icon(
                      FontAwesomeIcons.peopleArrows,
                      color: AppColors.learnPrimary,
                    ),
                    "Học từ vựng",
                    "Tiếp tục: ${metric.currentTopic}",
                    "Bắt đầu",
                    () => OverviewController().navigateToLearnPage(context),
                    AppColors.learnBackground,
                    AppColors.learnPrimary,
                  ),
                  OverViewSliderItem(
                    Icon(
                      FontAwesomeIcons.photoFilm,
                      color: AppColors.watchPrimary,
                    ),
                    "Xem từ vựng",
                    null,
                    "Bắt đầu",
                    () => {},
                    AppColors.watchBackground,
                    AppColors.watchPrimary,
                  ),
                  OverViewSliderItem(
                    Icon(
                      FontAwesomeIcons.solidComments,
                      color: AppColors.aiPrimary,
                    ),
                    "Dùng từ vựng",
                    null,
                    "Bắt đầu",
                    () => {},
                    AppColors.aiBackground,
                    AppColors.aiPrimary,
                  ),
                ],
                options: CarouselOptions(
                  height: 80,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    changeSelectedCard(index);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
