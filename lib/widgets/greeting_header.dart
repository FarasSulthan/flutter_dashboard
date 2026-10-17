import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import 'neo_button.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 540;

        final titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                const Text(
                  'Selamat pagi, Anisa!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: NeoColors.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: NeoColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: NeoColors.border, width: 2),
                  ),
                  child: const Text(
                    '👋 ADMIN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: NeoColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Inilah ringkasan performa bisnis Anda hari ini.',
              style: TextStyle(
                color: NeoColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

        final actionButton = NeoButton.icon(
          onPressed: () => _showAddOrderDialog(context),
          icon: const Icon(Icons.add_circle_outline_rounded, color: NeoColors.textDark),
          label: const Text('Pesanan baru'),
          color: NeoColors.primary,
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSection,
              const SizedBox(height: 14),
              actionButton,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleSection),
            const SizedBox(width: 12),
            actionButton,
          ],
        );
      },
    );
  }

  void _showAddOrderDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shopping_bag_outlined, color: NeoColors.textDark),
            SizedBox(width: 10),
            Text(
              'Pesanan Baru',
              style: TextStyle(fontWeight: FontWeight.w900, color: NeoColors.textDark),
            ),
          ],
        ),
        content: const Text(
          'Form pembuatan pesanan siap ditambahkan di tahap berikutnya.',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          NeoButton(
            onPressed: () => Navigator.pop(context),
            color: NeoColors.cardYellow,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 8,
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
