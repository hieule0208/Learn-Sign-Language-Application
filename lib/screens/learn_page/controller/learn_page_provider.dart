import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/models/data_models/preload_model.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/services/api_services.dart';
import 'package:video_player/video_player.dart';

// --- LearnDataStateNotifier (Không thay đổi) ---
// Quản lý việc tìm nạp và lưu trữ dữ liệu học tập từ API
class LearnDataStateNotifier extends StateNotifier<List<DataLearnModel>> {
  final Ref ref;
  LearnDataStateNotifier(this.ref) : super([]) {
    initialize();
  }

  Future<void> initialize() async {
    log('▶️ Initializing...', name: 'LearnDataStateNotifier');
    try {
      final apiService = ApiServices();
      state = await apiService.fetchLearnData();
      log('✅ Fetched data successfully. Count: ${state.length}', name: 'LearnDataStateNotifier');

      final studyItems = state.where((item) => item.type == 'study').toList();
      ref.read(amountNewWordProvider.notifier).set(studyItems.length);
      log('Updated amountNewWord: ${studyItems.length}', name: 'LearnDataStateNotifier');

      if (state.isNotEmpty) {
        ref.read(questionProvider.notifier).set(state[0]);
        log('Set first question: ${state[0].word.word}', name: 'LearnDataStateNotifier');
      } else {
        log('⚠️ Data state is empty, cannot set first question.', name: 'LearnDataStateNotifier');
      }

      log('Updating URL list for preloading...', name: 'LearnDataStateNotifier');
      await ref.read(preloadStateProvider.notifier).updateUrlsAndInitialize(
            state.map((item) => item.mainContent ?? '').toList(),
          );
      log('✅ Initialization complete.', name: 'LearnDataStateNotifier');
    } catch (e, stack) {
      log('❌ Error initializing', name: 'LearnDataStateNotifier', error: e, stackTrace: stack);
      state = [];
    }
  }

  void reset() {
    log('🔁 Resetting state to empty list.', name: 'LearnDataStateNotifier');
    state = [];
  }
}

final learnDataStateProvider = StateNotifierProvider<LearnDataStateNotifier, List<DataLearnModel>>(
  (ref) => LearnDataStateNotifier(ref),
);

// --- IndexQuestionNotifier (Không thay đổi) ---
// Theo dõi chỉ mục của câu hỏi hiện tại
class IndexQuestionNotifier extends StateNotifier<int> {
  final Ref ref;
  IndexQuestionNotifier(this.ref) : super(0);

  void increment() {
    final newIndex = state + 1;
    log('▶️ Incrementing index to: $newIndex', name: 'IndexQuestionNotifier');
    state = newIndex;

    final learnData = ref.read(learnDataStateProvider);
    if (learnData.isNotEmpty && state < learnData.length) {
      ref.read(questionProvider.notifier).set(learnData[state]);
      log('✅ Set question at index $state: ${learnData[state].word.word}', name: 'IndexQuestionNotifier');
      ref.read(preloadStateProvider.notifier).changeVideoIndex(state);
    } else {
      log(
        '⚠️ Invalid state: learnData empty or index out of range. Index: $state, Data length: ${learnData.length}',
        name: 'IndexQuestionNotifier',
      );
    }
  }

  void reset() {
    log('🔁 Resetting index to 0', name: 'IndexQuestionNotifier');
    state = 0;
  }
}

final indexQuestionProvider = StateNotifierProvider<IndexQuestionNotifier, int>(
  (ref) => IndexQuestionNotifier(ref),
);

// --- PreloadStateNotifier (ĐÃ VIẾT LẠI) ---
// Quản lý việc tải trước, phát và hủy các video controller
class PreloadStateNotifier extends StateNotifier<PreloadModel> {
  final Ref ref;
  PreloadStateNotifier(this.ref)
      // Sử dụng `VideoPlayerController?` để cho phép giá trị null
      : super(PreloadModel(urls: [], controllers: {}, focusedIndex: 0));

  Future<void> updateUrlsAndInitialize(List<String> newUrls) async {
    log('▶️ updateUrlsAndInitialize: newUrls length = ${newUrls.length}', name: 'PreloadStateNotifier');
    // Hủy các controller cũ trước khi bắt đầu
    _disposeAllControllers();
    state = state.copyWith(urls: newUrls, focusedIndex: 0, controllers: {});
    await initialize();
    log('✅ updateUrlsAndInitialize DONE: focusedIndex = ${state.focusedIndex}', name: 'PreloadStateNotifier');
  }

  Future<void> initialize() async {
    log('▶️ initialize: focusedIndex = ${state.focusedIndex}', name: 'PreloadStateNotifier');
    // Khởi tạo controller cho video đầu tiên (index 0), ngay cả khi nó không có video (sẽ là null)
    await _initializeControllerAtIndex(0);
    // Preload video thứ hai (index 1)
    await _initializeControllerAtIndex(1);
    log('✅ initialize DONE: controllers = ${state.controllers.keys}', name: 'PreloadStateNotifier');
  }

