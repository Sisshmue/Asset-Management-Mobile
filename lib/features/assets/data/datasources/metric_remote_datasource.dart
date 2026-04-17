import 'package:asset_management_mobile/features/assets/data/model/metirc_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';

class MetricRemoteDatasource {
  final Dio dio;
  MetricRemoteDatasource(this.dio);

  Future<Metric> getMetics() async {
    try {
      final response = await dio.get('/api/assets/metric');
      return Metric.fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
