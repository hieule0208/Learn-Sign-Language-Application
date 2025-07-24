import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/user_metric_model.dart';
import 'package:how_to_use_provider/screens/dictionary/controller/dict_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_provider.dart';
import 'package:how_to_use_provider/services/app_launch_services.dart';

class UserMetricOverviewStateNotifier extends StateNotifier<UserMetricModel> {
  final Ref ref;
  UserMetricOverviewStateNotifier(this.ref) : super(UserMetricModel.initial()) {
    initialize();
  }

  Future<void> initialize() async {
    try {
      final apiService = AppLaunchServices();
      state = await apiService.fetchUserMetricOverview();
      log("UserMetricOverviewStateNotifier: Fetched metrics - ${state.totalScore}");

      // Kích hoạt LearnDataStateNotifier
      await ref.read(learnDataStateProvider.notifier).initialize();
      log(
        "UserMetricOverviewStateNotifier: Initialized LearnDataStateNotifier",
      );

      // Kích hoạt DictDataStateNotifier
      await ref.read(dictDataStateProvider.notifier).initialize();
      log(
        "UserMetricOverviewStateNotifier: Initialized DictDataStateNotifier",
        name: 'UserMetricOverview',
      );

      // Kích hoạt TopicDataStateNotifier
      await ref.read(topicDataStateProvider.notifier).initialize();
      log(
        "UserMetricOverviewStateNotifier: Initialized TopicDataStateNotifier",
        name: 'UserMetricOverview',
      );
    } catch (e, stackTrace) {
      log(
        "UserMetricOverviewStateNotifier: Error - $e",
        error: e,
        stackTrace: stackTrace,
      );
      state = UserMetricModel.initial();
    }
  }

  void reset() => state = UserMetricModel.initial();
}

final userMetricOverviewStateProvider =
    StateNotifierProvider<UserMetricOverviewStateNotifier, UserMetricModel>(
      (ref) => UserMetricOverviewStateNotifier(ref),
    );
