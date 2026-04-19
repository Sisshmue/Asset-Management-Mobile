import 'dart:async';
import 'package:asset_management_mobile/features/assets/presentation/viewmodel/asset_view_model.dart';
import 'package:asset_management_mobile/features/assets/presentation/widgets/metric_loading_shimmer.dart';
import 'package:asset_management_mobile/features/assets/presentation/widgets/search_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/metric/metric_view_model_provider.dart';
import '../widgets/asset_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/metric_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _search = '';
  String _filter = 'All';
  final _searchController = TextEditingController();
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(assetViewModelProvider.notifier).fetchMoreAssets();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetListState = ref.watch(assetViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildMetrics()),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Asset dashboard',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'Overview of all registered assets',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    final metrics = ref.watch(metricViewModelProvider);

    return metrics.when(
      data: (metric) {
        if (metric == null || metric.counts.isEmpty) {
          return const SizedBox.shrink();
        }

        final entries = metric.counts.entries.toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final item = entries[index];

                final label = _formatStatus(item.key);
                final count = item.value;

                return MetricCard(
                  label: label,
                  value: count.toString(),
                  valueColor: _getStatusColor(item.key),
                );
              },
            ),
          ),
        );
      },
      error: (e, st) => const SizedBox.shrink(),
      loading: () => const MetricLoadingShimmer(),
    );
  }

  String _formatStatus(String status) {
    return status
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'AVAILABLE':
        return const Color(0xFF2E7D32);
      case 'ASSIGNED':
        return const Color(0xFF1565C0);
      case 'MAINTENANCE':
        return const Color(0xFFF9A825);
      case 'RETIRED':
        return const Color(0xFF616161);
      case 'PENDING':
        return const Color(0xFFEF6C00);
      case 'LOST':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF424242);
    }
  }
}
