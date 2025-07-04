import 'dart:ffi';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';

final topicDataProvider = FutureProvider<List<TopicModel>>((ref) async {
  final apiService = ApiServices();
  return apiService.fetchTopicData();
});

class ChosenTopicNotifier extends StateNotifier<TopicModel?> {
  ChosenTopicNotifier() : super(null);

  void setChosenTopic(TopicModel chosenTopic) => state = chosenTopic;

  void resetChosenTopic() => state = null;
}

final chosenTopicProvider = StateNotifierProvider<ChosenTopicNotifier, TopicModel?>(
  (ref) => ChosenTopicNotifier(),
);

final topicWordDataProvider = FutureProvider<List<WordModel>>(
  (ref) async {
    final apiServices = ApiServices();
    return apiServices.fetchWordOfTopicData(ref);
  }
);