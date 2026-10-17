import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/dummy_api_service.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/neo_button.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final List<CustomerModel> _customers = List.from(CustomerModel.mockCustomers);
  final DummyApiService _api = DummyApiService();
  String _searchQuery = '';
  CustomerTier? _selectedTier;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _api.fetchCustomers();
      if (!mounted) return;
      setState(() {
        _customers
          ..clear()
          ..addAll(customers);
      });
    } catch (_) {
      // The screen remains usable with its bundled fallback data.
    }
  }

  List<CustomerModel> get _filteredCustomers {
    return _customers.where((customer) {
      final matchesSearch = customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.phone.contains(_searchQuery);
      final matchesTier = _selectedTier == null || customer.tier == _selectedTier;
      return matchesSearch && matchesTier;
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

  void _showAddCustomerDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    CustomerTier selectedTier = CustomerTier.baru;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1_rounded, color: NeoColors.textDark),
            SizedBox(width: 8),
            Text('Tambah Pelanggan Baru', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CustomerTier>(
                initialValue: selectedTier,
                decoration: const InputDecoration(
                  labelText: 'Kategori Pelanggan',
                  border: OutlineInputBorder(),
                ),
                items: CustomerTier.values
                    .map((tier) => DropdownMenuItem(
                          value: tier,
                          child: Text(tier.label),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) selectedTier = val;
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
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final newId = 'CUST-00${_customers.length + 1}';
                setState(() {
                  _customers.insert(
                    0,
                    CustomerModel(
                      id: newId,
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text.isEmpty ? '+62 812-0000-0000' : phoneController.text,
                      tier: selectedTier,
                      totalSpend: 0,
                      totalOrders: 0,
                      joinDate: 'Hari Ini',
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pelanggan ${nameController.text} berhasil ditambahkan!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showCustomerDetailModal(CustomerModel customer) {
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
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: NeoColors.primary,
                  child: Text(
                    customer.name[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: NeoColors.textDark),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      Text(customer.email, style: const TextStyle(color: NeoColors.textMuted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: NeoTheme.boxDecoration(
                    color: customer.tier.bgColor,
                    radius: 8,
                    shadow: const Offset(2, 2),
                  ),
                  child: Text(
                    customer.tier.label,
                    style: TextStyle(color: customer.tier.textColor, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: NeoColors.border, thickness: 1.5),
            const SizedBox(height: 12),
            _DetailRow(icon: Icons.phone_rounded, label: 'Telepon', value: customer.phone),
            _DetailRow(icon: Icons.calendar_today_rounded, label: 'Bergabung', value: customer.joinDate),
            _DetailRow(icon: Icons.shopping_bag_rounded, label: 'Total Pesanan', value: '${customer.totalOrders} Transaksi'),
            _DetailRow(icon: Icons.monetization_on_rounded, label: 'Total Pembelian', value: _formatRupiah(customer.totalSpend)),
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
                    label: 'Kirim Pesan',
                    color: NeoColors.cardBlue,
                    icon: Icons.chat_bubble_outline_rounded,
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Membuka pesan untuk ${customer.name}...')),
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
    final cardColumns = width >= 1180 ? 3 : width >= 640 ? 2 : 1;

    final vipCount = _customers.where((c) => c.tier == CustomerTier.vip).length;

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
                      'Kelola Pelanggan',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: NeoColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Daftar kontak pelanggan, status keanggotaan, dan riwayat belanja.',
                      style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    NeoButton(
                      label: '+ Pelanggan',
                      color: NeoColors.primary,
                      icon: Icons.person_add_rounded,
                      onPressed: _showAddCustomerDialog,
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
                          'Kelola Pelanggan',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: NeoColors.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Daftar kontak pelanggan, status keanggotaan, dan riwayat belanja.',
                          style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  NeoButton(
                    label: '+ Pelanggan',
                    color: NeoColors.primary,
                    icon: Icons.person_add_rounded,
                    onPressed: _showAddCustomerDialog,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Customer Metrics
          GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 2.6 : 1.55,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MetricCard(
                label: 'Total Pelanggan',
                value: '${_customers.length}',
                change: '+5.4%',
                icon: Icons.people_rounded,
                color: NeoColors.cardOrange,
              ),
              MetricCard(
                label: 'Pelanggan VIP',
                value: '$vipCount',
                change: '+12.0%',
                icon: Icons.star_rounded,
                color: NeoColors.cardPurple,
              ),
              const MetricCard(
                label: 'Pelanggan Baru',
                value: '18',
                change: '+8.5%',
                icon: Icons.person_add_alt_rounded,
                color: NeoColors.cardGreen,
              ),
              const MetricCard(
                label: 'Kepuasan Pelanggan',
                value: '4.9 / 5.0',
                change: '+0.2',
                icon: Icons.thumb_up_alt_rounded,
                color: NeoColors.cardYellow,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search & Filters Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: Column(
              children: [
                Container(
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
                      hintText: 'Cari pelanggan berdasarkan nama, email, atau no telp...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _TierFilterChip(
                        label: 'Semua Tier',
                        selected: _selectedTier == null,
                        onTap: () => setState(() => _selectedTier = null),
                      ),
                      ...CustomerTier.values.map(
                        (tier) => _TierFilterChip(
                          label: tier.label,
                          selected: _selectedTier == tier,
                          onTap: () => setState(() => _selectedTier = tier),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Customers Cards Grid
          if (_filteredCustomers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: NeoTheme.boxDecoration(color: Colors.white),
              child: const Center(
                child: Text(
                  'Tidak ada pelanggan yang sesuai kriteria pencarian.',
                  style: TextStyle(fontWeight: FontWeight.bold, color: NeoColors.textMuted),
                ),
              ),
            )
          else
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cardColumns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: cardColumns == 1 ? 1.8 : 1.3,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return InkWell(
                  onTap: () => _showCustomerDetailModal(customer),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: NeoTheme.boxDecoration(
                      color: Colors.white,
                      shadow: const Offset(3, 3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: NeoTheme.boxDecoration(
                                color: customer.tier.bgColor,
                                radius: 10,
                                borderWidth: 2,
                                shadow: const Offset(2, 2),
                              ),
                              child: Center(
                                child: Text(
                                  customer.name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: customer.tier.textColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                  ),
                                  Text(
                                    customer.email,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: NeoColors.textMuted, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: NeoTheme.boxDecoration(
                            color: customer.tier.bgColor,
                            radius: 6,
                            shadow: const Offset(1.5, 1.5),
                            borderWidth: 1.5,
                          ),
                          child: Text(
                            customer.tier.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: customer.tier.textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: NeoColors.border, thickness: 1.5),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${customer.totalOrders} Pesanan', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                            Text(_formatRupiah(customer.totalSpend), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF166534))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TierFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TierFilterChip({
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: NeoColors.textMuted),
          const SizedBox(width: 10),
          Text('$label:', style: const TextStyle(color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800, color: NeoColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
