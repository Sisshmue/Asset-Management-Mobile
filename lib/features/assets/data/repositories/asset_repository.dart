import 'package:asset_management_mobile/features/assets/data/datasources/asset_remote_datasource.dart';
import 'package:asset_management_mobile/features/assets/data/model/create_asset_model.dart';
import '../model/asset_model.dart';

class AssetRepository {
  final AssetRemoteDatasource _assetRemoteDatasource;
  AssetRepository(this._assetRemoteDatasource);

  Future<List<Asset>> getAllAssets({int page = 1, int limit = 10}) async {
    return await _assetRemoteDatasource.getAllAssets(page: page, limit: limit);
  }

  Future<String> createNewAsset(List<CreateAssetModel> assets) async {
    return await _assetRemoteDatasource.createNewAsset(assets);
  }

  Future<List<Asset>> filterAssets({
    String name = "",
    String status = "",
    int page = 1,
    int limit = 10,
  }) async {
    return await _assetRemoteDatasource.filerAssets(page, limit, name, status);
  }
}
