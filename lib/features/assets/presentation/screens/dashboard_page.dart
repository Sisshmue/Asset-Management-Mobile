import 'dart:async';
import 'package:asset_management_mobile/features/assets/presentation/viewmodel/asset_view_model.dart';
import 'package:asset_management_mobile/features/assets/presentation/widgets/header_widget.dart';
import 'package:asset_management_mobile/features/assets/presentation/widgets/search_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/asset_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/metrics_widget.dart';

class DashboardPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const DashboardPage({super.key, required this.scrollController});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _search = '';
  String _filter = 'All';
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent - 200) {
        ref.read(assetViewModelProvider.notifier).fetchMoreAssets();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetListState = ref.watch(assetViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(child: HeaderWidget()),
            SliverToBoxAdapter(child: MetricsWidget()),
            SliverToBoxAdapter(
              child: SearchFilterWidget(
                searchController: _searchController,
                filer: _filter,
                onChange: (v) {
                  setState(() => _search = v);

                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    ref
                        .read(assetViewModelProvider.notifier)
                        .filterAssets(
                          name: v,
                          status: _filter == 'All' ? '' : _filter,
                        );
                  });
                },
                onTap: (f) {
                  setState(() => _filter = f);

                  ref
                      .read(assetViewModelProvider.notifier)
                      .filterAssets(name: _search, status: f == 'All' ? '' : f);
                },
              ),
            ),
            assetListState.when(
              loading: () => const SliverToBoxAdapter(child: LoadingShimmer()),
              error: (e, _) =>
                  SliverToBoxAdapter(child: Center(child: Text(e.toString()))),
              data: (assets) {
                if (assets.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No assets found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == assets.length) {
                        final notifier = ref.read(
                          assetViewModelProvider.notifier,
                        );

                        if (!notifier.hasMore) {
                          return const SizedBox.shrink();
                        }

                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return AssetCard(asset: assets[index]);
                    }, childCount: assets.length + 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
