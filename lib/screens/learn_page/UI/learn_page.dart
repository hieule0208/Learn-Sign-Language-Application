import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/UI/practise_page1.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page2/UI/practise_page2.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/UI/result_page.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
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
    final learnDataAsync = ref.watch(learnDataProvider);
    final questionIndex = ref.watch(indexQuestionProvider);

    return learnDataAsync.when(
      data: (dataLearnList) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Cập nhật số lượng từ mới
          ref
              .read(amountNewWordProvider.notifier)
              .set(
                LearnPageController(
                  ref,
                  context,
                ).returnNumberNewWord(dataLearnList),
              );
          // Cập nhật câu hỏi hiện tại và tải trước controller
          if (questionIndex < dataLearnList.length) {
            ref
                .read(questionProvider.notifier)
                .set(dataLearnList[questionIndex]);
          }
        });

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading:
                questionIndex >= dataLearnList.length
                    ? null
                    : IconButton(
                      onPressed:
                          () => LearnPageController(ref, context).exitLearn(),
                      icon: const Icon(FontAwesomeIcons.arrowLeft),
                    ),
            surfaceTintColor: AppColors.background,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              Expanded(
                child:
                    questionIndex < dataLearnList.length
                        ? _buildContent(dataLearnList[questionIndex])
                        : const ResultPage(),
              ),
            ],
          ),
        );
      },
      loading:
          () => const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stack) => Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Lỗi: $error')),
          ),
    );
  }

  Widget _buildContent(
    DataLearnModel data,
  ) {
    switch (data.type) {
      case 'study':
        return StudyPage(dataLearnModel: data);
      case 'practise1':
        return PractisePage1(dataLearnModel: data);
      case 'practise2':
        return PractisePage2(dataLearnModel: data);
      default:
        return Center(child: Text('Loại câu hỏi không hợp lệ: ${data.type}'));
    }
  }
}
