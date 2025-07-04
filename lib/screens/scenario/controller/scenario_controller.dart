import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_provider.dart';
import 'package:how_to_use_provider/screens/scenario/sub_page/list_word_of_topic/UI/list_word_of_topic.dart';

class ScenarioController {
  void goDetailTopic(TopicModel topic, BuildContext context, WidgetRef ref) {
    ref.read(chosenTopicProvider.notifier).setChosenTopic(topic);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListWordOfTopic()),
    );
  }

  Map<String, List<TopicModel>> categorizeTopics(List<TopicModel> topics) {
    return {
      'inProgressTopics':
          topics
              .where((topic) => topic.hasStartedLearn && !topic.isCompleted)
              .toList(),
      'exploreTopics':
          topics
              .where((topic) => !topic.hasStartedLearn && !topic.isCompleted)
              .toList(),
      'finishTopics':
          topics
              .where((topic) => topic.hasStartedLearn && topic.isCompleted)
              .toList(),
    };
  }
}
