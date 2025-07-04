import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnswerQuestionSelectedNotifier extends StateNotifier<String> {
  AnswerQuestionSelectedNotifier() : super(""); // Khởi tạo với chuỗi rỗng

  void setAnswer(String answerChosen) {
    state = state.isEmpty ? answerChosen : "$state$answerChosen";
  }

  void setText(String text) {
    state = text;
  }

  void reset() {
    state = "";
  }
}

//theo dõi câu trả lời được viết vào là như nào
final answerQuestionSelectedProvider =
    StateNotifierProvider<AnswerQuestionSelectedNotifier, String>(
      (ref) => AnswerQuestionSelectedNotifier(),
    );