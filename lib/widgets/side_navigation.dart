import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';

class SideNavigation extends StatelessWidget {
  final List<MenuItemModel> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const SideNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: NeoColors.sidebarBg,
        border: Border(
          right: BorderSide(color: NeoColors.border, width: 2.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Brand
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: NeoTheme.boxDecoration(
                    color: NeoColors.primary,
                    radius: 8,
                    borderWidth: 2,
                    shadow: const Offset(2, 2),
                  ),
                  child: const Icon(Icons.bolt_rounded, color: NeoColors.textDark, size: 22),
                ),
                const SizedBox(width: 12),
                const Text(
                  'FARASHA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Menu items
          ...items.asMap().entries.map(
                (entry) => _NavItem(
                  item: entry.value,
                  selected: entry.key == selectedIndex,
                  onTap: () => onSelected(entry.key),
                ),
              ),

          const Spacer(),
          const Divider(color: Color(0xFF3F3F46), height: 32),
          _NavItem(
            item: const MenuItemModel('Pengaturan', Icons.settings_outlined),
            selected: selectedIndex == 5,
            onTap: () => onSelected(5),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final MenuItemModel item;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: selected
              ? NeoTheme.boxDecoration(
                  color: NeoColors.primary,
                  radius: 10,
                  borderWidth: 2,
                  shadow: const Offset(3, 3),
                )
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: selected ? NeoColors.textDark : Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: TextStyle(
                  color: selected ? NeoColors.textDark : Colors.white70,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
