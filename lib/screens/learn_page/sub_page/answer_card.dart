

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/controller/practise_page1_provider.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class AnswerCard extends HookConsumerWidget {
  final void Function() onPressed;
  final String answerTitle;
  const AnswerCard(this.answerTitle, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChosen = ref.watch(answerQuestionChosenProvider) == answerTitle;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isChosen ? 10 : 20),
            blurRadius: isChosen ? 2 : 8,
            offset: Offset(0, isChosen ? 1 : 4),
          ),
        ],
      ),
      child: Material(
        color: stateColor(
          ref.watch(questionProvider)?.word.word,
          ref.watch(answerQuestionChosenProvider),
          answerTitle,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.primary, width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              ref.watch(answerQuestionChosenProvider) != null
                  ? null
                  : () {
                    ref
                        .read(answerQuestionChosenProvider.notifier)
                        .setAnswer(answerTitle);
                    Future.delayed(const Duration(seconds: 2), () {
                      onPressed();
                    });
                  },
          splashColor: Colors.grey.withAlpha(30),
          // ignore: avoid_unnecessary_containers
          child: Container(child: Center(child: Text(answerTitle))),
        ),
      ),
    );
  }
}

Color? stateColor(String? correctAnswer, String? chosenAnswer, String currentAnswer) {
  if (chosenAnswer == null) {
    // No answer chosen yet, use default color
    return AppColors.secondBackground;
  }
  if (currentAnswer == correctAnswer) {
    // Always highlight the correct answer in green
    return AppColors.learnPrimary;
  }
  if (currentAnswer == chosenAnswer && chosenAnswer != correctAnswer) {
    // Highlight the chosen wrong answer in red
    return AppColors.watchPrimary;
  }
  // All other answers use default color
  return AppColors.secondBackground;
}
