import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';

class TopicDataStateNotifier extends StateNotifier<List<TopicModel>> {
  final Ref ref;

  TopicDataStateNotifier(this.ref) : super(TopicModel.initialList()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      final apiService = ApiServices();
      // Lấy dữ liệu từ API và cập nhật trạng thái
      final topicData = await apiService.fetchTopicData();
      state = topicData;
      log("TopicDataStateNotifier: Fetched ${topicData.length} topics",
          name: 'TopicDataStateNotifier');
    } catch (e, stackTrace) {
      log("TopicDataStateNotifier: Error fetching topic data - $e",
          name: 'TopicDataStateNotifier', error: e, stackTrace: stackTrace);
      state = TopicModel.initialList(); // Đặt lại trạng thái mặc định nếu có lỗi
    }
  }

  void reset() => state = TopicModel.initialList();
}

final topicDataStateProvider =
    StateNotifierProvider<TopicDataStateNotifier, List<TopicModel>>(
  (ref) => TopicDataStateNotifier(ref),
);

class ChosenTopicNotifier extends StateNotifier<TopicModel?> {
  ChosenTopicNotifier() : super(null);

  void setChosenTopic(TopicModel chosenTopic) => state = chosenTopic;

  void resetChosenTopic() => state = null;
}

final chosenTopicProvider =
    StateNotifierProvider<ChosenTopicNotifier, TopicModel?>(
      (ref) => ChosenTopicNotifier(),
    );

final topicWordDataProvider = FutureProvider<List<WordModel>>((ref) async {
  final apiServices = ApiServices();
  return apiServices.fetchWordOfTopicData(ref);
});
