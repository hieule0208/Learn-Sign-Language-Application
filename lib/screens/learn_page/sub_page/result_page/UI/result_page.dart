import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/UI/infor_show.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/screens/overview/controller/overview_provider.dart';

import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';
import 'package:how_to_use_provider/widgets/error_notification.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';

class ResultPage extends StatefulHookConsumerWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final score = ref.read(amountScoreGainedProvider);
    final listResultWord = ref.read(listWordUpdatedProvider);
    final metric = ref.read(userMetricOverviewStateProvider);
    final newLearnedWord = ref.read(amountNewWordProvider);

    final postWordsState = ref.watch(postUpdatedWordsProvider);

    return postWordsState.when(
      data:
          (success) => Padding(
            padding: EdgeInsetsGeometry.only(bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Thông báo chúc mừng
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hoàn     \n     Thành",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primary,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Icon(
                        FontAwesomeIcons.circleCheck,
                        size: 80,
                        color: AppColors.learnPrimary,
                      ),
                    ),
                  ],
                ),

                // Thống kê kết quả
                Column(
                  children: [
                    InforShow("Học từ vựng", metric.wordScore, score),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: InforShow(
                            "Từ đã thành thạo",
                            metric.masteredWords,
                            ResultPageController().returnAmountNewMasteredWord(
                              listResultWord!,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: InforShow(
                            "Từ mới",
                            metric.learnedWords,
                            newLearnedWord,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Danh sách button
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonCustom(
                        "Trang chủ",
                        () => ResultPageController().routeToHomePage(
                          context,
                          ref,
                        ),
                        AppColors.background,
                        AppColors.primary,
                        20,
                        true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      error:
          (error, stack) => Center(
            child: ErrorNotification(
              onReload: ref.read(postUpdatedWordsProvider.notifier).postWords,
              onGoHome: LearnPageController(ref, context).exitLearn,
              isOverview: false,
            ),
          ),
      loading:
          () => Center(
            child: LoadingState(imagePath: "lib/assets/image/gestura_logo.png"),
          ),
    );
  }
}
