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
  final String currentTopic;

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
    required this.currentTopic,
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
      currentTopic: json["currentTopic"] as String? ?? "",
    );
  }

  // Hàm initial để tạo instance với giá trị mặc định
  factory UserMetricModel.initial() {
    return UserMetricModel(
      totalScore: 0,
      wordScore: 0,
      videoScore: 0,
      practiseScore: 0,
      masteredWords: 0,
      learnedWords: 0,
      masteredVideos: 0,
      learnedVideos: 0,
      masteredConversation: 0,
      learnedConversation: 0,
      currentTopic: "",
    );
  }
}