import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';

final dictDataProvider = FutureProvider<List<WordModel>>((ref) async {
  final apiService = ApiServices();
  return apiService.fetchMyWordData();
});
