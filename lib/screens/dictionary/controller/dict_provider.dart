import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';

import 'dart:developer';

class DictDataStateNotifier extends StateNotifier<List<WordModel>> {
  final Ref ref;

  DictDataStateNotifier(this.ref) : super(WordModel.initialList()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      final apiService = ApiServices();
      // Lấy dữ liệu từ API và cập nhật trạng thái
      final wordData = await apiService.fetchMyWordData();
      state = wordData;
      log("DictDataStateNotifier: Fetched ${wordData.length} words", name: 'DictDataStateNotifier');
    } catch (e, stackTrace) {
      log("DictDataStateNotifier: Error fetching word data - $e",
          name: 'DictDataStateNotifier', error: e, stackTrace: stackTrace);
      state = WordModel.initialList(); // Đặt lại trạng thái mặc định nếu có lỗi
    }
  }

  void reset() => state = WordModel.initialList();
}

final dictDataStateProvider =
    StateNotifierProvider<DictDataStateNotifier, List<WordModel>>(
  (ref) => DictDataStateNotifier(ref),
);