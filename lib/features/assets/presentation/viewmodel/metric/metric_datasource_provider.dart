import 'package:asset_management_mobile/core/network/dio_client.dart';
import 'package:riverpod/riverpod.dart';
import '../../../data/datasources/metric_remote_datasource.dart';

final metricDatasourceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return MetricRemoteDatasource(dio);
});
