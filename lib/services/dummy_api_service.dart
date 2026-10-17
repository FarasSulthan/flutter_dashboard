import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/customer.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/transaction.dart';

/// HTTP client for the read-only dummy JSON API.
///
/// Override the address when running on an Android emulator, for example with
/// `--dart-define=API_BASE_URL=http://10.0.2.2:8080`.
class DummyApiService {
  DummyApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _ownsClient = client == null,
        _baseUrl = (baseUrl ?? defaultBaseUrl).replaceFirst(RegExp(r'/$'), '');

  static const defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  final http.Client _client;
  final bool _ownsClient;
  final String _baseUrl;

  Future<DashboardData> fetchDashboard() async {
    final data = await _getObject('/api/dashboard');
    return DashboardData.fromJson(data);
  }

  Future<List<ProductModel>> fetchProducts() async {
    final data = await _getList('/api/products');
    return data.map(ProductModel.fromJson).toList();
  }

  Future<List<CustomerModel>> fetchCustomers() async {
    final data = await _getList('/api/customers');
    return data.map(CustomerModel.fromJson).toList();
  }

  Future<List<OrderModel>> fetchOrders() async {
    final data = await _getList('/api/orders');
    return data.map(OrderModel.fromJson).toList();
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }

  Future<Map<String, dynamic>> _getObject(String path) async {
    final data = await _get(path);
    if (data is! Map) throw const DummyApiException('Respons API tidak valid.');
    return Map<String, dynamic>.from(data);
  }

  Future<List<Map<String, dynamic>>> _getList(String path) async {
    final data = await _get(path);
    if (data is! List) throw const DummyApiException('Respons API tidak valid.');
    return data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<Object?> _get(String path) async {
    final response = await _client.get(Uri.parse('$_baseUrl$path'));
    if (response.statusCode != 200) {
      throw DummyApiException('API mengembalikan status ${response.statusCode}.');
    }
    final responseBody = jsonDecode(response.body);
    if (responseBody is! Map || !responseBody.containsKey('data')) {
      throw const DummyApiException('Respons API tidak valid.');
    }
    return responseBody['data'];
  }
}

class DummyApiException implements Exception {
  const DummyApiException(this.message);

  final String message;
}

class DashboardData {
  const DashboardData({
    required this.metrics,
    required this.sales,
    required this.recentTransactions,
  });

  final List<DashboardMetric> metrics;
  final List<SalesPoint> sales;
  final List<TransactionModel> recentTransactions;

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final rawMetrics = json['metrics'] as List<dynamic>? ?? const [];
    final rawSales = json['sales'] as List<dynamic>? ?? const [];
    final rawTransactions = json['recentTransactions'] as List<dynamic>? ?? const [];
    return DashboardData(
      metrics: rawMetrics
          .whereType<Map>()
          .map((item) => DashboardMetric.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      sales: rawSales
          .whereType<Map>()
          .map((item) => SalesPoint.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      recentTransactions: rawTransactions
          .whereType<Map>()
          .map((item) => TransactionModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  factory DashboardData.fallback() => const DashboardData(
        metrics: [
          DashboardMetric('revenue', 'Total Pendapatan', 'Rp 24,8 jt', '+12,5%'),
          DashboardMetric('newOrders', 'Pesanan Baru', '1.248', '+8,2%'),
          DashboardMetric('customers', 'Pelanggan', '856', '+5,4%'),
          DashboardMetric('activeProducts', 'Produk Aktif', '136', '+2,1%'),
        ],
        sales: [
          SalesPoint('Sen', 3000000),
          SalesPoint('Sel', 5400000),
          SalesPoint('Rab', 4100000),
          SalesPoint('Kam', 7000000),
          SalesPoint('Jum', 5800000),
          SalesPoint('Sab', 8600000),
          SalesPoint('Min', 7600000),
        ],
        recentTransactions: [
          TransactionModel('ORD-2084', 'Nadia Putri', '12 Jun 2026', 'Rp 1.250.000', true),
          TransactionModel('ORD-2083', 'Dimas Pratama', '12 Jun 2026', 'Rp 680.000', true),
          TransactionModel('ORD-2082', 'Rani Wulandari', '11 Jun 2026', 'Rp 425.000', false),
          TransactionModel('ORD-2081', 'Bima Saputra', '11 Jun 2026', 'Rp 960.000', true),
          TransactionModel('ORD-2080', 'Siti Rahma', '10 Jun 2026', 'Rp 315.000', false),
        ],
      );
}

class DashboardMetric {
  const DashboardMetric(this.key, this.label, this.displayValue, this.change);

  final String key;
  final String label;
  final String displayValue;
  final String change;

  factory DashboardMetric.fromJson(Map<String, dynamic> json) {
    return DashboardMetric(
      json['key'] as String? ?? '',
      json['label'] as String? ?? '-',
      json['displayValue'] as String? ?? '0',
      json['change'] as String? ?? '-',
    );
  }
}

class SalesPoint {
  const SalesPoint(this.label, this.revenue);

  final String label;
  final num revenue;

  factory SalesPoint.fromJson(Map<String, dynamic> json) {
    return SalesPoint(
      json['label'] as String? ?? '-',
      json['revenue'] as num? ?? 0,
    );
  }
}
