import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/models/data_models/preload_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/UI/practise_page1.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page2/UI/practise_page2.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/UI/result_page.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/study_page/UI/study_page.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class LearnPage extends StatefulHookConsumerWidget {
  const LearnPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LearnPageState();
}

class _LearnPageState extends ConsumerState<LearnPage> {
  @override
  Widget build(BuildContext context) {
    final learnDataAsync = ref.watch(learnDataStateProvider);
    final questionIndex = ref.watch(indexQuestionProvider);
    final preloadVideo = ref.watch(preloadStateProvider); 
    

    return learnDataAsync.isNotEmpty && preloadVideo.controllers.isNotEmpty
        ? Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading:
                questionIndex >= learnDataAsync.length
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
                    questionIndex < learnDataAsync.length
                        ? _buildContent(learnDataAsync, preloadVideo, questionIndex)
                        : const ResultPage(),
              ),
            ],
          ),
        )
        : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildContent(List<DataLearnModel> data, PreloadModel preload, int index) {
    switch (data[index].type) {
      case 'study':
        return StudyPage(dataLearnModel: data[index], videoPlayerController: preload.controllers[index]!);
      case 'practise1':
        return PractisePage1(dataLearnModel: data[index], videoPlayerController: preload.controllers[index]!);
      case 'practise2':
        return PractisePage2(dataLearnModel: data[index], videoPlayerController: preload.controllers[index]!);
      default:
        return Center(child: Text('Loại câu hỏi không hợp lệ: ${data[index].type}'));
    }
  }
}
