import 'package:flutter/material.dart';
import '../models/quick_action.dart';
import '../theme/neo_colors.dart';
import 'neo_card.dart';

class QuickActionsGrid extends StatelessWidget {
  final ValueChanged<int>? onActionSelected;

  const QuickActionsGrid({super.key, this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    const actions = [
      QuickActionModel('Tambah Produk', Icons.add_box_rounded, NeoColors.cardYellow),
      QuickActionModel('Lihat Laporan', Icons.bar_chart_rounded, NeoColors.cardBlue),
      QuickActionModel('Data Pelanggan', Icons.group_rounded, NeoColors.cardOrange),
      QuickActionModel('Buat Promo', Icons.local_offer_rounded, NeoColors.cardGreen),
    ];

    return NeoCard(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: NeoColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Akses fitur yang sering digunakan',
            style: TextStyle(
              color: NeoColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _QuickActionTile(
                action: actions[0],
                onTap: () => onActionSelected?.call(3), // Produk
              ),
              _QuickActionTile(
                action: actions[1],
                onTap: () => onActionSelected?.call(4), // Laporan
              ),
              _QuickActionTile(
                action: actions[2],
                onTap: () => onActionSelected?.call(2), // Pelanggan
              ),
              _QuickActionTile(
                action: actions[3],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Promo akan segera hadir!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final QuickActionModel action;
  final VoidCallback onTap;

  const _QuickActionTile({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      backgroundColor: action.color,
      shadowOffset: const Offset(3, 3),
      borderWidth: 2,
      borderRadius: 10,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: NeoColors.border, width: 2),
              ),
              child: Icon(action.icon, color: NeoColors.textDark, size: 20),
            ),
            Text(
              action.label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: NeoColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
