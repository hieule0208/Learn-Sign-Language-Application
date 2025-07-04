
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';


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

// theo dõi xem có bao nhiêu từ được học mới

class AmountNewWordNotifier extends StateNotifier<int> {
  AmountNewWordNotifier() : super(0);

  void set(int amountNewWords) => state = amountNewWords;
  void reset() => state = 0;
}

final amountNewWordProvider =
    StateNotifierProvider<AmountNewWordNotifier, int>(
      (ref) => AmountNewWordNotifier(),
    );