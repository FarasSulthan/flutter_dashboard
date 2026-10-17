import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/dummy_api_service.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/neo_button.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<OrderModel> _orders = List.from(OrderModel.mockOrders);
  final DummyApiService _api = DummyApiService();
  String _searchQuery = '';
  OrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _api.fetchOrders();
      if (!mounted) return;
      setState(() {
        _orders
          ..clear()
          ..addAll(orders);
      });
    } catch (_) {
      // The screen remains usable with its bundled fallback data.
    }
  }

  List<OrderModel> get _filteredOrders {
    return _orders.where((order) {
      final matchesSearch = order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == null || order.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  String _formatRupiah(double amount) {
    final str = amount.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  void _showAddOrderDialog() {
    final customerController = TextEditingController();
    final amountController = TextEditingController();
    String paymentMethod = 'QRIS';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_shopping_cart_rounded, color: NeoColors.textDark),
            SizedBox(width: 8),
            Text('Tambah Pesanan Baru', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: customerController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Metode Pembayaran',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                  DropdownMenuItem(value: 'Transfer Bank', child: Text('Transfer Bank')),
                  DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
                  DropdownMenuItem(value: 'Kartu Kredit', child: Text('Kartu Kredit')),
                ],
                onChanged: (val) {
                  if (val != null) paymentMethod = val;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: NeoColors.textDark, fontWeight: FontWeight.bold)),
          ),
          NeoButton(
            label: 'Simpan',
            color: NeoColors.primary,
            onPressed: () {
              if (customerController.text.isNotEmpty && amountController.text.isNotEmpty) {
                final newId = '#ORD-${8820 + _orders.length + 1}';
                final amount = double.tryParse(amountController.text) ?? 0;
                setState(() {
                  _orders.insert(
                    0,
                    OrderModel(
                      id: newId,
                      customerName: customerController.text,
                      date: 'Hari ini, Baru',
                      totalAmount: amount,
                      status: OrderStatus.diproses,
                      paymentMethod: paymentMethod,
                      items: [
                        OrderItemModel(name: 'Item Pesanan Baru', quantity: 1, price: amount),
                      ],
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pesanan $newId berhasil dibuat!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showOrderDetailModal(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: NeoColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: NeoColors.border, width: 2.5),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Detail Pesanan ${order.id}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: NeoTheme.boxDecoration(
                    color: order.status.bgColor,
                    radius: 8,
                    shadow: const Offset(2, 2),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(color: order.status.textColor, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Pelanggan: ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            Text('Tanggal: ${order.date}', style: const TextStyle(color: NeoColors.textMuted)),
            Text('Metode Pembayaran: ${order.paymentMethod}', style: const TextStyle(color: NeoColors.textMuted)),
            const Divider(height: 32, color: NeoColors.border, thickness: 1.5),
            const Text('Daftar Produk:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 8),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.quantity}x ${item.name}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(_formatRupiah(item.price * item.quantity), style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
            const Divider(height: 32, color: NeoColors.border, thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text(_formatRupiah(order.totalAmount), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF166534))),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: NeoButton(
                    label: 'Tutup',
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeoButton(
                    label: 'Cetak Faktur',
                    color: NeoColors.secondary,
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Faktur ${order.id} berhasil dicetak!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180 ? 4 : width >= 720 ? 2 : 1;

    final totalRevenue = _orders.fold<double>(0, (sum, item) => sum + item.totalAmount);
    final totalProcessing = _orders.where((o) => o.status == OrderStatus.diproses).length;
    final totalCompleted = _orders.where((o) => o.status == OrderStatus.selesai).length;

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
                      'Kelola Pesanan',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: NeoColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pantau dan kelola seluruh transaksi pelanggan Anda.',
                      style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    NeoButton(
                      label: '+ Pesanan Baru',
                      color: NeoColors.primary,
                      icon: Icons.add_rounded,
                      onPressed: _showAddOrderDialog,
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
                          'Kelola Pesanan',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: NeoColors.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pantau dan kelola seluruh transaksi pelanggan Anda.',
                          style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  NeoButton(
                    label: '+ Pesanan Baru',
                    color: NeoColors.primary,
                    icon: Icons.add_rounded,
                    onPressed: _showAddOrderDialog,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Metrics
          GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 2.6 : 1.55,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MetricCard(
                label: 'Total Transaksi',
                value: '${_orders.length}',
                change: '+14.2%',
                icon: Icons.shopping_bag_rounded,
                color: NeoColors.cardYellow,
              ),
              MetricCard(
                label: 'Perlu Diproses',
                value: '$totalProcessing',
                change: '-2.5%',
                icon: Icons.autorenew_rounded,
                color: NeoColors.cardBlue,
              ),
              MetricCard(
                label: 'Pesanan Selesai',
                value: '$totalCompleted',
                change: '+18.9%',
                icon: Icons.check_circle_rounded,
                color: NeoColors.cardGreen,
              ),
              MetricCard(
                label: 'Nilai Transaksi',
                value: _formatRupiah(totalRevenue),
                change: '+12.5%',
                icon: Icons.account_balance_wallet_rounded,
                color: NeoColors.cardOrange,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters & Search
          Container(
            padding: const EdgeInsets.all(16),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: NeoTheme.boxDecoration(
                          color: NeoColors.background,
                          radius: 10,
                          shadow: const Offset(2, 2),
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search_rounded, color: NeoColors.textDark),
                            hintText: 'Cari berdasarkan ID Pesanan atau Nama Pelanggan...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Semua Status',
                        selected: _selectedStatus == null,
                        onTap: () => setState(() => _selectedStatus = null),
                      ),
                      ...OrderStatus.values.map(
                        (status) => _FilterChip(
                          label: status.label,
                          selected: _selectedStatus == status,
                          onTap: () => setState(() => _selectedStatus = status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Orders List/Table
          LayoutBuilder(
            builder: (context, constraints) {
              final useCards = constraints.maxWidth < 720;

              if (useCards) {
                // Card-based layout for narrow screens
                return Column(
                  children: [
                    if (_filteredOrders.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: NeoTheme.boxDecoration(color: Colors.white),
                        child: const Center(
                          child: Text(
                            'Tidak ada pesanan ditemukan.',
                            style: TextStyle(fontWeight: FontWeight.bold, color: NeoColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ..._filteredOrders.map(
                        (order) => GestureDetector(
                          onTap: () => _showOrderDetailModal(order),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: NeoTheme.boxDecoration(
                              color: Colors.white,
                              shadow: const Offset(3, 3),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.id,
                                      style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.textDark),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: NeoTheme.boxDecoration(
                                        color: order.status.bgColor,
                                        radius: 6,
                                        shadow: const Offset(1.5, 1.5),
                                        borderWidth: 1.5,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(order.status.icon, size: 12, color: order.status.textColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            order.status.label,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: order.status.textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  order.customerName,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.date,
                                      style: const TextStyle(color: NeoColors.textMuted, fontSize: 12),
                                    ),
                                    Text(
                                      _formatRupiah(order.totalAmount),
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: NeoColors.background,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: NeoColors.border, width: 1.5),
                                  ),
                                  child: Text(
                                    order.paymentMethod,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }

              // Table layout for wide screens
              return Container(
                decoration: NeoTheme.boxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text('ID PESANAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textMuted))),
                          Expanded(flex: 3, child: Text('PELANGGAN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textMuted))),
                          Expanded(flex: 3, child: Text('TANGGAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textMuted))),
                          Expanded(flex: 2, child: Text('METODE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textMuted))),
                          Expanded(flex: 2, child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textMuted))),
                          Expanded(flex: 3, child: Align(alignment: Alignment.centerRight, child: Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.textMuted)))),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: NeoColors.border, thickness: 2),
                    if (_filteredOrders.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Tidak ada pesanan ditemukan.',
                            style: TextStyle(fontWeight: FontWeight.bold, color: NeoColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ..._filteredOrders.map(
                        (order) => InkWell(
                          onTap: () => _showOrderDetailModal(order),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: NeoColors.border, width: 1)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    order.id,
                                    style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.textDark),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    order.customerName,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    order.date,
                                    style: const TextStyle(color: NeoColors.textMuted, fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: NeoColors.background,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: NeoColors.border, width: 1.5),
                                    ),
                                    child: Text(
                                      order.paymentMethod,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: NeoTheme.boxDecoration(
                                      color: order.status.bgColor,
                                      radius: 6,
                                      shadow: const Offset(1.5, 1.5),
                                      borderWidth: 1.5,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(order.status.icon, size: 12, color: order.status.textColor),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            order.status.label,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: order.status.textColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _formatRupiah(order.totalAmount),
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
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
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              color: NeoColors.textDark,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
