import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import 'neo_card.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({
    super.key,
    this.labels = const ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
    this.values = const [3000000, 5400000, 4100000, 7000000, 5800000, 8600000, 7600000],
  });

  final List<String> labels;
  final List<num> values;

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Penjualan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: NeoColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pendapatan 7 hari terakhir',
                      style: TextStyle(
                        color: NeoColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: NeoTheme.boxDecoration(
                  color: NeoColors.primary,
                  radius: 8,
                  borderWidth: 2,
                  shadow: const Offset(2, 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: '7 Hari',
                    icon: const Icon(Icons.arrow_drop_down, color: NeoColors.textDark),
                    style: const TextStyle(
                      color: NeoColors.textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                    items: const [
                      DropdownMenuItem(value: '7 Hari', child: Text('7 Hari')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 210,
            width: double.infinity,
            child: CustomPaint(
              painter: _NeoLineChartPainter(values),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: labels.map(_ChartLabel.new).toList(),
          ),
        ],
      ),
    );
  }
}

class _ChartLabel extends StatelessWidget {
  final String label;
  const _ChartLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: NeoColors.textDark,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _NeoLineChartPainter extends CustomPainter {
  _NeoLineChartPainter(this.values);

  final List<num> values;

  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x1F000000)
      ..strokeWidth = 1.5;

    for (var i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final chartValues = values.isEmpty ? const <num>[0] : values;
    final highest = chartValues.reduce((current, next) => current > next ? current : next);
    final normalizedValues = chartValues
        .map((value) => highest <= 0 ? 0.0 : value / highest)
        .toList();
    final points = List.generate(
      normalizedValues.length,
      (index) => Offset(
        normalizedValues.length == 1 ? size.width / 2 : index * size.width / (normalizedValues.length - 1),
        size.height * (1 - normalizedValues[index]),
      ),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      linePath.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
    }

    // Fill below path with Neobrutal Yellow tint
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()..color = const Color(0x59FFDE59),
    );

    // Thick black path stroke
    canvas.drawPath(
      linePath,
      Paint()
        ..color = NeoColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw Data Point Markers (Neobrutal Yellow Circles with solid black outline)
    for (final point in points) {
      // Outer shadow/border
      canvas.drawCircle(point, 7, Paint()..color = NeoColors.border);
      // Inner fill
      canvas.drawCircle(point, 4, Paint()..color = NeoColors.primary);
    }
  }

  @override
  bool shouldRepaint(covariant _NeoLineChartPainter oldDelegate) => oldDelegate.values != values;
}
