import 'dart:convert';
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/models/singleton_classes/app_singleton.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_provider.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class ApiServices {
  Future<List<DataLearnModel>> fetchLearnData() async {
    final baseUrl = 'https://signlang-ai-main-et3a0s.laravel.cloud/api';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/learn/${AppSingleton().userId}'),
      );
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
    final baseURL = "https://signlang-ai-main-et3a0s.laravel.cloud/api";
    try {
      final response = await http.get(
        Uri.parse("$baseURL/topic-list/${AppSingleton().userId}"),
      );
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
    final baseURL = "https://signlang-ai-main-et3a0s.laravel.cloud/api";
    try {
      final response = await http.get(
        Uri.parse("$baseURL/my-word-list/${AppSingleton().userId}"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("data dict $data");
        return data.map((json) => WordModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<List<WordModel>> fetchWordOfTopicData(dynamic ref) async {
    final baseUrl = "https://signlang-ai-main-et3a0s.laravel.cloud/api";
    final chosenTopic = ref.watch(chosenTopicProvider)?.id;

    try {
      final response = await http.get(
        Uri.parse(
          "$baseUrl/topic/$chosenTopic/word-list/${AppSingleton().userId}",
        ),
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

  Future<List<WordModel>> fetchWordForWrongPage(dynamic ref) async {
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

  Future<bool> postUpdatedWords(List<WordModel> words, int score) async {
    final baseURL = "https://signlang-ai-main-et3a0s.laravel.cloud/api";
    try {
      final data = {
        'score': score,
        'words': words.map((word) => word.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseURL/update-words/${AppSingleton().userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        print("🎉 POST thành công");
        print('POST successful: ${response.body}');
        return true;
      } else {
        print("⚠️ POST thất bại (status != 200)");
        throw Exception(
          'Failed to post updated words: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print("❌ POST gặp lỗi exception");
      throw Exception('Error posting updated words: $e');
    }
  }

  Future<String?> postCapturedImage(XFile image) async {
    String apiUrl =
        "https://sign-language-api-53044935237.asia-southeast1.run.app";
    final Uri predictUrl = Uri.parse("$apiUrl/predict");

    try {
      // Tạo một yêu cầu POST dạng multipart
      final request = http.MultipartRequest("POST", predictUrl);

      // ==========================================================
      // --- PHẦN SỬA ĐỔI QUAN TRỌNG NẰM Ở ĐÂY ---
      // Chúng ta sẽ tạo đối tượng MultipartFile một cách tường minh hơn
      // ==========================================================
      final fileStream = http.ByteStream(image.openRead());
      final fileLength = await image.length();

      final multipartFile = http.MultipartFile(
        'file', // <-- Tên trường (field name) phải là 'file'
        fileStream,
        fileLength,
        filename: path.basename(image.path), // Tên file
      );

      // Thêm file đã được tạo vào yêu cầu
      request.files.add(multipartFile);

      print('🚀 Sending image to API at $predictUrl');
      final streamedResponse = await request.send();

      // Đọc phản hồi
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Xử lý phản hồi JSON (như bạn đã nói API của bạn trả về JSON)
        print('✅ Raw JSON response from server: ${response.body}');
        final Map<String, dynamic> parsedJson = jsonDecode(response.body);
        final String? predictedClass = parsedJson['predicted_class'];

        if (predictedClass != null) {
          return predictedClass;
        } else {
          print('❌ JSON response missing "predicted_class" key.');
          return null;
        }
      } else {
        // In ra lỗi chi tiết từ server để gỡ lỗi
        print(
          '❌ Failed to get prediction. Status code: ${response.statusCode}',
        );
        print('❌ Server Error Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error sending image: $e');
      return null;
    }
  }
}
