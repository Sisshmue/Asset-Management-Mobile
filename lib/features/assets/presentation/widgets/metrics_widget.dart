import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/metric/metric_view_model_provider.dart';
import 'metric_card.dart';
import 'metric_loading_shimmer.dart';

class MetricsWidget extends ConsumerWidget {
  const MetricsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String formatStatus(String status) {
      return status
          .toLowerCase()
          .replaceAll('_', ' ')
          .split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }

    Color getStatusColor(String status) {
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

                final label = formatStatus(item.key);
                final count = item.value;

                return MetricCard(
                  label: label,
                  value: count.toString(),
                  valueColor: getStatusColor(item.key),
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
}
