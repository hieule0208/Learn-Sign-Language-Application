import 'dart:convert';
import 'dart:core';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_provider.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl =
      'https://685e100b7b57aebd2af7edd5.mockapi.io/sign-language';

  Future<List<DataLearnModel>> fetchLearnData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/learn-data'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data.map((json) => DataLearnModel.fromJson(json)).toList());
        return data.map((json) => DataLearnModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<TopicModel>> fetchTopicData() async {
    final baseURL = "https://6860ace88e7486408443ba08.mockapi.io/sign-language";
    try {
      final response = await http.get(Uri.parse("$baseURL/topic-list"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TopicModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<WordModel>> fetchMyWordData() async {
    final baseURL = "https://6860ace88e7486408443ba08.mockapi.io/sign-language";
    try {
      final response = await http.get(Uri.parse("$baseURL/my-word-list"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => WordModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<WordModel>> fetchWordOfTopicData(ref) async {
    final baseUrl = "https://6861eed196f0cc4e34b7d031.mockapi.io";
    final chosenTopic = ref.watch(chosenTopicProvider)?.id;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/topic/$chosenTopic/word-list"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => WordModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<WordModel>> fetchWordForWrongPage(ref) async {
    final baseUrl = "https://6861eed196f0cc4e34b7d031.mockapi.io";
    final chosenTopic = ref.watch(chosenTopicProvider)?.id;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/topic/$chosenTopic/word-list"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => WordModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<bool> postUpdatedWords(List<WordModel> words) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updated-words'), // Thay bằng endpoint thực tế
        headers: {
          'Content-Type': 'application/json',
          // Thêm header nếu cần, ví dụ: 'Authorization': 'Bearer token',
        },
        body: jsonEncode(words.map((word) => word.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        print('POST successful: ${response.body}');
        return true;
      } else {
        throw Exception('Failed to post updated words: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error posting updated words: $e');
    }
  }

  
}
