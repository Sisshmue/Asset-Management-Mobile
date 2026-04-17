import 'package:dio/dio.dart';
import '../../../../core/network/api_exception.dart';
import '../model/asset_model.dart';

class AssetRemoteDatasource {
  final Dio dio;
  AssetRemoteDatasource(this.dio);

  Future<List<Asset>> getAllAssets({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/api/assets/all',
        queryParameters: {"page": page, "limit": 10},
      );
      if (response.data is List) {
        return response.data.map<Asset>((a) => Asset.fromJson(a)).toList();
      } else {
        throw ApiException(message: 'Response is not a list');
      }
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
