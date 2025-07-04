import 'package:how_to_use_provider/models/data_models/word_model.dart';

class DataLearnModel {
  final String type;
  final String mainContent;
  final WordModel word;
  final List<String>? answers;
  final String? correctAnswer;

  DataLearnModel({
    required this.type,
    required this.mainContent,
    required this.word,
    this.answers,
    this.correctAnswer,
  });

  factory DataLearnModel.fromJson(Map<String, dynamic> json) {
    // Kiểm tra trường word và parse thành WordModel
    final wordJson = json['word'] as Map<String, dynamic>?;
    if (wordJson == null) {
      throw FormatException('Trường "word" bị thiếu hoặc không hợp lệ trong JSON');
    }

    return DataLearnModel(
      type: json['type'] as String? ?? 'unknown', // Giá trị mặc định nếu type null
      mainContent: json['mainContent'] as String? ?? '', // Chuỗi rỗng nếu mainContent null
      word: WordModel.fromJson(wordJson), // Parse WordModel
      answers: json['answers'] != null
          ? List<String>.from(json['answers'] as List<dynamic>)
          : null, // Danh sách null nếu answers không có
      correctAnswer: json['correctAnswer'] as String?, // Giữ null nếu correctAnswer không có
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'mainContent': mainContent,
      'word': word.toJson(),
      'answers': answers,
      'correctAnswer': correctAnswer,
    };
  }
}