  void changeVideoIndex(int index) {
    log('▶️ changeVideoIndex: newIndex = $index, current focusedIndex = ${state.focusedIndex}', name: 'PreloadStateNotifier');
    if (index == state.focusedIndex) {
      log('⚠️ Index unchanged: $index, no action needed', name: 'PreloadStateNotifier');
      return;
    }

    if (index > state.focusedIndex) {
      log('Moving forward from ${state.focusedIndex} to $index', name: 'PreloadStateNotifier');
      _playNext(index);
    } else {
      log('Moving backward from ${state.focusedIndex} to $index', name: 'PreloadStateNotifier');
      _playPrevious(index);
    }
    state = state.copyWith(focusedIndex: index);
    log('✅ changeVideoIndex DONE: new focusedIndex = ${state.focusedIndex}, controllers = ${state.controllers.keys}', name: 'PreloadStateNotifier');
  }

  void _playNext(int index) {
    log('▶️ _playNext: index = $index', name: 'PreloadStateNotifier');
    _stopControllerAtIndex(index - 1);
    _disposeControllerAtIndex(index - 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    log('▶️ _playPrevious: index = $index', name: 'PreloadStateNotifier');
    _stopControllerAtIndex(index + 1);
    _disposeControllerAtIndex(index + 2);
    _playControllerAtIndex(index);
    _initializeControllerAtIndex(index - 1);
  }

  void _playControllerAtIndex(int index) {
    // Luôn kiểm tra xem key có tồn tại không trước khi truy cập
    if (state.controllers.containsKey(index)) {
      final VideoPlayerController? controller = state.controllers[index];
      // Sử dụng `?.` để gọi play một cách an toàn
      controller?.play();
      if (controller != null) log('🚀🚀🚀 PLAYING $index');
    }
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    // Kiểm tra giới hạn và sự tồn tại trước
    if (index < 0 || index >= state.urls.length || state.controllers.containsKey(index)) {
      return;
    }

    final newControllers = Map<int, VideoPlayerController?>.from(state.controllers);
    final url = state.urls[index];

    if (url.isNotEmpty) {
      // Nếu có URL, tạo controller
      log('▶️ Initializing controller for index $index', name: 'PreloadStateNotifier');
      try {
        final controller = VideoPlayerController.networkUrl(Uri.parse(url));
        newControllers[index] = controller;
        state = state.copyWith(controllers: newControllers);
        await controller.initialize();
        log('✅ INITIALIZED $index', name: 'PreloadStateNotifier');
      } catch (e, stack) {
        log('❌ ERROR INITIALIZING $index', name: 'PreloadStateNotifier', error: e, stackTrace: stack);
        // Nếu lỗi, xóa key để có thể thử lại sau
        newControllers.remove(index);
        state = state.copyWith(controllers: newControllers);
      }
    } else {
      // Nếu URL rỗng, đánh dấu index này là không có video bằng cách đặt là null
      log('ℹ️ No video for index $index. Setting controller to null.', name: 'PreloadStateNotifier');
      newControllers[index] = null;
      state = state.copyWith(controllers: newControllers);
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.controllers.containsKey(index)) {
      final controller = state.controllers[index];
      // Sử dụng `?.` để thao tác một cách an toàn
      controller?.pause();
      controller?.seekTo(const Duration());
      if (controller != null) log('⏹ STOPPED $index', name: 'PreloadStateNotifier');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.controllers.containsKey(index)) {
      final controller = state.controllers[index];
      // Sử dụng `?.` để hủy một cách an toàn
      controller?.dispose();
      final newControllers = Map<int, VideoPlayerController?>.from(state.controllers)..remove(index);
      state = state.copyWith(controllers: newControllers);
      log('🗑 DISPOSED $index', name: 'PreloadStateNotifier');
    }
  }
  
  void _disposeAllControllers() {
    log('🔁 Disposing ALL controllers...', name: 'PreloadStateNotifier');
    for (final controller in state.controllers.values) {
      controller?.dispose();
    }
    log('✅ All controllers disposed.', name: 'PreloadStateNotifier');
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void reset() {
    log('🔁 Resetting PreloadState.', name: 'PreloadStateNotifier');
    _disposeAllControllers();
    state = PreloadModel(urls: [], controllers: {}, focusedIndex: 0);
  }
}

final preloadStateProvider = StateNotifierProvider<PreloadStateNotifier, PreloadModel>((ref) {
  return PreloadStateNotifier(ref);
});

// --- QuestionNotifier (Không thay đổi) ---
// Theo dõi câu hỏi hiện tại
class QuestionNotifier extends StateNotifier<DataLearnModel?> {
  QuestionNotifier() : super(null);

  void set(DataLearnModel question) {
    log('Set question: ID = ${question.word.word}', name: 'QuestionNotifier');
    state = question;
  }

  void reset() {
    log('Reset question to null', name: 'QuestionNotifier');
    state = null;
  }
}

final questionProvider = StateNotifierProvider<QuestionNotifier, DataLearnModel?>(
  (ref) => QuestionNotifier(),
);