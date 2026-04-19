import 'package:flutter/material.dart';
import 'filter_chip.dart';

class SearchFilterWidget extends StatefulWidget {
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
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final filters = [
    'All',
    'AVAILABLE',
    'MAINTENANCE',
    'ASSIGNED',
    'RETIRED',
    'PENDING',
    'LOST',
  ];

  @override
  Widget build(BuildContext context) {
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
                    selected: widget.filer == f,
                    onTap: () => widget.onTap?.call(f),
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
