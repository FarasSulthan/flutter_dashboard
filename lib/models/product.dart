import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';

enum ProductStockStatus {
  tersedia('Tersedia', NeoColors.cardGreen, Color(0xFF065F46)),
  menipis('Stok Menipis', NeoColors.warningBg, NeoColors.warningText),
  habis('Habis', NeoColors.cardPink, Color(0xFF9F1239));

  final String label;
  final Color bgColor;
  final Color textColor;

  const ProductStockStatus(this.label, this.bgColor, this.textColor);
}

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final ProductStockStatus status;
  final IconData icon;
  final Color cardAccent;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.icon,
    required this.cardAccent,
  });

  /// Converts the API's dummy JSON to the visual model used by the UI.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as String? ?? 'Lainnya';
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Produk tanpa nama',
      category: category,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] as int? ?? 0,
      status: ProductStockStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ProductStockStatus.tersedia,
      ),
      icon: switch (category) {
        'Pakaian' => Icons.dry_cleaning_rounded,
        'Sepatu' => Icons.roller_skating_rounded,
        'Aksesoris' => Icons.shopping_bag_rounded,
        'Elektronik' => Icons.watch_rounded,
        _ => Icons.inventory_2_rounded,
      },
      cardAccent: switch (category) {
        'Pakaian' => NeoColors.cardYellow,
        'Sepatu' => NeoColors.cardBlue,
        'Aksesoris' => NeoColors.cardOrange,
        'Elektronik' => NeoColors.cardPurple,
        _ => NeoColors.cardGreen,
      },
    );
  }

  static List<ProductModel> mockProducts = const [
    ProductModel(
      id: 'PRD-101',
      name: 'Jaket Neobrutal Yellow',
      category: 'Pakaian',
      price: 350000,
      stock: 45,
      status: ProductStockStatus.tersedia,
      icon: Icons.dry_cleaning_rounded,
      cardAccent: NeoColors.cardYellow,
    ),
    ProductModel(
      id: 'PRD-102',
      name: 'Sepatu Retro Neon Blue',
      category: 'Sepatu',
      price: 1250000,
      stock: 8,
      status: ProductStockStatus.menipis,
      icon: Icons.roller_skating_rounded,
      cardAccent: NeoColors.cardBlue,
    ),
    ProductModel(
      id: 'PRD-103',
      name: 'Topi Snapback Bold',
      category: 'Aksesoris',
      price: 180000,
      stock: 120,
      status: ProductStockStatus.tersedia,
      icon: Icons.face_retouching_natural_rounded,
      cardAccent: NeoColors.cardOrange,
    ),
    ProductModel(
      id: 'PRD-104',
      name: 'Hoodie Oversized Mint',
      category: 'Pakaian',
      price: 650000,
      stock: 3,
      status: ProductStockStatus.menipis,
      icon: Icons.checkroom_rounded,
      cardAccent: NeoColors.cardGreen,
    ),
    ProductModel(
      id: 'PRD-105',
      name: 'Smartwatch Cyber Sport',
      category: 'Elektronik',
      price: 2100000,
      stock: 0,
      status: ProductStockStatus.habis,
      icon: Icons.watch_rounded,
      cardAccent: NeoColors.cardPurple,
    ),
    ProductModel(
      id: 'PRD-106',
      name: 'Tote Bag Canvas Bold',
      category: 'Aksesoris',
      price: 160000,
      stock: 85,
      status: ProductStockStatus.tersedia,
      icon: Icons.shopping_bag_rounded,
      cardAccent: NeoColors.cardPink,
    ),
  ];
}
