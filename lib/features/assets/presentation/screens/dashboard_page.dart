import 'package:asset_management_mobile/features/assets/data/model/asset_model.dart';
import 'package:asset_management_mobile/features/assets/presentation/viewmodel/asset_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _search = '';
  String _filter = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Asset> _applyFilters(List<Asset> assets) {
    return assets.where((a) {
      final matchStatus =
          _filter == 'All' || (a.status ?? '').toUpperCase() == _filter;
      final q = _search.toLowerCase();
      final matchSearch =
          q.isEmpty ||
          (a.name ?? '').toLowerCase().contains(q) ||
          (a.serialNo ?? '').toLowerCase().contains(q);
      return matchStatus && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final assetListState = ref.watch(assetViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
        child: assetListState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (assets) {
            final filtered = _applyFilters(assets);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(child: _buildMetrics(assets)),
                SliverToBoxAdapter(child: _buildSearchAndFilters()),
                filtered.isEmpty
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
                            (context, index) =>
                                _AssetCard(asset: filtered[index]),
                            childCount: filtered.length,
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
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add asset'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF185FA5),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 13),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          _MetricCard(
            label: 'Total',
            value: '${assets.length}',
            valueColor: Colors.black87,
          ),
          const SizedBox(width: 10),
          _MetricCard(
            label: 'Active',
            value: '${count('ACTIVE')}',
            valueColor: const Color(0xFF2E7D32),
          ),
          const SizedBox(width: 10),
          _MetricCard(
            label: 'Maintenance',
            value: '${count('MAINTENANCE')}',
            valueColor: const Color(0xFFF57F17),
          ),
          const SizedBox(width: 10),
          _MetricCard(
            label: 'Inactive',
            value: '${count('INACTIVE')}',
            valueColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search by name or serial no...',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 0.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'ACTIVE', 'MAINTENANCE', 'INACTIVE']
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: f == 'All'
                            ? 'All'
                            : f[0] + f.substring(1).toLowerCase(),
                        selected: _filter == f,
                        onTap: () => setState(() => _filter = f),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  const _MetricCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDCEDFA) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFF185FA5) : const Color(0xFFDDDDDD),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? const Color(0xFF185FA5) : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _AssetCard extends StatelessWidget {
  final Asset asset;
  const _AssetCard({required this.asset});

  Color get _avatarColor {
    final colors = [
      const Color(0xFFE6F1FB),
      const Color(0xFFE1F5EE),
      const Color(0xFFEEEDFE),
      const Color(0xFFFAECE7),
      const Color(0xFFFAEEDA),
    ];
    return colors[(asset.id ?? 0) % colors.length];
  }

  Color get _avatarTextColor {
    final colors = [
      const Color(0xFF0C447C),
      const Color(0xFF085041),
      const Color(0xFF3C3489),
      const Color(0xFF712B13),
      const Color(0xFF633806),
    ];
    return colors[(asset.id ?? 0) % colors.length];
  }

  String get _initials {
    final parts = (asset.name ?? '?').split(' ');
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  ({Color bg, Color text, Color dot}) get _statusStyle {
    switch ((asset.status ?? '').toUpperCase()) {
      case 'ACTIVE':
        return (
          bg: const Color(0xFFE8F5E9),
          text: const Color(0xFF2E7D32),
          dot: const Color(0xFF2E7D32),
        );
      case 'MAINTENANCE':
        return (
          bg: const Color(0xFFFFF8E1),
          text: const Color(0xFFF57F17),
          dot: const Color(0xFFF57F17),
        );
      default:
        return (
          bg: const Color(0xFFF5F5F5),
          text: Colors.grey,
          dot: Colors.grey,
        );
    }
  }

  String _formatDate(String? raw) {
    if (raw == null) return '–';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _statusStyle;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _avatarColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _initials,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _avatarTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name ?? '–',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        asset.description ?? '–',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: s.bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: s.dot,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        (asset.status ?? 'Unknown')[0] +
                            (asset.status ?? 'Unknown')
                                .substring(1)
                                .toLowerCase(),
                        style: TextStyle(fontSize: 12, color: s.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Serial no.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  asset.serialNo ?? '–',
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Added',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _formatDate(asset.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
