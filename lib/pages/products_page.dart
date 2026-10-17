import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/dummy_api_service.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import '../widgets/metric_card.dart';
import '../widgets/neo_button.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<ProductModel> _products = List.from(ProductModel.mockProducts);
  final DummyApiService _api = DummyApiService();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _api.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products
          ..clear()
          ..addAll(products);
      });
    } catch (_) {
      // The screen remains usable with its bundled fallback data.
    }
  }

  List<String> get _categories {
    final list = ['Semua'];
    for (var p in _products) {
      if (!list.contains(p.category)) {
        list.add(p.category);
      }
    }
    return list;
  }

  List<ProductModel> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' || product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
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

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String category = 'Pakaian';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_business_rounded, color: NeoColors.textDark),
            SizedBox(width: 8),
            Text('Tambah Produk Baru', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Pakaian', child: Text('Pakaian')),
                  DropdownMenuItem(value: 'Sepatu', child: Text('Sepatu')),
                  DropdownMenuItem(value: 'Aksesoris', child: Text('Aksesoris')),
                  DropdownMenuItem(value: 'Elektronik', child: Text('Elektronik')),
                ],
                onChanged: (val) {
                  if (val != null) category = val;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok Initial',
                  border: OutlineInputBorder(),
                ),
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
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                final stock = int.tryParse(stockController.text) ?? 10;
                final price = double.tryParse(priceController.text) ?? 100000;
                final status = stock == 0
                    ? ProductStockStatus.habis
                    : (stock < 10 ? ProductStockStatus.menipis : ProductStockStatus.tersedia);

                setState(() {
                  _products.insert(
                    0,
                    ProductModel(
                      id: 'PRD-10${_products.length + 1}',
                      name: nameController.text,
                      category: category,
                      price: price,
                      stock: stock,
                      status: status,
                      icon: Icons.inventory_2_rounded,
                      cardAccent: NeoColors.cardYellow,
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produk ${nameController.text} berhasil ditambahkan!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditStockDialog(ProductModel product) {
    final stockController = TextEditingController(text: product.stock.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Stok - ${product.name}', style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Stok Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: NeoColors.textDark, fontWeight: FontWeight.bold)),
          ),
          NeoButton(
            label: 'Update Stok',
            color: NeoColors.primary,
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? product.stock;
              final newStatus = newStock == 0
                  ? ProductStockStatus.habis
                  : (newStock < 10 ? ProductStockStatus.menipis : ProductStockStatus.tersedia);

              final idx = _products.indexWhere((p) => p.id == product.id);
              if (idx != -1) {
                setState(() {
                  _products[idx] = ProductModel(
                    id: product.id,
                    name: product.name,
                    category: product.category,
                    price: product.price,
                    stock: newStock,
                    status: newStatus,
                    icon: product.icon,
                    cardAccent: product.cardAccent,
                  );
                });
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stok ${product.name} diperbarui menjadi $newStock.')),
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
    final gridColumns = width >= 1180 ? 3 : width >= 640 ? 2 : 1;

    final lowStockCount = _products.where((p) => p.status == ProductStockStatus.menipis).length;
    final outOfStockCount = _products.where((p) => p.status == ProductStockStatus.habis).length;

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
                      'Katalog Produk',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: NeoColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kelola daftar barang, jumlah stok, dan penyesuaian harga.',
                      style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 14),
                    NeoButton(
                      label: '+ Produk Baru',
                      color: NeoColors.primary,
                      icon: Icons.add_box_rounded,
                      onPressed: _showAddProductDialog,
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
                          'Katalog Produk',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: NeoColors.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola daftar barang, jumlah stok, dan penyesuaian harga.',
                          style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  NeoButton(
                    label: '+ Produk Baru',
                    color: NeoColors.primary,
                    icon: Icons.add_box_rounded,
                    onPressed: _showAddProductDialog,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Inventory KPIs
          GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 2.6 : 1.55,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MetricCard(
                label: 'Total Jenis Produk',
                value: '${_products.length}',
                change: '+2.1%',
                icon: Icons.inventory_2_rounded,
                color: NeoColors.cardGreen,
              ),
              MetricCard(
                label: 'Stok Menipis',
                value: '$lowStockCount',
                change: 'Perlu restock',
                icon: Icons.warning_amber_rounded,
                color: NeoColors.cardYellow,
              ),
              MetricCard(
                label: 'Stok Habis',
                value: '$outOfStockCount',
                change: 'Kosong',
                icon: Icons.running_with_errors_rounded,
                color: NeoColors.cardPink,
              ),
              MetricCard(
                label: 'Kategori Aktif',
                value: '${_categories.length - 1}',
                change: 'Aktif',
                icon: Icons.category_rounded,
                color: NeoColors.cardBlue,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search & Category Filters
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
                      hintText: 'Cari produk berdasarkan ID atau Nama...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: _selectedCategory == cat
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
                              cat,
                              style: TextStyle(
                                fontWeight: _selectedCategory == cat ? FontWeight.w900 : FontWeight.w600,
                                color: NeoColors.textDark,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Product Grid
          if (_filteredProducts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: NeoTheme.boxDecoration(color: Colors.white),
              child: const Center(
                child: Text(
                  'Tidak ada produk yang cocok dengan pencarian.',
                  style: TextStyle(fontWeight: FontWeight.bold, color: NeoColors.textMuted),
                ),
              ),
            )
          else
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridColumns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: gridColumns == 1 ? 1.6 : 1.25,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return Container(
                  padding: const EdgeInsets.all(16),
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
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: NeoTheme.boxDecoration(
                              color: product.cardAccent,
                              radius: 10,
                              shadow: const Offset(2, 2),
                              borderWidth: 2,
                            ),
                            child: Icon(product.icon, size: 24, color: NeoColors.textDark),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: NeoTheme.boxDecoration(
                              color: product.status.bgColor,
                              radius: 6,
                              shadow: const Offset(1.5, 1.5),
                              borderWidth: 1.5,
                            ),
                            child: Text(
                              product.status.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: product.status.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        product.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Kategori: ${product.category}',
                        style: const TextStyle(color: NeoColors.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: NeoColors.border, thickness: 1.5),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_formatRupiah(product.price), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                              Text('Stok: ${product.stock} pcs', style: const TextStyle(color: NeoColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          InkWell(
                            onTap: () => _showEditStockDialog(product),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: NeoTheme.boxDecoration(
                                color: NeoColors.secondary,
                                radius: 8,
                                borderWidth: 1.5,
                                shadow: const Offset(1.5, 1.5),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit_rounded, size: 14, color: NeoColors.textDark),
                                  SizedBox(width: 4),
                                  Text('Stok', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
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
