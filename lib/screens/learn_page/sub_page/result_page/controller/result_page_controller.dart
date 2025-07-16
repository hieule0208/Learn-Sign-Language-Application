import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/widgets/error_notification.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';

class ResultPageController {
  void routeToHomePage(BuildContext context, WidgetRef ref) {
    final postImageState = ref.watch(postUpdatedWordsProvider);

    postImageState.when(
      data: (postImageState) {
        if (postImageState) {
          LearnPageController(ref, context).resetProviders();
          ref.read(postUpdatedWordsProvider.notifier).reset();
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        } else {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => ErrorNotification(
                  onReload: () {
                    ref.read(postUpdatedWordsProvider.notifier).postWords();
                  },
                  onGoHome: () {
                    LearnPageController(ref, context).resetProviders();
                    ref.read(postUpdatedWordsProvider.notifier).reset();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (_) => false,
                    );
                  },
                  isOverview: false,
                ),
          );
        }
      },
      error:
          (err, stack) => ErrorNotification(
            onReload: () {
              ref.read(postUpdatedWordsProvider.notifier).postWords();
            },
            onGoHome: () {
              LearnPageController(ref, context).resetProviders();
              ref.read(postUpdatedWordsProvider.notifier).reset();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            },
            isOverview: false,
          ),
      loading:
          () => LoadingState(
            imagePath: "lib/assets/image/gestura_logo.png",
            size: 150,
          ),
    );
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
