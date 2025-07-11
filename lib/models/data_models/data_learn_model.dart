import 'package:how_to_use_provider/models/data_models/word_model.dart';

class DataLearnModel {
  final String type;
  final String mainContent;
  final WordModel word;
  final List<String>? answers;

  DataLearnModel({
    required this.type,
    required this.mainContent,
    required this.word,
    this.answers,
  });

  factory DataLearnModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra trường word và parse thành WordModel
    final wordJson = json['word'] as Map<String, dynamic>?;
    if (wordJson == null) {
      throw FormatException('Trường "word" bị thiếu hoặc không hợp lệ trong JSON');
    }

    return DataLearnModel(
      type: json['type'] as String? ?? 'unknown',
      mainContent: json['mainContent'] as String? ?? '',
      word: WordModel.fromJson(wordJson),
      answers: json['answers'] != null
          ? List<String>.from(json['answers'] as List<dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'mainContent': mainContent,
      'word': word.toJson(),
      'answers': answers,
    };
  }

  // Hàm initial để tạo instance mặc định
  factory DataLearnModel.initial() {
    return DataLearnModel(
      type: 'unknown',
      mainContent: '',
      word: WordModel.initial(),
      answers: null,
    );
  }

  // Hàm initial để trả về List<DataLearnModel> rỗng
  static List<DataLearnModel> initialList() => [];

  // Hàm copyWith để cập nhật bất biến
  DataLearnModel copyWith({
    String? type,
    String? mainContent,
    WordModel? word,
    List<String>? answers,
  }) {
    return DataLearnModel(
      type: type ?? this.type,
      mainContent: mainContent ?? this.mainContent,
      word: word ?? this.word,
      answers: answers ?? this.answers,
    );
  }
}