import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/UI/practise_page1.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page2/UI/practise_page2.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page3/UI/practise_page3.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/UI/result_page.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/study_page/UI/study_page.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:video_player/video_player.dart';

class LearnPage extends StatefulHookConsumerWidget {
  const LearnPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LearnPageState();
}

class _LearnPageState extends ConsumerState<LearnPage> {
  @override
  Widget build(BuildContext context) {
    final learnDataAsync = ref.watch(learnDataStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading:
            learnDataAsync.isNotEmpty &&
                    ref.watch(indexQuestionProvider) < learnDataAsync.length
                ? IconButton(
                  onPressed:
                      () => LearnPageController(ref, context).exitLearn(),
                  icon: const Icon(FontAwesomeIcons.arrowLeft),
                )
                : null,
        surfaceTintColor: AppColors.background,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
      ),
      body:
          learnDataAsync.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 700,
                ),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Định nghĩa Tween cho hiệu ứng scale
                  final scaleTween = Tween<double>(
                    begin: 0.95, // Widget mới bắt đầu nhỏ hơn một chút
                    end: 1.0,   // Widget mới đạt kích thước đầy đủ
                  );

                  // Định nghĩa Tween cho hiệu ứng fade
                  final fadeTween = Tween<double>(
                    begin: 0.0, // Widget mới bắt đầu trong suốt
                    end: 1.0,   // Widget mới trở nên hoàn toàn rõ
                  );

                  // Kết hợp ScaleTransition và FadeTransition cho widget mới
                  if (child.key == _buildPageContent(learnDataAsync).key) {
                    return FadeTransition(
                      opacity: fadeTween.animate(animation),
                      child: ScaleTransition(
                        scale: scaleTween.animate(animation),
                        child: child,
                      ),
                    );
                  } else {
                    // Widget cũ sẽ mờ dần và thu nhỏ
                    return FadeTransition(
                      opacity: fadeTween.animate(animation),
                      child: ScaleTransition(
                        scale: scaleTween.animate(animation),
                        child: child,
                      ),
                    );
                  }
                },
                child: _buildPageContent(learnDataAsync),
              ),
    );
  }

  Widget _buildPageContent(List<DataLearnModel> learnData) {
    final questionIndex = ref.watch(indexQuestionProvider);

    if (questionIndex >= learnData.length) {
      return const ResultPage(key: ValueKey('result_page'));
    }

    final preloadState = ref.watch(preloadStateProvider);
    final currentQuestion = learnData[questionIndex];
    final VideoPlayerController? currentController =
        preloadState.controllers[questionIndex];

    final Key uniqueKey = ValueKey(currentQuestion.word.id);

    switch (currentQuestion.type) {
      case 'study':
      case 'practise1':
      case 'practise2':
        if (currentController != null) {
          if (currentQuestion.type == 'study') {
            return StudyPage(
              key: uniqueKey,
              dataLearnModel: currentQuestion,
              videoPlayerController: currentController,
            );
          } else if (currentQuestion.type == 'practise1') {
            return PractisePage1(
              key: uniqueKey,
              dataLearnModel: currentQuestion,
              videoPlayerController: currentController,
            );
          } else {
            return PractisePage2(
              key: uniqueKey,
              dataLearnModel: currentQuestion,
              videoPlayerController: currentController,
            );
          }
        } else {
          return Center(
            key: ValueKey('loading_${currentQuestion.word.id}'),
            child: const CircularProgressIndicator(),
          );
        }

      case 'practise3':
        return PractisePage3(key: uniqueKey, dataLearnModel: currentQuestion);

      default:
        return Center(
          key: ValueKey('error_${currentQuestion.word.id}'),
          child: Text('Loại câu hỏi không hợp lệ: ${currentQuestion.type}'),
        );
    }
  }
}