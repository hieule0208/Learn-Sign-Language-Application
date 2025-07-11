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
    return WordModel(
      id: json['id'] as String? ?? '', // Chuỗi rỗng nếu id null
      word: json['word'] as String? ?? '', // Chuỗi rỗng nếu word null
      description: json['description'] as String? ?? '', // Chuỗi rỗng nếu description null
      score: (json['score'] as num?)?.toInt() ?? 0, // 0 nếu score null
      isLearned: json['isLearned'] as bool? ?? false, // false nếu isLearned null
      replayTimes: (json['replayTimes'] as num?)?.toInt() ?? 0, // 0 nếu replayTimes null
      isMastered: json['isMastered'] as bool? ?? false, // false nếu isMastered null
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