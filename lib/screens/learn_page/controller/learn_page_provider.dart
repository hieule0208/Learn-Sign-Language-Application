import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/models/data_models/preload_model.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/services/api_services.dart';
import 'package:video_player/video_player.dart';

class LearnDataStateNotifier extends StateNotifier<List<DataLearnModel>> {
  final Ref ref;
  LearnDataStateNotifier(this.ref) : super([]) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      final apiService = ApiServices();
      // Lấy dữ liệu từ API và cập nhật trạng thái
      state = await apiService.fetchLearnData();
      print("[LearnData] State: $state");

      // Lọc các phần tử có type là 'study' và cập nhật amountNewWordProvider
      final studyItems = state.where((item) => item.type == 'study').toList();
      ref.read(amountNewWordProvider.notifier).set(studyItems.length);
      print("[LearnData] Updated amountNewWord: ${studyItems.length}");

      // Cập nhật câu hỏi đầu tiên
      if (state.isNotEmpty) {
        ref.read(questionProvider.notifier).set(state[0]);
        print("[LearnData] Set first question: ${state[0]}");
      }

      // Cập nhật URL list
      await ref
          .read(preloadStateProvider.notifier)
          .updateUrlsAndInitialize(
            state.map((item) => item.mainContent ?? '').toList(),
          );
      print("[LearnData] Updated URL list");
    } catch (e, stack) {
      print("[LearnData] Error initializing LearnDataStateNotifier: $e\n$stack");
      state = [];
    }
  }

  void reset() => state = [];
}

final learnDataStateProvider =
    StateNotifierProvider<LearnDataStateNotifier, List<DataLearnModel>>(
  (ref) => LearnDataStateNotifier(ref),
);

// theo dõi xem đã làm đến câu thứ mấy rồi
class IndexQuestionNotifier extends StateNotifier<int> {
  final Ref ref;
  IndexQuestionNotifier(this.ref) : super(0);

  void increment() {
    state++;
    print("[IndexQuestion] Incremented to index: $state");
    final learnData = ref.read(learnDataStateProvider);
    if (learnData.isNotEmpty && state < learnData.length) {
      ref.read(questionProvider.notifier).set(learnData[state]);
      print("[IndexQuestion] Set question at index $state: ${learnData[state]}");
    } else {
      print("[IndexQuestion] Invalid state: learnData empty or index out of range");
    }
    ref.read(preloadStateProvider.notifier).changeVideoIndex(state);
  }

  void reset() {
    print("[IndexQuestion] Reset index to 0");
    state = 0;
  }
}

final indexQuestionProvider = StateNotifierProvider<IndexQuestionNotifier, int>(
  (ref) => IndexQuestionNotifier(ref),
);

// preload video controller
class PreloadStateNotifier extends StateNotifier<PreloadModel> {
  final Ref ref;
  PreloadStateNotifier(this.ref)
      : super(PreloadModel(urls: [], controllers: {}, focusedIndex: 0));

  Future<void> updateUrlsAndInitialize(List<String> newUrls) async {
    print('[Preload] ▶️ updateUrlsAndInitialize: newUrls length = ${newUrls.length}, URLs = $newUrls');
    // Cập nhật danh sách URLs
    state = state.copyWith(urls: newUrls);
    // Khởi tạo lại video controllers
    await initialize();
    print('[Preload] ✅ updateUrlsAndInitialize DONE: focusedIndex = ${state.focusedIndex}');
  }

  Future<void> initialize() async {
    print('[Preload] ▶️ initialize: focusedIndex = ${state.focusedIndex}');
    // Khởi tạo controller cho video đầu tiên (index 0)
    await _initializeControllerAtIndex(0);
    // Preload video thứ hai (index 1)
    await _initializeControllerAtIndex(1);
    print('[Preload] ✅ initialize DONE: controllers = ${state.controllers.keys}');
  }

  /// Chuyển đổi video khi index thay đổi
  void changeVideoIndex(int index) {
    print('[Preload] ▶️ changeVideoIndex: newIndex = $index, current focusedIndex = ${state.focusedIndex}');
    if (index == state.focusedIndex) {
      print('[Preload] ⚠️ Index unchanged: $index, no action needed');
      return;
    }

    if (index > state.focusedIndex) {
      print('[Preload] Moving forward from ${state.focusedIndex} to $index');
      _playNext(index);
    } else {
      print('[Preload] Moving backward from ${state.focusedIndex} to $index');
      _playPrevious(index);
    }
    state = state.copyWith(focusedIndex: index);
    print('[Preload] ✅ changeVideoIndex DONE: new focusedIndex = ${state.focusedIndex}, controllers = ${state.controllers.keys}');
  }

