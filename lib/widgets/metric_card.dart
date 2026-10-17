import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import 'neo_card.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      backgroundColor: color,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: NeoColors.border, width: 2),
                ),
                child: Icon(icon, color: NeoColors.textDark, size: 22),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoColors.border, width: 2),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: NeoColors.textDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              color: NeoColors.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: NeoColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
