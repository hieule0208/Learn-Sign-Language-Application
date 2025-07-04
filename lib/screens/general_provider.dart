import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/user_metric_model.dart';

class MetricNotifier extends StateNotifier<UserMetricModel?> {
  MetricNotifier() : super(null);

  void setState(UserMetricModel metric) => state = metric;
  void reset() => state = null;
}

final metricProvider = StateNotifierProvider<MetricNotifier, UserMetricModel?>(
  (ref) => MetricNotifier(),
);
