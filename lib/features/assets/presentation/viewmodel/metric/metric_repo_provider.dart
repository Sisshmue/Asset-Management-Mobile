import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/metric_repository.dart';
import 'metric_datasource_provider.dart';

final metricRepoProvider = Provider((ref) {
  final metricDatasource = ref.read(metricDatasourceProvider);
  return MetricRepository(metricDatasource);
});
