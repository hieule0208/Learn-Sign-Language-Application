import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/screens/overview/controller/overview_provider.dart';

class ResultPageController {
  void routeToHomePage(BuildContext context, WidgetRef ref) {
    LearnPageController(ref, context).resetProviders();
    ref.read(postUpdatedWordsProvider.notifier).reset();
    ref.read(userMetricOverviewStateProvider.notifier).initialize(); 
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  int returnAmountNewMasteredWord(List<WordModel> list) {
    int result = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].isMastered) {
        result++;
      }
    }
    return result;
  }
}
