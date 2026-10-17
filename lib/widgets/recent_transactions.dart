import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/neo_colors.dart';
import 'neo_button.dart';
import 'neo_card.dart';

class RecentTransactions extends StatelessWidget {
  final bool showAll;
  final VoidCallback onToggle;
  final List<TransactionModel> transactions;

  const RecentTransactions({
    super.key,
    required this.showAll,
    required this.onToggle,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = showAll ? transactions : transactions.take(3).toList();

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
                      'Transaksi Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: NeoColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pesanan yang baru masuk',
                      style: TextStyle(
                        color: NeoColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              NeoButton(
                onPressed: onToggle,
                color: NeoColors.cardYellow,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                borderRadius: 8,
                child: Text(showAll ? 'Sembunyikan' : 'Lihat semua'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: visibleTransactions
                      .map((transaction) => _TransactionTile(transaction: transaction))
                      .toList(),
                );
              }

              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.35),
                  1: FlexColumnWidth(1.8),
                  2: FlexColumnWidth(1.3),
                  3: FlexColumnWidth(1.25),
                  4: FlexColumnWidth(1.15),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: NeoColors.border, width: 2.5),
                      ),
                    ),
                    children: [
                      _TableHead('ID PESANAN'),
                      _TableHead('PELANGGAN'),
                      _TableHead('TANGGAL'),
                      _TableHead('TOTAL'),
                      _TableHead('STATUS'),
                    ],
                  ),
                  ...visibleTransactions.map(
                    (transaction) => TableRow(
                      children: [
                        _TableCell(transaction.id, weight: FontWeight.w900),
                        _TableCell(transaction.customer),
                        _TableCell(transaction.date),
                        _TableCell(transaction.amount, weight: FontWeight.w900),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _StatusChip(isPaid: transaction.isPaid),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: NeoColors.border, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: NeoColors.cardPurple,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NeoColors.border, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              transaction.customer.substring(0, 1),
              style: const TextStyle(
                color: NeoColors.textDark,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.customer,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: NeoColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.id} · ${transaction.date}',
                  style: const TextStyle(
                    color: NeoColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: NeoColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              _StatusChip(isPaid: transaction.isPaid),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isPaid;

  const _StatusChip({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final bg = isPaid ? NeoColors.successBg : NeoColors.warningBg;
    final text = isPaid ? 'LUNAS' : 'DIPROSES';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NeoColors.border, width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: NeoColors.textDark,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  final String text;
  const _TableHead(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: NeoColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final FontWeight weight;

  const _TableCell(this.text, {this.weight = FontWeight.w600});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE4E4E7), width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        text,
        style: TextStyle(
          color: NeoColors.textDark,
          fontSize: 13,
          fontWeight: weight,
        ),
      ),
    );
  }
}
