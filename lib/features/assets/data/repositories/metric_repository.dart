import 'package:asset_management_mobile/features/assets/data/datasources/metric_remote_datasource.dart';
import '../model/metirc_model.dart';

class MetricRepository {
  final MetricRemoteDatasource metricRemoteDatasource;
  MetricRepository(this.metricRemoteDatasource);

  Future<Metric> getMetrics() async {
    return await metricRemoteDatasource.getMetics();
  }
}
