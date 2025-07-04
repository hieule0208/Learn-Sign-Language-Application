class TopicModel {
  final String id;
  final String name;
  final int numberOfWord;
  final int numberOfLearnedWord;
  final bool isCompleted;
  final bool hasStartedLearn;


  TopicModel({
    required this.id,
    required this.name,
    required this.numberOfWord,
    required this.numberOfLearnedWord,
    required this.isCompleted,
    required this.hasStartedLearn,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      numberOfWord: json['numberOfWord'] ?? 0,
      numberOfLearnedWord: json['numberOfLearnedWord'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      hasStartedLearn: json['hasStartedLearn'] ?? false,
    );
  }
}