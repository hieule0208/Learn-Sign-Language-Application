import 'package:flutter/material.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';

class DictController {
  void navigateToHome(BuildContext context) {
    Navigator.pop(context);
  }

  Map<String, List<WordModel>> categorizeWords(List<WordModel> words) {
    return {
      'learnedList':
          words.where((word) => word.isLearned && !word.isMastered).toList(),
      'masteredList': words.where((word) => word.isMastered).toList(),
    };
  }
}
