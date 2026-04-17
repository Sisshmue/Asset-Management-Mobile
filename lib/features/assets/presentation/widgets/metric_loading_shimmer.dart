import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MetricLoadingShimmer extends StatelessWidget {
  const MetricLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: List.generate(
            3,
            (index) => Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
