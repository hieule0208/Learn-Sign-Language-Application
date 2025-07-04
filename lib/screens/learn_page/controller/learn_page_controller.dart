import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/home/UI/home.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/controller/practise_page1_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page2/controller/practise_page2_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/wrong_page/UI/wrong_page.dart';
import 'package:how_to_use_provider/screens/overview/UI/overview.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/utilities/score.dart';

class LearnPageController {
  final WidgetRef ref;
  final BuildContext context;

  LearnPageController(this.ref, this.context);

  void exitLearn() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondBackground,
          title: Text(
            'Xác nhận',
            style: TextStyle(
              color: AppColors.watchPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Bạn có chắc chắn muốn thoát không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text('Không', style: TextStyle(color: AppColors.primary)),
            ),
            TextButton(
              onPressed: () {
                resetProviders();
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'Có',
                style: TextStyle(color: AppColors.learnPrimary),
              ),
            ),
          ],
        );
      },
    );
  }

  int returnNumberNewWord(List<DataLearnModel> data) {
    int result = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].type == "study") {
        result++;
      }
    }
    return result;
  }

  void resetProviders() {
    ref.read(answerQuestionSelectedProvider.notifier).reset();
    ref.read(indexQuestionProvider.notifier).reset();
    ref.read(answerQuestionChosenProvider.notifier).reset();
    ref.read(answerQuestionSelectedProvider.notifier).reset();
    ref.invalidate(learnDataProvider);
    ref.read(amountScoreGainedProvider.notifier).reset();
    ref.read(listWordUpdatedProvider.notifier).reset();
  }

  void onContinue(DataLearnModel data) {
    final String? answerType = ref.watch(questionProvider)?.type;

    if (answerType != null) {
      switch (answerType) {
        case "study":
          //thêm vào report
          ref.read(listWordUpdatedProvider.notifier).add(data.word);
          ref.read(amountScoreGainedProvider.notifier).increment(Score.learn);
          // chuyển page
          ref.read(indexQuestionProvider.notifier).increment();
        case "practise1":
          if (ref.watch(answerQuestionChosenProvider) ==
              ref.watch(questionProvider)?.word.word) {
            //reset trạng thái để cho câu tiếp theo
            ref.read(answerQuestionChosenProvider.notifier).reset();
            ref.read(questionProvider.notifier).reset();
            //thêm vào report
            ref.read(listWordUpdatedProvider.notifier).add(data.word);
            ref
                .read(amountScoreGainedProvider.notifier)
                .increment(Score.practise);
            //chuyển page
            ref.read(indexQuestionProvider.notifier).increment();
          } else {
            // thêm vào report là thằng này sai
            ref.read(amountScoreGainedProvider.notifier).increment(Score.wrong);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WrongPage()),
            );
          }
        case "practise2":
          String answerQuestionSelected =
              ref.watch(answerQuestionSelectedProvider).toLowerCase().trim();
          String answerQuestion =
              ref.watch(questionProvider)!.word.word.toLowerCase().trim();
          if (answerQuestionSelected == answerQuestion) {
            //thêm vào report
            ref.read(listWordUpdatedProvider.notifier).add(data.word);
            ref
                .read(amountScoreGainedProvider.notifier)
                .increment(Score.practise);
            // reset trạng thái để cho câu tiếp theo
            ref.read(answerQuestionSelectedProvider.notifier).reset();
            ref.read(questionProvider.notifier).reset();
            ref.read(indexQuestionProvider.notifier).increment();
          } else {
            // thêm vào report là thằng này sai
            ref.read(amountScoreGainedProvider.notifier).increment(Score.wrong);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WrongPage()),
            );
          }
        case "practise3":
      }
    }
  }
}
