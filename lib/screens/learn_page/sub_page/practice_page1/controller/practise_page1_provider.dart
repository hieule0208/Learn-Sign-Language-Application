import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnswerQuestionChosenNotifier extends StateNotifier<String?> {
  AnswerQuestionChosenNotifier() : super(null);

  void setAnswer(String answerChosen) => state = answerChosen;
  void reset() => state = null;
}

// theo dõi xem người dùng chọn câu trả lời nào
final answerQuestionChosenProvider =
    StateNotifierProvider<AnswerQuestionChosenNotifier, String?>(
      (ref) => AnswerQuestionChosenNotifier(),
    );