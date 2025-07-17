import 'package:flutter/material.dart';
import 'package:how_to_use_provider/screens/learn_page/UI/learn_page.dart';
import 'package:how_to_use_provider/utilities/level_rank.dart';
import 'package:intl/intl.dart';

class OverviewController {

  void navigateToLearnPage(BuildContext context) {
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LearnPage()),
    );
  }

  Map<String, dynamic> getCurrentLevelInfo(int score) {
    Map<Map<int, String>, int> level = LevelRank().getLevelRank;
    // Khởi tạo mặc định cho trường hợp không tìm thấy level
    int currentLevel = 1;
    String currentTitle = "Tụ Khí Cảnh Nhất Trọng";
    int? nextLevelScore = 16667;

    // Duyệt qua Map để tìm level hiện tại
    for (var entry in level.entries) {
      var levelKey = entry.key;
      var levelScore = entry.value;
      var levelNumber = levelKey.keys.first;
      var levelTitle = levelKey.values.first;

      // Nếu score nhỏ hơn hoặc bằng điểm yêu cầu của level hiện tại
      if (score >= levelScore) {
        currentLevel = levelNumber;
        currentTitle = levelTitle;

        // Tìm điểm yêu cầu của level tiếp theo
        var nextLevel = level.keys.firstWhere(
          (k) => k.keys.first == levelNumber + 1,
          orElse: () => {61: "Thiên địa cảnh"}, // Level cuối
        );
        nextLevelScore = level[nextLevel];
      } else {
        // Nếu score nhỏ hơn điểm yêu cầu, dừng lại
        break;
      }
    }

    // Trường hợp đạt level cuối (Thiên địa cảnh)
    if (currentLevel == 61) {
      nextLevelScore = null; // Không có level tiếp theo
    }

    return {
      'level': currentLevel,
      'title': currentTitle,
      'nextLevelScore': nextLevelScore,
    };
  }

  String formatNumber(int? number) {
    final numberFormat = NumberFormat("#,##0", "en_US");
    return numberFormat.format(number);
  }
}
