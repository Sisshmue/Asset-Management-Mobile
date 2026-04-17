import 'package:asset_management_mobile/features/assets/presentation/viewmodel/asset_datasource_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/asset_repository.dart';

final assetRepoProvider = Provider<AssetRepository>((ref) {
  final assetRemoteDatasource = ref.read(assetDataSourceProvider);
  return AssetRepository(assetRemoteDatasource);
});
