import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/screens/learn_page/UI/learn_page.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';


class ResultPageController {
  void onContinueLearn(BuildContext context, WidgetRef ref) {
    LearnPageController(ref, context).resetProviders();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LearnPage()),
      (_) => false,
    );
  }

  void routeToHomePage(BuildContext context, WidgetRef ref) {
    LearnPageController(ref, context).resetProviders();
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  int returnAmountNewMasteredWord(List<WordModel> list){
    int result = 0; 
    for(int i = 0; i < list.length; i++){
      if(list[i].isMastered){
        result++; 
      }
    }
    return result; 
  }
}
