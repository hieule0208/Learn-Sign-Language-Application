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
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      numberOfWord: (json['numberOfWord'] as num?)?.toInt() ?? 0,
      numberOfLearnedWord: (json['numberOfLearnedWord'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      hasStartedLearn: json['hasStartedLearn'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'numberOfWord': numberOfWord,
      'numberOfLearnedWord': numberOfLearnedWord,
      'isCompleted': isCompleted,
      'hasStartedLearn': hasStartedLearn,
    };
  }

  // Hàm initial để tạo instance mặc định
  factory TopicModel.initial() {
    return TopicModel(
      id: '',
      name: '',
      numberOfWord: 0,
      numberOfLearnedWord: 0,
      isCompleted: false,
      hasStartedLearn: false,
    );
  }

  // Hàm initial để trả về List<TopicModel> rỗng
  static List<TopicModel> initialList() => [];

  // Hàm copyWith để cập nhật một cách bất biến
  TopicModel copyWith({
    String? id,
    String? name,
    int? numberOfWord,
    int? numberOfLearnedWord,
    bool? isCompleted,
    bool? hasStartedLearn,
  }) {
    return TopicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      numberOfWord: numberOfWord ?? this.numberOfWord,
      numberOfLearnedWord: numberOfLearnedWord ?? this.numberOfLearnedWord,
      isCompleted: isCompleted ?? this.isCompleted,
      hasStartedLearn: hasStartedLearn ?? this.hasStartedLearn,
    );
  }
}