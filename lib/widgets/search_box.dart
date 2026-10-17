import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Container(
        decoration: NeoTheme.boxDecoration(
          color: Colors.white,
          radius: 10,
          borderWidth: 2.5,
          shadow: const Offset(3, 3),
        ),
        child: TextField(
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mencari "$value"...')),
              );
            }
          },
          style: const TextStyle(
            color: NeoColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            hintText: 'Cari data...',
            hintStyle: TextStyle(
              color: NeoColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(Icons.search_rounded, color: NeoColors.textDark),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
    );
  }
}
