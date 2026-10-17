import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import 'search_box.dart';

class TopBar extends StatelessWidget {
  final bool showMenuButton;
  final VoidCallback onMenuTap;

  const TopBar({
    super.key,
    required this.showMenuButton,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 480 ? 12.0 : 20.0;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
        color: NeoColors.background,
        border: Border(
          bottom: BorderSide(color: NeoColors.border, width: 2.5),
        ),
      ),
      child: Row(
        children: [
          if (showMenuButton) ...[
            GestureDetector(
              onTap: onMenuTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: NeoTheme.boxDecoration(
                  color: NeoColors.primary,
                  radius: 8,
                  borderWidth: 2,
                  shadow: const Offset(2, 2),
                ),
                child: const Icon(Icons.menu_rounded, color: NeoColors.textDark),
              ),
            ),
            const SizedBox(width: 14),
          ],
          const Expanded(child: SearchBox()),
          const SizedBox(width: 16),

          // Notification Button with Neobrutal Badge
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anda memiliki 3 notifikasi baru.')),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: NeoTheme.boxDecoration(
                    color: Colors.white,
                    radius: 10,
                    borderWidth: 2,
                    shadow: const Offset(2.5, 2.5),
                  ),
                  child: const Icon(Icons.notifications_none_rounded, color: NeoColors.textDark, size: 22),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: NeoColors.cardPink,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: NeoColors.border, width: 2),
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: NeoColors.textDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // User Avatar with Neobrutal Border
          Container(
            padding: const EdgeInsets.all(8),
            decoration: NeoTheme.boxDecoration(
              color: NeoColors.cardPurple,
              radius: 10,
              borderWidth: 2,
              shadow: const Offset(2.5, 2.5),
            ),
            child: const Text(
              'AN',
              style: TextStyle(
                color: NeoColors.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
