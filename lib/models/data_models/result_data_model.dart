import 'package:how_to_use_provider/models/data_models/word_model.dart';

class ResultDataModel {
  final int wordScore;
  final int videoScore;
  final List<WordModel> wordUpdated;

  ResultDataModel({
    required this.wordScore,
    required this.videoScore,
    required this.wordUpdated,
  });

  factory ResultDataModel.fromJson(Map<String, dynamic> json) {
    // Parse danh sách wordUpdated
    final wordUpdatedJson = json['wordUpdated'] as List<dynamic>?;
    final wordUpdated = wordUpdatedJson != null
        ? wordUpdatedJson
            .map((item) => WordModel.fromJson(item as Map<String, dynamic>))
            .toList()
        : <WordModel>[]; // Danh sách rỗng nếu wordUpdated thiếu

    return ResultDataModel(
      wordScore: (json['wordScore'] as num?)?.toInt() ?? 0, // Mặc định 0 nếu thiếu
      videoScore: (json['videoScore'] as num?)?.toInt() ?? 0, // Mặc định 0 nếu thiếu
      wordUpdated: wordUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wordScore': wordScore,
      'videoScore': videoScore,
      'wordUpdated': wordUpdated.map((word) => word.toJson()).toList(),
    };
  }
}