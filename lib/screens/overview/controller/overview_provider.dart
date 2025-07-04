import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/user_metric_model.dart';
import 'package:how_to_use_provider/services/app_launch_services.dart';

final userMetricOverview = FutureProvider<UserMetricModel>((ref) async {
  final apiService = AppLaunchServices();
  return apiService.fetchUserMetricOverview();
});
