import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';

class NeoButton extends StatefulWidget {
  final Widget? child;
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const NeoButton({
    super.key,
    this.child,
    this.label,
    this.icon,
    required this.onPressed,
    this.color = NeoColors.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    this.borderRadius = 10.0,
  });

  factory NeoButton.icon({
    Key? key,
    required VoidCallback onPressed,
    required Widget icon,
    required Widget label,
    Color color = NeoColors.primary,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    double borderRadius = 10.0,
  }) {
    return NeoButton(
      key: key,
      onPressed: onPressed,
      color: color,
      padding: padding,
      borderRadius: borderRadius,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          label,
        ],
      ),
    );
  }

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final offset = _isPressed ? const Offset(1, 1) : const Offset(4, 4);

    Widget innerChild;
    if (widget.child != null) {
      innerChild = widget.child!;
    } else {
      innerChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 18, color: NeoColors.textDark),
            const SizedBox(width: 8),
          ],
          if (widget.label != null)
            Text(
              widget.label!,
              style: const TextStyle(
                color: NeoColors.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
        ],
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(
          _isPressed ? 3.0 : 0.0,
          _isPressed ? 3.0 : 0.0,
          0.0,
        ),
        decoration: NeoTheme.boxDecoration(
          color: widget.color,
          radius: widget.borderRadius,
          borderWidth: NeoTheme.borderThickness,
          shadow: offset,
        ),
        padding: widget.padding,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: NeoColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          child: innerChild,
        ),
      ),
    );
  }
}
