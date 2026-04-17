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

  String get _initials {
    final parts = (asset.name ?? '?').split(' ');
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }

  Color get _avatarColor {
    final colors = [
      const Color(0xFFE6F1FB),
      const Color(0xFFE1F5EE),
      const Color(0xFFEEEDFE),
      const Color(0xFFFAECE7),
    ];
    return colors[(asset.id ?? 0) % colors.length];
  }

  Color get _avatarTextColor {
    final colors = [
      const Color(0xFF0C447C),
      const Color(0xFF085041),
      const Color(0xFF3C3489),
      const Color(0xFF712B13),
    ];
    return colors[(asset.id ?? 0) % colors.length];
  }

  ({Color bg, Color text}) get _statusStyle {
    switch ((asset.status ?? '').toUpperCase()) {
      case 'AVAILABLE':
        return (bg: const Color(0xFFE8F5E9), text: const Color(0xFF2E7D32));
      case 'MAINTENANCE':
        return (bg: const Color(0xFFFFF8E1), text: const Color(0xFFF57F17));
      case 'ASSIGNED':
        return (bg: const Color(0xFFE3F2FD), text: const Color(0xFF1565C0));
      default:
        return (bg: const Color(0xFFF5F5F5), text: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      child: Row(
        children: [
          /// Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _avatarColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _initials,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _avatarTextColor,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Info
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  asset.serialNo ?? '–',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// Right side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: status.bg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  (asset.status ?? 'Unknown'),
                  style: TextStyle(
                    fontSize: 11,
                    color: status.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(asset.createdAt),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
