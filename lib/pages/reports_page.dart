import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/neo_button.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedPeriod = 'Bulan Ini';

  final Map<String, List<double>> _chartData = {
    'Hari Ini': [1.2, 2.5, 1.8, 3.2, 2.9, 4.1],
    'Minggu Ini': [12.5, 18.2, 14.8, 22.1, 19.5, 24.8, 28.3],
    'Bulan Ini': [65.4, 78.2, 85.0, 92.4],
    'Tahun Ini': [120.0, 145.5, 180.2, 210.0],
  };

  final Map<String, List<String>> _chartLabels = {
    'Hari Ini': ['08:00', '10:00', '12:00', '14:00', '16:00', '18:00'],
    'Minggu Ini': ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
    'Bulan Ini': ['Mgg 1', 'Mgg 2', 'Mgg 3', 'Mgg 4'],
    'Tahun Ini': ['Q1', 'Q2', 'Q3', 'Q4'],
  };

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.download_done_rounded, color: NeoColors.textDark),
            SizedBox(width: 8),
            Text('Unduh Laporan Penjualan', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: Text(
          'Laporan Penjualan periode "$_selectedPeriod" siap diunduh dalam format PDF dan Excel.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: NeoColors.textDark, fontWeight: FontWeight.bold)),
          ),
          NeoButton(
            label: 'Unduh PDF',
            color: NeoColors.cardPink,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Laporan PDF ($_selectedPeriod) berhasil diunduh!')),
              );
            },
          ),
          NeoButton(
            label: 'Unduh Excel',
            color: NeoColors.cardGreen,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Laporan Excel ($_selectedPeriod) berhasil diunduh!')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180 ? 4 : width >= 720 ? 2 : 1;
    final isWide = width >= 980;

    final values = _chartData[_selectedPeriod] ?? [10.0, 20.0, 30.0];
    final labels = _chartLabels[_selectedPeriod] ?? ['1', '2', '3'];
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 540;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Laporan & Analitik',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: NeoColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Performa keuangan, grafik omset, dan analisis produk terlaris.',
                      style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    NeoButton(
                      label: 'Unduh Laporan',
                      color: NeoColors.secondary,
                      icon: Icons.file_download_rounded,
                      onPressed: _exportReport,
                    ),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laporan & Analitik',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: NeoColors.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Performa keuangan, grafik omset, dan analisis produk terlaris.',
                          style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  NeoButton(
                    label: 'Unduh Laporan',
                    color: NeoColors.secondary,
                    icon: Icons.file_download_rounded,
                    onPressed: _exportReport,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Period Filter selector bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded, color: NeoColors.textDark),
                    SizedBox(width: 8),
                    Text('Periode Laporan:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ],
                ),
                ...['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Tahun Ini'].map((period) {
                  final selected = _selectedPeriod == period;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = period),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: selected
                          ? NeoTheme.boxDecoration(
                              color: NeoColors.primary,
                              radius: 8,
                              shadow: const Offset(2, 2),
                            )
                          : BoxDecoration(
                              color: NeoColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: NeoColors.border, width: 1.5),
                            ),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                          color: NeoColors.textDark,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Financial KPI Cards
          GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 2.6 : 1.55,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              MetricCard(
                label: 'Total Omset',
                value: 'Rp 92,4 jt',
                change: '+15.8%',
                icon: Icons.payments_rounded,
                color: NeoColors.cardYellow,
              ),
              MetricCard(
                label: 'Laba Bersih (Net)',
                value: 'Rp 34,1 jt',
                change: '+22.4%',
                icon: Icons.trending_up_rounded,
                color: NeoColors.cardGreen,
              ),
              MetricCard(
                label: 'Rata-rata Transaksi',
                value: 'Rp 480 rb',
                change: '+4.1%',
                icon: Icons.receipt_long_rounded,
                color: NeoColors.cardBlue,
              ),
              MetricCard(
                label: 'Tingkat Konversi',
                value: '3.8%',
                change: '+0.5%',
                icon: Icons.auto_graph_rounded,
                color: NeoColors.cardPurple,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Custom Neobrutalist Bar Chart Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grafik Penjualan ($_selectedPeriod)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: NeoTheme.boxDecoration(
                        color: NeoColors.cardGreen,
                        radius: 6,
                        shadow: const Offset(1.5, 1.5),
                        borderWidth: 1.5,
                      ),
                      child: const Text('Target 100% Tercapai', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.successText)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 220,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(values.length, (idx) {
                      final val = values[idx];
                      final heightRatio = val / maxValue;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Rp ${val.toStringAsFixed(1)}jt',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isWide ? 48 : 28,
                            height: 150 * heightRatio,
                            decoration: NeoTheme.boxDecoration(
                              color: idx % 2 == 0 ? NeoColors.primary : NeoColors.secondary,
                              radius: 8,
                              shadow: const Offset(3, 3),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            labels[idx],
                            style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.textDark),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Top Products Ranking Table
          Container(
            padding: const EdgeInsets.all(20),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produk Terlaris (Top 5)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 16),
                _RankRow(rank: 1, name: 'Jaket Neobrutal Yellow', sold: '142 pcs', total: 'Rp 49.700.000', badgeColor: NeoColors.cardYellow),
                _RankRow(rank: 2, name: 'Sepatu Retro Neon Blue', sold: '88 pcs', total: 'Rp 110.000.000', badgeColor: NeoColors.cardBlue),
                _RankRow(rank: 3, name: 'Smartwatch Cyber Sport', sold: '64 pcs', total: 'Rp 134.400.000', badgeColor: NeoColors.cardPurple),
                _RankRow(rank: 4, name: 'Topi Snapback Bold Black', sold: '195 pcs', total: 'Rp 35.100.000', badgeColor: NeoColors.cardOrange),
                _RankRow(rank: 5, name: 'Hoodie Oversized Mint', sold: '52 pcs', total: 'Rp 33.800.000', badgeColor: NeoColors.cardGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final int rank;
  final String name;
  final String sold;
  final String total;
  final Color badgeColor;

  const _RankRow({
    required this.rank,
    required this.name,
    required this.sold,
    required this.total,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: NeoColors.border, width: 1.5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 480;

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: NeoTheme.boxDecoration(
                        color: badgeColor,
                        radius: 8,
                        borderWidth: 2,
                        shadow: const Offset(1.5, 1.5),
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textDark),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sold,
                      style: const TextStyle(color: NeoColors.textMuted, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    Text(
                      total,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF166534)),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: NeoTheme.boxDecoration(
                  color: badgeColor,
                  radius: 8,
                  borderWidth: 2,
                  shadow: const Offset(1.5, 1.5),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textDark),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
              Text(
                sold,
                style: const TextStyle(color: NeoColors.textMuted, fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(width: 16),
              Text(
                total,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF166534)),
              ),
            ],
          );
        },
      ),
    );
  }
}
