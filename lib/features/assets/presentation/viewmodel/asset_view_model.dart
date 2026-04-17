import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/asset_model.dart';
import 'asset_repo_provider.dart';

final assetViewModelProvider =
    AsyncNotifierProvider<AssetViewModel, List<Asset>>(AssetViewModel.new);

class AssetViewModel extends AsyncNotifier<List<Asset>> {
  @override
  Future<List<Asset>> build() {
    final repo = ref.read(assetRepoProvider);
    return repo.getAllAssets(page: 1, limit: 10);
  }

  Future<void> fetchAllAssets({int page = 1, int limit = 10}) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(assetRepoProvider);
      final response = await repo.getAllAssets(page: page, limit: limit);
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> filterAssets({
    String name = "",
    String status = "",
    int page = 1,
    int limit = 10,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(assetRepoProvider);
      final response = await repo.filterAssets(
        name: name,
        status: status,
        page: page,
        limit: limit,
      );
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
