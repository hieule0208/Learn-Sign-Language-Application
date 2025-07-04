import 'package:flutter/material.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/screens/learn_page/UI/learn_page.dart';

class ListWordOfTopicController {
  String titleButton(TopicModel topic) {
    if (!topic.hasStartedLearn) {
      return "Bắt đầu học";
    } else if (!topic.isCompleted) {
      return "Tiếp tục học";
    } else {
      return "Ôn tập";
    }
  }

  void routeToLearnPage(BuildContext context) {
    
    // TODO: Cần 1 chức năng để set currentTopic = this topic

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LearnPage()),
    );
  }

  
}
