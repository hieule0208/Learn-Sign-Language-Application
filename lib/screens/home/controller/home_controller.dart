import 'package:flutter/material.dart';
import 'package:how_to_use_provider/screens/dictionary/UI/dictionary.dart';
import 'package:how_to_use_provider/screens/setting/UI/setting.dart';

class HomeController {
  void navigateToDictionary(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dictionary(),
      ),
    );
  }

  void navigateToSetting(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Setting(),
      ),
    );
  }
}
