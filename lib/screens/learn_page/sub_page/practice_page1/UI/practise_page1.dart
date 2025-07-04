import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/answer_card.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/controller/practise_page1_provider.dart';
import 'package:how_to_use_provider/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class PractisePage1 extends ConsumerStatefulWidget {
  final DataLearnModel dataLearnModel;

  PractisePage1({
    super.key,
    required this.dataLearnModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PractisePage1State();
}

class _PractisePage1State extends ConsumerState<PractisePage1> {
  @override
  Widget build(BuildContext context) {
    final answerChosen = ref.watch(answerQuestionChosenProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          VideoPlayerWidget(
            videoPath: widget.dataLearnModel.mainContent,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              crossAxisSpacing: 30,
              children: [
                AnswerCard(
                  widget.dataLearnModel.answers![0],
                  () => LearnPageController(
                    ref,
                    context,
                  ).onContinue(widget.dataLearnModel),
                ),
                AnswerCard(
                  widget.dataLearnModel.answers![1],
                  () => LearnPageController(
                    ref,
                    context,
                  ).onContinue(widget.dataLearnModel),
                ),
                AnswerCard(
                  widget.dataLearnModel.answers![2],
                  () => LearnPageController(
                    ref,
                    context,
                  ).onContinue(widget.dataLearnModel),
                ),
                AnswerCard(
                  widget.dataLearnModel.answers![3],
                  () => LearnPageController(
                    ref,
                    context,
                  ).onContinue(widget.dataLearnModel),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
