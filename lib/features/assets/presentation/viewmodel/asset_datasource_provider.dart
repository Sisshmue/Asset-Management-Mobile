import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/asset_remote_datasource.dart';

final assetDataSourceProvider = Provider<AssetRemoteDatasource>((ref) {
  final dio = ref.read(dioProvider);
  return AssetRemoteDatasource(dio);
});