  /// Xử lý khi chuyển sang video tiếp theo
  void _playNext(int index) {
    print('[Preload] ▶️ _playNext: index = $index, current focusedIndex = ${state.focusedIndex}');
    _stopControllerAtIndex(index - 1); // Dừng video trước đó
    _disposeControllerAtIndex(index - 2); // Hủy controller trước nữa
    _initializeControllerAtIndex(index + 1); // Preload video tiếp theo
  }

  /// Xử lý khi quay lại video trước đó
  void _playPrevious(int index) {
    print('[Preload] ▶️ _playPrevious: index = $index, current focusedIndex = ${state.focusedIndex}');
    _stopControllerAtIndex(index + 1); // Dừng video tiếp theo
    _disposeControllerAtIndex(index + 2); // Hủy controller sau nữa
    _initializeControllerAtIndex(index - 1); // Preload video trước đó
  }

  /// Khởi tạo controller cho video tại index
  Future<void> _initializeControllerAtIndex(int index) async {
    print('[Preload] ▶️ _initializeControllerAtIndex: index = $index, urls length = ${state.urls.length}');
    if (index >= 0 && index < state.urls.length && state.urls[index].isNotEmpty) {
      try {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(state.urls[index]),
        );
        final newControllers = Map<int, VideoPlayerController>.from(state.controllers);
        newControllers[index] = controller;
        state = state.copyWith(controllers: newControllers);
        print('[Preload] Created controller for index $index, URL = ${state.urls[index]}');
        await controller.initialize();
        print('[Preload] ✅ INITIALIZED $index');
      } catch (e) {
        print('[Preload] ❌ ERROR INITIALIZING $index: $e');
      }
    } else {
      print('[Preload] ⚠️ Index out of range or empty URL: index = $index, URL = ${index < state.urls.length ? state.urls[index] : 'N/A'}');
    }
  }

  /// Dừng video tại index
  void _stopControllerAtIndex(int index) {
    print('[Preload] Attempting to stop controller at index: $index');
    if (index >= 0 && index < state.urls.length && state.controllers.containsKey(index)) {
      final controller = state.controllers[index]!;
      controller.pause();
      controller.seekTo(const Duration());
      print('[Preload] ⏹ STOPPED $index');
    } else {
      print('[Preload] ⚠️ Cannot stop controller: index = $index out of range or not initialized');
    }
  }

  /// Hủy controller tại index
  void _disposeControllerAtIndex(int index) {
    print('[Preload] Attempting to dispose controller at index: $index');
    if (index >= 0 && index < state.urls.length && state.controllers.containsKey(index)) {
      final controller = state.controllers[index]!;
      controller.dispose();
      final newControllers = Map<int, VideoPlayerController>.from(state.controllers)..remove(index);
      state = state.copyWith(controllers: newControllers);
      print('[Preload] 🗑 DISPOSED $index');
    } else {
      print('[Preload] ⚠️ Cannot dispose controller: index = $index out of range or not initialized');
    }
  }

  @override
  void dispose() {
    print('[Preload] 🔁 dispose ALL controllers');
    for (final controller in state.controllers.values) {
      controller.dispose();
    }
    super.dispose();
    print('[Preload] ✅ dispose DONE');
  }

  void reset() => state = PreloadModel(urls: [], controllers: {}, focusedIndex: 0);
}

final preloadStateProvider =
    StateNotifierProvider<PreloadStateNotifier, PreloadModel>((ref) {
      return PreloadStateNotifier(ref);
    });

// Theo dõi câu hỏi hiện tại là gì
class QuestionNotifier extends StateNotifier<DataLearnModel?> {
  QuestionNotifier() : super(null);

  void set(DataLearnModel question) {
    state = question;
    print("[QuestionNotifier] Set question: $question");
  }

  void reset() {
    print("[QuestionNotifier] Reset question to null");
    state = null;
  }
}

final questionProvider =
    StateNotifierProvider<QuestionNotifier, DataLearnModel?>(
  (ref) => QuestionNotifier(),
);