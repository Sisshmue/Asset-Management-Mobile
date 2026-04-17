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
      final assetList = response.data['assets'];
      if (assetList is List) {
        return assetList.map<Asset>((a) => Asset.fromJson(a)).toList();
      } else {
        throw ApiException(message: 'Response is not a list');
      }
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<List<Asset>> filerAssets(
    int page,
    int limit,
    String name,
    String status,
  ) async {
    try {
      final response = await dio.get(
        '/api/assets/find',
        data: {"page": page, "limit": limit, "name": name, "status": status},
      );
      final assetList = response.data['assets'];
      if (assetList is List) {
        return assetList.map<Asset>((a) => Asset.fromJson(a)).toList();
      } else {
        throw ApiException(message: 'Response is not a list');
      }
    } catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
