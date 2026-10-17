import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';

enum OrderStatus {
  diproses('Diproses', NeoColors.cardBlue, NeoColors.textDark, Icons.autorenew_rounded),
  selesai('Selesai', NeoColors.successBg, NeoColors.successText, Icons.check_circle_rounded),
  pending('Pending', NeoColors.warningBg, NeoColors.warningText, Icons.access_time_filled_rounded),
  dibatalkan('Dibatalkan', NeoColors.cardPink, Color(0xFF9F1239), Icons.cancel_rounded);

  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  const OrderStatus(this.label, this.bgColor, this.textColor, this.icon);
}

class OrderItemModel {
  final String name;
  final int quantity;
  final double price;

  const OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String? ?? 'Item pesanan',
      quantity: json['quantity'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }
}

class OrderModel {
  final String id;
  final String customerName;
  final String date;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.items,
  });

  /// Converts the API's dummy JSON to the visual model used by the UI.
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return OrderModel(
      id: json['id'] as String? ?? '',
      customerName: json['customerName'] as String? ?? 'Pelanggan',
      date: json['date'] as String? ?? '-',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: json['paymentMethod'] as String? ?? '-',
      items: rawItems
          .whereType<Map>()
          .map((item) => OrderItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  static List<OrderModel> mockOrders = const [
    OrderModel(
      id: '#ORD-8821',
      customerName: 'Budi Santoso',
      date: '23 Jul 2026, 14:32',
      totalAmount: 450000,
      status: OrderStatus.selesai,
      paymentMethod: 'QRIS',
      items: [
        OrderItemModel(name: 'Jaket Neobrutal Yellow', quantity: 1, price: 350000),
        OrderItemModel(name: 'Sticker Pack Farasha', quantity: 2, price: 50000),
      ],
    ),
    OrderModel(
      id: '#ORD-8822',
      customerName: 'Siti Rahma',
      date: '23 Jul 2026, 15:10',
      totalAmount: 1250000,
      status: OrderStatus.diproses,
      paymentMethod: 'Transfer Bank',
      items: [
        OrderItemModel(name: 'Sepatu Retro Neon Blue', quantity: 1, price: 1250000),
      ],
    ),
    OrderModel(
      id: '#ORD-8823',
      customerName: 'Andi Pratama',
      date: '23 Jul 2026, 16:05',
      totalAmount: 180000,
      status: OrderStatus.pending,
      paymentMethod: 'E-Wallet',
      items: [
        OrderItemModel(name: 'Topi Snapback Bold Black', quantity: 1, price: 180000),
      ],
    ),
    OrderModel(
      id: '#ORD-8824',
      customerName: 'Dewi Lestari',
      date: '22 Jul 2026, 11:20',
      totalAmount: 890000,
      status: OrderStatus.selesai,
      paymentMethod: 'Kartu Kredit',
      items: [
        OrderItemModel(name: 'Hoodie Oversized Mint', quantity: 1, price: 650000),
        OrderItemModel(name: 'Kaos Graphic Bold', quantity: 1, price: 240000),
      ],
    ),
    OrderModel(
      id: '#ORD-8825',
      customerName: 'Rian Hidayat',
      date: '22 Jul 2026, 09:15',
      totalAmount: 320000,
      status: OrderStatus.dibatalkan,
      paymentMethod: 'QRIS',
      items: [
        OrderItemModel(name: 'Tas Tote Bag Canvas', quantity: 2, price: 160000),
      ],
    ),
    OrderModel(
      id: '#ORD-8826',
      customerName: 'Nadia Putri',
      date: '21 Jul 2026, 18:40',
      totalAmount: 2100000,
      status: OrderStatus.selesai,
      paymentMethod: 'Transfer Bank',
      items: [
        OrderItemModel(name: 'Smartwatch Cyber Sport', quantity: 1, price: 2100000),
      ],
    ),
  ];
}
