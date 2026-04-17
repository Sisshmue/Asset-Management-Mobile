import 'dart:async';
import 'package:asset_management_mobile/features/assets/data/model/asset_model.dart';
import 'package:asset_management_mobile/features/assets/presentation/viewmodel/asset_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/asset_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/metric_card.dart';
import '../widgets/filter_chip.dart';

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
        child: assetListState.when(
          loading: () => const LoadingShimmer(),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (assets) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildMetrics(assets)),
                SliverToBoxAdapter(child: _buildSearchAndFilters()),
                assets.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No assets found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => AssetCard(asset: assets[index]),
                            childCount: assets.length,
                          ),
                        ),
                      ),
              ],
            );
          },
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

  Widget _buildMetrics(List<Asset> assets) {
    int count(String s) =>
        assets.where((a) => (a.status ?? '').toUpperCase() == s).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          MetricCard(
            label: 'Total',
            value: '${assets.length}',
            valueColor: Colors.black87,
          ),
          const SizedBox(width: 10),
          MetricCard(
            label: 'Available',
            value: '${count('ACTIVE')}',
            valueColor: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 10),
          MetricCard(
            label: 'Maintena..',
            value: '${count('MAINTENANCE')}',
            valueColor: const Color(0xFFF57F17),
          ),
          const SizedBox(width: 10),
          MetricCard(
            label: 'Inactive',
            value: '${count('INACTIVE')}',
            valueColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    final filters = [
      'All',
      'AVAILABLE',
      'MAINTENANCE',
      'ASSIGNED',
      'RETIRED',
      'PENDING',
      'LOST',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (v) {
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
            decoration: InputDecoration(
              hintText: 'Search by name or serial no...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChipWidget(
                    label: f == 'All'
                        ? 'All'
                        : f[0] + f.substring(1).toLowerCase(),
                    selected: _filter == f,
                    onTap: () {
                      setState(() => _filter = f);

                      ref
                          .read(assetViewModelProvider.notifier)
                          .filterAssets(
                            name: _search,
                            status: f == 'All' ? '' : f,
                          );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
