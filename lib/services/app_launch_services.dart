import 'dart:convert';
import 'package:how_to_use_provider/models/data_models/user_metric_model.dart';
import 'package:http/http.dart' as http;

class AppLaunchServices {
  final String baseUrl =
      'https://685e100b7b57aebd2af7edd5.mockapi.io/sign-language';

  Future<UserMetricModel> fetchUserMetricOverview() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user-overview'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final Map<String, dynamic> userData = data[0];
          return UserMetricModel.fromJson(userData);
        } else {
          throw Exception('No data found in response');
        }
      } else {
        throw Exception('Failed to load data: Status code ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}