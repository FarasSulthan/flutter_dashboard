import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';

enum CustomerTier {
  vip('VIP', NeoColors.cardPurple, Color(0xFF5B21B6)),
  reguler('Reguler', NeoColors.cardBlue, Color(0xFF075985)),
  baru('Baru', NeoColors.cardGreen, Color(0xFF065F46));

  final String label;
  final Color bgColor;
  final Color textColor;

  const CustomerTier(this.label, this.bgColor, this.textColor);
}

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final CustomerTier tier;
  final double totalSpend;
  final int totalOrders;
  final String joinDate;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.tier,
    required this.totalSpend,
    required this.totalOrders,
    required this.joinDate,
  });

  /// Converts the API's dummy JSON to the visual model used by the UI.
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Pelanggan tanpa nama',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      tier: CustomerTier.values.firstWhere(
        (tier) => tier.name == json['tier'],
        orElse: () => CustomerTier.baru,
      ),
      totalSpend: (json['totalSpend'] as num?)?.toDouble() ?? 0,
      totalOrders: json['totalOrders'] as int? ?? 0,
      joinDate: json['joinDate'] as String? ?? '-',
    );
  }

  static List<CustomerModel> mockCustomers = const [
    CustomerModel(
      id: 'CUST-001',
      name: 'Budi Santoso',
      email: 'budi.santoso@gmail.com',
      phone: '+62 812-3456-7890',
      tier: CustomerTier.vip,
      totalSpend: 14500000,
      totalOrders: 28,
      joinDate: '12 Jan 2025',
    ),
    CustomerModel(
      id: 'CUST-002',
      name: 'Siti Rahma',
      email: 'siti.rahma@yahoo.com',
      phone: '+62 857-1234-5678',
      tier: CustomerTier.reguler,
      totalSpend: 5200000,
      totalOrders: 11,
      joinDate: '05 Mar 2025',
    ),
    CustomerModel(
      id: 'CUST-003',
      name: 'Andi Pratama',
      email: 'andi.p@gmail.com',
      phone: '+62 878-9012-3456',
      tier: CustomerTier.baru,
      totalSpend: 780000,
      totalOrders: 2,
      joinDate: '15 Jul 2026',
    ),
    CustomerModel(
      id: 'CUST-004',
      name: 'Dewi Lestari',
      email: 'dewi.l@outlook.com',
      phone: '+62 813-8899-7766',
      tier: CustomerTier.vip,
      totalSpend: 21800000,
      totalOrders: 42,
      joinDate: '20 Nov 2024',
    ),
    CustomerModel(
      id: 'CUST-005',
      name: 'Rian Hidayat',
      email: 'rian.hd@gmail.com',
      phone: '+62 821-4455-6677',
      tier: CustomerTier.reguler,
      totalSpend: 3400000,
      totalOrders: 7,
      joinDate: '02 Feb 2026',
    ),
    CustomerModel(
      id: 'CUST-006',
      name: 'Nadia Putri',
      email: 'nadia.putri@gmail.com',
      phone: '+62 896-1122-3344',
      tier: CustomerTier.vip,
      totalSpend: 18900000,
      totalOrders: 35,
      joinDate: '10 Aug 2024',
    ),
  ];
}
