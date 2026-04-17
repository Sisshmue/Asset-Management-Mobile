import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/asset_model.dart';
import 'asset_repo_provider.dart';

final assetViewModelProvider =
    AsyncNotifierProvider<AssetViewModel, List<Asset>>(AssetViewModel.new);

class AssetViewModel extends AsyncNotifier<List<Asset>> {
  int _page = 1;
  final int _limit = 10;
  bool hasMore = true;
  bool _isLoadingMore = false;
  String _currentName = "";
  String _currentStatus = "";

  @override
  Future<List<Asset>> build() async {
    final repo = ref.read(assetRepoProvider);
    final res = await repo.filterAssets(page: _page, limit: _limit);
    hasMore = res.length == _limit;
    return res;
  }

  Future<void> fetchMoreAssets({int page = 1, int limit = 10}) async {
    if (_isLoadingMore || !hasMore) return;
    _isLoadingMore = true;
    _page++;
    try {
      final repo = ref.read(assetRepoProvider);
      final newData = await repo.filterAssets(
        page: _page,
        limit: _limit,
        name: _currentName,
        status: _currentStatus,
      );
      hasMore = newData.length == _limit;
      state = AsyncData([...state.value!, ...newData]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
    _isLoadingMore = false;
  }

  // Future<void> fetchAllAssets({int page = 1, int limit = 10}) async {
  //   state = const AsyncLoading();
  //   try {
  //     final repo = ref.read(assetRepoProvider);
  //     final response = await repo.getAllAssets(page: page, limit: limit);
  //     state = AsyncData(response);
  //   } catch (e, st) {
  //     state = AsyncError(e, st);
  //   }
  // }

  Future<void> filterAssets({String name = "", String status = ""}) async {
    _page = 1;
    hasMore = true;
    _isLoadingMore = false;
    state = const AsyncLoading();
    _currentName = name;
    _currentStatus = status;
    try {
      final repo = ref.read(assetRepoProvider);
      final response = await repo.filterAssets(
        name: name,
        status: status,
        page: _page,
        limit: _limit,
      );
      hasMore = response.length == _limit;
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
