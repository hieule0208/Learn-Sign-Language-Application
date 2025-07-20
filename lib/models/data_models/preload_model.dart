import 'package:flutter/foundation.dart'; // Cần thiết cho mapEquals và listEquals
import 'package:video_player/video_player.dart';

class PreloadModel {
  // Các thuộc tính nên là `final` để đảm bảo đối tượng state là bất biến.
  final List<String> urls;
  // THAY ĐỔI QUAN TRỌNG: Kiểu dữ liệu giờ là Map<int, VideoPlayerController?>
  // Dấu `?` cho phép map chứa các giá trị null, đại diện cho các mục không có video.
  final Map<int, VideoPlayerController?> controllers;
  final int focusedIndex;

  // Sử dụng const constructor để cải thiện hiệu suất.
  const PreloadModel({
    required this.urls,
    required this.controllers,
    required this.focusedIndex,
  });

  // CopyWith để hỗ trợ cập nhật trạng thái một cách bất biến
  PreloadModel copyWith({
    List<String>? urls,
    // THAY ĐỔI QUAN TRỌNG: Kiểu của tham số cũng được cập nhật.
    Map<int, VideoPlayerController?>? controllers,
    int? focusedIndex,
  }) {
    return PreloadModel(
      urls: urls ?? this.urls,
      controllers: controllers ?? this.controllers,
      focusedIndex: focusedIndex ?? this.focusedIndex,
    );
  }

  // Ghi đè toString để in thông tin trạng thái, hữu ích cho việc gỡ lỗi.
  @override
  String toString() {
    // Chỉ in ra các key của controller để log không quá dài.
    return 'PreloadModel('
        'urls_count: ${urls.length}, '
        'controllers_keys: ${controllers.keys}, '
        'focusedIndex: $focusedIndex'
        ')';
  }

  // Ghi đè toán tử == để so sánh hai đối tượng PreloadModel một cách chính xác.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreloadModel &&
        other.runtimeType == runtimeType &&
        // Sử dụng listEquals và mapEquals để so sánh sâu các collection.
        listEquals(other.urls, urls) &&
        mapEquals(other.controllers, controllers) &&
        other.focusedIndex == focusedIndex;
  }

  // Ghi đè hashCode để phù hợp với việc ghi đè toán tử ==.
  @override
  int get hashCode =>
      urls.hashCode ^ controllers.hashCode ^ focusedIndex.hashCode;
}
