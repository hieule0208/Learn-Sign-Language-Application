
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';

// theo dõi xem có thêm bao nhiêu điểm
class AmountScoreGainedNotifier extends StateNotifier<int> {
  AmountScoreGainedNotifier() : super(0);

  void increment(int score) => state += score;
  void reset() => state = 0;
}

final amountScoreGainedProvider =
    StateNotifierProvider<AmountScoreGainedNotifier, int>(
      (ref) => AmountScoreGainedNotifier(),
    );

// theo dõi xem các word đã có sự thay đổi như thế nào
class ListWordUpdatedNotifier extends StateNotifier<List<WordModel>?> {
  ListWordUpdatedNotifier() : super([]);

  void add(WordModel newWord) {
    final existingWordIndex = state!.indexWhere(
      (word) => word.id == newWord.id,
    );

    if (existingWordIndex == -1) {
      state = [
        ...state!,
        WordModel(
          id: newWord.id,
          word: newWord.word,
          description: newWord.description,
          score: newWord.score,
          isLearned: true,
          replayTimes: newWord.replayTimes + 1,
          isMastered: newWord.replayTimes + 1 >= 5,
        ),
      ];
    } else {
      final existingWord = state![existingWordIndex];
      final updatedReplayTimes = existingWord.replayTimes + 1;
      state = [
        ...state!.asMap().entries.map((entry) {
          final index = entry.key;
          final word = entry.value;
          if (index == existingWordIndex) {
            return WordModel(
              id: word.id,
              word: word.word,
              description: word.description,
              score: word.score,
              isLearned: true, // Đặt isLearned thành true
              replayTimes: updatedReplayTimes,
              isMastered: updatedReplayTimes >= 5,
            );
          }
          return word;
        }).toList(),
      ];
    }
  }

  void reset() => state = [];
}

final listWordUpdatedProvider =
    StateNotifierProvider<ListWordUpdatedNotifier, List<WordModel>?>(
      (ref) => ListWordUpdatedNotifier(),
    );

class PostUpdatedWordsNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref ref;

  PostUpdatedWordsNotifier(this.ref) : super(const AsyncValue.loading()) {
    postWords();
  }

  Future<void> postWords() async {
    try {
      // ⏳ Bắt đầu gửi dữ liệu
      state = const AsyncValue.loading();
      print("📤 [PostUpdatedWordsNotifier] Bắt đầu gửi POST request...");

      // 🧾 Lấy danh sách từ đã cập nhật và điểm
      final words = ref.read(listWordUpdatedProvider) ?? [];
      final score = ref.read(amountScoreGainedProvider);

      // ⚠️ Nếu không có từ nào cần gửi
      if (words.isEmpty) {
        print("⚠️ [PostUpdatedWordsNotifier] Không có từ nào để gửi.");
        state = const AsyncValue.data(false);
        return;
      }

      // 📡 Gọi API
      final apiService = ApiServices();
      final success = await apiService.postUpdatedWords(words, score);

      // ✅ Gửi thành công
      print("✅ [PostUpdatedWordsNotifier] Đã gửi xong, thành công: $success");
      state = AsyncValue.data(success);
    } catch (e, stackTrace) {
      // ❌ Gặp lỗi khi gửi
      print("❌ [PostUpdatedWordsNotifier] Lỗi khi gửi dữ liệu: $e");
      print("🧾 StackTrace: $stackTrace");
      state = const AsyncValue.data(false);
    }
  }

  void reset() {
    // 🔄 Reset lại trạng thái
    print("🔄 [PostUpdatedWordsNotifier] Đã reset trạng thái.");
    state = const AsyncValue.data(false);
  }
}

final postUpdatedWordsProvider =
    StateNotifierProvider<PostUpdatedWordsNotifier, AsyncValue<bool>>(
      (ref) => PostUpdatedWordsNotifier(ref),
    );

// theo dõi xem có bao nhiêu từ được học mới

class AmountNewWordNotifier extends StateNotifier<int> {
  AmountNewWordNotifier() : super(0);

  void set(int amountNewWords) => state = amountNewWords;
  void reset() => state = 0;
}

final amountNewWordProvider = StateNotifierProvider<AmountNewWordNotifier, int>(
  (ref) => AmountNewWordNotifier(),
);
