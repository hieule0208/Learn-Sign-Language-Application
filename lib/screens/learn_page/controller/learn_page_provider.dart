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
      log("$state đã lấy được mấy cái này");

      // Lọc các phần tử có type là 'study' và cập nhật amountNewWordProvider
      final studyItems = state.where((item) => item.type == 'study').toList();
      ref.read(amountNewWordProvider.notifier).set(studyItems.length);
      log("Đã cập nhật số từ mới");

      // Cập nhật câu hỏi đầu tiên
      if (state.isNotEmpty) {
        ref.read(questionProvider.notifier).set(state[0]);
        log("Đã cập nhật câu đầu tiên");
      }

      // Cập nhật URL list
      await ref
          .read(preloadStateProvider.notifier)
          .updateUrlsAndInitialize(
            state.map((item) => item.mainContent).toList(),
          );
      log("Đã cập nhật danh sách url");
    } catch (e, stack) {
      log("Lỗi khi khởi tạo LearnDataStateNotifier: $e\n$stack");
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
    final learnData = ref.read(learnDataStateProvider);
    if (learnData.isNotEmpty && state < learnData.length) {
      ref.read(questionProvider.notifier).set(learnData[state]);
    }
    ref.read(preloadStateProvider.notifier).changeVideoIndex(state);
  }

  void reset() => state = 0;
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
    // Cập nhật danh sách URLs
    state = state.copyWith(urls: newUrls);
    // Khởi tạo lại video controllers
    await initialize();

    print("Khởi tạo");
  }

  Future<void> initialize() async {
    // Khởi tạo controller cho video đầu tiên (index 0)
    await _initializeControllerAtIndex(0);
    // Preload video thứ hai (index 1)
    await _initializeControllerAtIndex(1);
  }

  /// Chuyển đổi video khi index thay đổi
  void changeVideoIndex(int index) {
    if (index > state.focusedIndex) {
      _playNext(index); // Chuyển sang video tiếp theo
    } else {
      _playPrevious(index); // Quay lại video trước đó
    }
    // Cập nhật trạng thái với index mới
    state = state.copyWith(focusedIndex: index);
  }

  /// Xử lý khi chuyển sang video tiếp theo
  void _playNext(int index) {
    // Dừng video trước đó (index - 1)
    _stopControllerAtIndex(index - 1);
    // Hủy controller của video trước nữa (index - 2)
    _disposeControllerAtIndex(index - 2);
    // Preload video tiếp theo (index + 1)
    _initializeControllerAtIndex(index + 1);
  }

  /// Xử lý khi quay lại video trước đó
  void _playPrevious(int index) {
    // Dừng video tiếp theo (index + 1)
    _stopControllerAtIndex(index + 1);
    // Hủy controller của video sau nữa (index + 2)
    _disposeControllerAtIndex(index + 2);
    // Preload video trước đó (index - 1)
    _initializeControllerAtIndex(index - 1);
  }

  /// Khởi tạo controller cho video tại index
  Future<void> _initializeControllerAtIndex(int index) async {
    if (state.urls.length > index && index >= 0) {
      try {
        // Tạo controller mới từ URL video
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(state.urls[index]),
        );
        // Sao chép map controllers và thêm controller mới
        final newControllers = Map<int, VideoPlayerController>.from(
          state.controllers,
        );
        newControllers[index] = controller;
        // Cập nhật trạng thái
        state = state.copyWith(controllers: newControllers);
        // Khởi tạo controller
        await controller.initialize();
        log('🚀🚀🚀 INITIALIZED $index');
      } catch (e) {
        log('🚨 ERROR INITIALIZING $index: $e');
      }
    }
  }

  /// Dừng video tại index
  void _stopControllerAtIndex(int index) {
    if (state.urls.length > index &&
        index >= 0 &&
        state.controllers.containsKey(index)) {
      final controller = state.controllers[index]!;
      controller.pause();
      controller.seekTo(const Duration());
      log('🚀🚀🚀 STOPPED $index');
    }
  }

  /// Hủy controller tại index
  void _disposeControllerAtIndex(int index) {
    if (state.urls.length > index &&
        index >= 0 &&
        state.controllers.containsKey(index)) {
      final controller = state.controllers[index]!;
      controller.dispose();
      // Sao chép map controllers và xóa controller tại index
      final newControllers = Map<int, VideoPlayerController>.from(
        state.controllers,
      )..remove(index);
      // Cập nhật trạng thái
      state = state.copyWith(controllers: newControllers);
      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  /// Hủy tất cả controllers khi StateNotifier bị dispose
  @override
  void dispose() {
    for (final controller in state.controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

final preloadStateProvider =
    StateNotifierProvider<PreloadStateNotifier, PreloadModel>((ref) {
      return PreloadStateNotifier(ref);
    });

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
