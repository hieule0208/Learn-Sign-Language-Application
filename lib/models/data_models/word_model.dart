class WordModel {
  final String id;
  final String word;
  final String description;
  final int score;
  final bool isLearned;
  final int replayTimes;
  final bool isMastered;

  WordModel({
    required this.id,
    required this.word,
    required this.description,
    required this.score,
    required this.isLearned,
    required this.replayTimes,
    required this.isMastered,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return false;
    }

    return WordModel(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      description: json['description'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      isLearned: parseBool(json['isLearned']),
      replayTimes: (json['replayTimes'] as num?)?.toInt() ?? 0,
      isMastered: parseBool(json['isMastered']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'description': description,
      'score': score,
      'isLearned': isLearned,
      'replayTimes': replayTimes,
      'isMastered': isMastered,
    };
  }

  // Hàm initial để tạo một instance WordModel với giá trị mặc định
  factory WordModel.initial() {
    return WordModel(
      id: '',
      word: '',
      description: '',
      score: 0,
      isLearned: false,
      replayTimes: 0,
      isMastered: false,
    );
  }

  // Hàm initial để trả về List<WordModel> rỗng cho dictDataProvider
  static List<WordModel> initialList() => [];
}