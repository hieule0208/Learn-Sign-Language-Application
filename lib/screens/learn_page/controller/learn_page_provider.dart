import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';
import 'package:video_player/video_player.dart';

// theo dõi xem data cho bài tập như nào
final learnDataProvider = FutureProvider<List<DataLearnModel>>((ref) async {
  final apiService = ApiServices();
  return apiService.fetchLearnData();
});

// theo dõi xem đã làm đến câu thứ mấy rồi
class IndexQuestionNotifier extends StateNotifier<int> {
  IndexQuestionNotifier() : super(0);

  void increment() => state++;
  void reset() => state = 0;
}

final indexQuestionProvider = StateNotifierProvider<IndexQuestionNotifier, int>(
  (ref) => IndexQuestionNotifier(),
);

// Theo dõi câu hỏi hiện tại là gì
class QuestionNotifier extends StateNotifier<DataLearnModel?> {
  QuestionNotifier() : super(null);

  void set(DataLearnModel question) => state = question;

  void reset() => state = null;
}

final questionProvider =
    StateNotifierProvider<QuestionNotifier, DataLearnModel?>(
      (ref) => QuestionNotifier(),
    );
