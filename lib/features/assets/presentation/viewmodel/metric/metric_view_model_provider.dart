import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/metirc_model.dart';
import 'metric_repo_provider.dart';

final metricViewModelProvider = AsyncNotifierProvider<MetricViewModel, Metric?>(
  MetricViewModel.new,
);

class MetricViewModel extends AsyncNotifier<Metric?> {
  @override
  Future<Metric?> build() async {
    final repo = ref.read(metricRepoProvider);
    final res = await repo.getMetrics();
    return res;
  }

  Future<void> getMetric() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(metricRepoProvider);
      final response = await repo.getMetrics();
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
