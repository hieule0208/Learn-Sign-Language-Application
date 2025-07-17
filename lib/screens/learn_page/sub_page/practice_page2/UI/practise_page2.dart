import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/answer_chip.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page2/controller/practise_page2_provider.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';
import 'package:how_to_use_provider/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class PractisePage2 extends StatefulHookConsumerWidget {
  final VideoPlayerController videoPlayerController;
  final DataLearnModel dataLearnModel;

  const PractisePage2({
    super.key,
    required this.videoPlayerController,
    required this.dataLearnModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PractisePage2State();
}

class _PractisePage2State extends ConsumerState<PractisePage2> {
 
  final TextEditingController _textFieldController = TextEditingController();
  List<String> listAnswer = [];

  @override
  Widget build(BuildContext context) {
    _textFieldController.text = ref.watch(answerQuestionSelectedProvider);
    listAnswer = ref.watch(questionProvider)?.answers ?? [];
    if (!listAnswer.contains(" ")) listAnswer.add(" ");
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              VideoPlayerWidget(
                videoPlayerController: widget.videoPlayerController,
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textFieldController,
                        onChanged: (value) {
                          ref
                              .read(answerQuestionSelectedProvider.notifier)
                              .setText(_textFieldController.text);
                        },
                        decoration: InputDecoration(border: InputBorder.none),
                        onSubmitted:
                            (value) => LearnPageController(
                              ref,
                              context,
                            ).onContinue(widget.dataLearnModel),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons
                            .deleteLeft, // Use Icons.backspace for delete left
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        final text = _textFieldController.text;
                        if (text.isNotEmpty) {
                          final newText = text.substring(0, text.length - 1);
                          _textFieldController.text = newText;
                          _textFieldController
                              .selection = TextSelection.fromPosition(
                            TextPosition(offset: newText.length),
                          );
                          ref
                              .read(answerQuestionSelectedProvider.notifier)
                              .setText(newText);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    listAnswer.map((String answer) {
                      return AnswerChip(
                        answer,
                        () => ref
                            .read(answerQuestionSelectedProvider.notifier)
                            .setAnswer(answer),
                      );
                    }).toList(),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButtonCustom(
                "Tiếp tục",
                () => LearnPageController(
                  ref,
                  context,
                ).onContinue(widget.dataLearnModel),
                AppColors.background,
                AppColors.primary,
                20,
                true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
