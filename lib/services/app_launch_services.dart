import 'dart:convert';
import 'package:how_to_use_provider/models/data_models/user_metric_model.dart';
import 'package:how_to_use_provider/models/singleton_classes/app_singleton.dart';
import 'package:http/http.dart' as http;

class AppLaunchServices {
  final String baseUrl =
      'https://signlang-ai-main-et3a0s.laravel.cloud/api';

  Future<UserMetricModel> fetchUserMetricOverview() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user-metric/${AppSingleton().userId}'));
      print(AppSingleton().userId);
      print(response.statusCode);
      print('Response body: ${response.body}'); // Log JSON received
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserMetricModel.fromJson(data);
      } else {
        throw Exception('Failed to load data: Status code ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}