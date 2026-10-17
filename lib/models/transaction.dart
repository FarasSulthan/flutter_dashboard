class TransactionModel {
  final String id;
  final String customer;
  final String date;
  final String amount;
  final bool isPaid;

  const TransactionModel(
    this.id,
    this.customer,
    this.date,
    this.amount,
    this.isPaid,
  );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final amount = (json['amount'] as num?)?.toInt() ?? 0;
    return TransactionModel(
      json['id'] as String? ?? '',
      json['customer'] as String? ?? 'Pelanggan',
      json['date'] as String? ?? '-',
      _formatRupiah(amount),
      json['paymentStatus'] == 'paid',
    );
  }

  static String _formatRupiah(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) buffer.write('.');
      buffer.write(digits[index]);
    }
    return 'Rp $buffer';
  }
}
