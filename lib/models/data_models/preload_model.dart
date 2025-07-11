import 'package:video_player/video_player.dart';

class PreloadModel {
  List<String> urls;
  Map<int, VideoPlayerController> controllers;
  int focusedIndex;

  PreloadModel({
    required this.urls,
    required this.controllers,
    required this.focusedIndex,
  });

  // CopyWith để hỗ trợ cập nhật trạng thái một cách bất biến
  PreloadModel copyWith({
    List<String>? urls,
    Map<int, VideoPlayerController>? controllers,
    int? focusedIndex,
  }) {
    return PreloadModel(
      urls: urls ?? this.urls,
      controllers: controllers ?? this.controllers,
      focusedIndex: focusedIndex ?? this.focusedIndex,
    );
  }

  // Ghi đè toString để in thông tin trạng thái
  @override
  String toString() {
    return 'PreloadModel('
        'urls: $urls, '
        'controllers: $controllers, '
        'focusedIndex: $focusedIndex'
        ')';
  }

  // Ghi đè == để so sánh hai đối tượng PreloadModel
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PreloadModel &&
            runtimeType == other.runtimeType &&
            urls == other.urls &&
            controllers == other.controllers &&
            focusedIndex == other.focusedIndex;
  }

  // Ghi đè hashCode để sử dụng trong các tập hợp
  @override
  int get hashCode => urls.hashCode ^ controllers.hashCode ^ focusedIndex.hashCode;
}
