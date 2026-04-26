import 'package:asset_management_mobile/features/assets/presentation/viewmodel/metric/metric_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'filter_chip.dart';

class SearchFilterWidget extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final String filer;
  final void Function(String)? onChange;
  final void Function(String)? onTap;
  const SearchFilterWidget({
    super.key,
    required this.searchController,
    required this.filer,
    this.onChange,
    this.onTap,
  });

  @override
  ConsumerState<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends ConsumerState<SearchFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final metricProvider = ref.watch(metricViewModelProvider);
    final _filters = ['All'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: widget.searchController,
            onChanged: widget.onChange,
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
          metricProvider.when(
            data: (metrics) {
              final filters = metrics?.counts.keys.toList();
              setState(() {
                _filters.addAll(filters!);
              });
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChipWidget(
                        label: f == 'All'
                            ? 'All'
                            : f[0] + f.substring(1).toLowerCase(),
                        selected: widget.filer == f,
                        onTap: () => widget.onTap?.call(f),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
            error: (e, st) => const SizedBox.shrink(),
            loading: () => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.white,
              child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
