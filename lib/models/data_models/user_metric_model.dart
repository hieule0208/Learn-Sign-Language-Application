import 'package:how_to_use_provider/models/data_models/topic_model.dart';

class UserMetricModel {
  final int totalScore;
  final int wordScore;
  final int videoScore;
  final int practiseScore;
  final int masteredWords;
  final int learnedWords;
  final int masteredVideos;
  final int learnedVideos;
  final int masteredConversation;
  final int learnedConversation;

  UserMetricModel({
    required this.totalScore,
    required this.wordScore,
    required this.videoScore,
    required this.practiseScore,
    required this.masteredWords,
    required this.learnedWords,
    required this.masteredVideos,
    required this.learnedVideos,
    required this.masteredConversation,
    required this.learnedConversation,
  });

  factory UserMetricModel.fromJson(Map<String, dynamic> json) {
    return UserMetricModel(
      totalScore: json['totalScore'] as int? ?? 0,
      wordScore: json['wordScore'] as int? ?? 0,
      videoScore: json['videoScore'] as int? ?? 0,
      practiseScore: json['practiseScore'] as int? ?? 0,
      masteredWords: json['masteredWords'] as int? ?? 0,
      learnedWords: json['learnedWords'] as int? ?? 0,
      masteredVideos: json['masteredVideos'] as int? ?? 0,
      learnedVideos: json['learnedVideos'] as int? ?? 0,
      masteredConversation: json['masteredConversation'] as int? ?? 0,
      learnedConversation: json['learnedConversation'] as int? ?? 0,
    );
  }
}