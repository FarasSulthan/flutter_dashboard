import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double borderWidth;
  final Offset shadowOffset;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.padding = EdgeInsets.zero,
    this.borderRadius = NeoTheme.borderRadius,
    this.borderWidth = NeoTheme.borderThickness,
    this.shadowOffset = NeoTheme.shadowOffset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: NeoTheme.boxDecoration(
        color: backgroundColor,
        radius: borderRadius,
        borderWidth: borderWidth,
        shadow: shadowOffset,
      ),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
