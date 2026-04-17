import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/model/asset_model.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  const AssetCard({super.key, required this.asset});

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
    return ListTile(
      title: Text(asset.name ?? '–'),
      subtitle: Text(asset.serialNo ?? '–'),
      trailing: Text(_formatDate(asset.createdAt)),
    );
  }
}
