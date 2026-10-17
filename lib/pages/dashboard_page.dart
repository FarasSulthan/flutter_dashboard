import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../services/dummy_api_service.dart';
import '../theme/neo_colors.dart';
import '../widgets/greeting_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/sales_chart.dart';
import '../widgets/side_navigation.dart';
import '../widgets/top_bar.dart';

// Pages
import 'customers_page.dart';
import 'orders_page.dart';
import 'products_page.dart';
import 'reports_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  bool _showAllTransactions = false;
  final DummyApiService _api = DummyApiService();
  DashboardData _dashboardData = DashboardData.fallback();

  static const _menuItems = <MenuItemModel>[
    MenuItemModel('Dashboard', Icons.grid_view_rounded),
    MenuItemModel('Pesanan', Icons.shopping_bag_outlined),
    MenuItemModel('Pelanggan', Icons.people_outline_rounded),
    MenuItemModel('Produk', Icons.inventory_2_outlined),
    MenuItemModel('Laporan', Icons.insert_chart_outlined),
  ];

  static const _allMenuItems = <MenuItemModel>[
    ..._menuItems,
    MenuItemModel('Pengaturan', Icons.settings_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await _api.fetchDashboard();
      if (!mounted) return;
      setState(() => _dashboardData = data);
    } catch (_) {
      // The UI keeps its bundled fallback data when the optional dummy API is off.
    }
  }

  void _selectMenu(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildBody(bool isWide) {
    switch (_selectedIndex) {
      case 0:
        return _DashboardContent(
          isWide: isWide,
          showAllTransactions: _showAllTransactions,
          onToggleTransactions: () {
            setState(() {
              _showAllTransactions = !_showAllTransactions;
            });
          },
          onActionSelected: _selectMenu,
          dashboardData: _dashboardData,
        );
      case 1:
        return const OrdersPage();
      case 2:
        return const CustomersPage();
      case 3:
        return const ProductsPage();
      case 4:
        return const ReportsPage();
      case 5:
        return const SettingsPage();
      default:
        return _DashboardContent(
          isWide: isWide,
          showAllTransactions: _showAllTransactions,
          onToggleTransactions: () {
            setState(() {
              _showAllTransactions = !_showAllTransactions;
            });
          },
          onActionSelected: _selectMenu,
          dashboardData: _dashboardData,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 980;
    final horizontalPadding = width < 480 ? 12.0 : (width < 720 ? 16.0 : 20.0);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              SideNavigation(
                items: _menuItems,
                selectedIndex: _selectedIndex,
                onSelected: _selectMenu,
              ),
            Expanded(
              child: Column(
                children: [
                  TopBar(
                    showMenuButton: !isWide,
                    onMenuTap: () => _showMobileMenu(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 28),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: _buildBody(isWide),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isWide
          ? null
          : Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: NeoColors.border, width: 2.5),
                ),
              ),
              child: NavigationBar(
                backgroundColor: NeoColors.background,
                indicatorColor: NeoColors.primary,
                selectedIndex: _selectedIndex > 4 ? 4 : _selectedIndex,
                onDestinationSelected: (idx) => _selectMenu(idx),
                destinations: _menuItems
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(item.icon, color: NeoColors.textDark),
                        label: item.label,
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: NeoColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: NeoColors.border, width: 2.5),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: NeoColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              ..._allMenuItems.asMap().entries.map(
                    (entry) => ListTile(
                      leading: Icon(entry.value.icon, color: NeoColors.textDark),
                      title: Text(
                        entry.value.label,
                        style: const TextStyle(
                          color: NeoColors.textDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _selectMenu(entry.key);
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final bool isWide;
  final bool showAllTransactions;
  final VoidCallback onToggleTransactions;
  final ValueChanged<int> onActionSelected;
  final DashboardData dashboardData;

  const _DashboardContent({
    required this.isWide,
    required this.showAllTransactions,
    required this.onToggleTransactions,
    required this.onActionSelected,
    required this.dashboardData,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180 ? 4 : width >= 720 ? 2 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GreetingHeader(),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: columns == 1 ? 2.6 : 1.55,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: dashboardData.metrics.map(_buildMetricCard).toList(),
        ),
        const SizedBox(height: 24),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: SalesChart(
                  labels: dashboardData.sales.map((point) => point.label).toList(),
                  values: dashboardData.sales.map((point) => point.revenue).toList(),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 4,
                child: QuickActionsGrid(onActionSelected: onActionSelected),
              ),
            ],
          )
        else ...[
          SalesChart(
            labels: dashboardData.sales.map((point) => point.label).toList(),
            values: dashboardData.sales.map((point) => point.revenue).toList(),
          ),
          const SizedBox(height: 20),
          QuickActionsGrid(onActionSelected: onActionSelected),
        ],
        const SizedBox(height: 24),
        RecentTransactions(
          showAll: showAllTransactions,
          onToggle: onToggleTransactions,
          transactions: dashboardData.recentTransactions,
        ),
      ],
    );
  }

  MetricCard _buildMetricCard(DashboardMetric metric) {
    final icon = switch (metric.key) {
      'revenue' => Icons.account_balance_wallet_rounded,
      'newOrders' => Icons.shopping_bag_rounded,
      'customers' => Icons.people_rounded,
      'activeProducts' => Icons.inventory_2_rounded,
      _ => Icons.insights_rounded,
    };
    final color = switch (metric.key) {
      'revenue' => NeoColors.cardYellow,
      'newOrders' => NeoColors.cardBlue,
      'customers' => NeoColors.cardOrange,
      'activeProducts' => NeoColors.cardGreen,
      _ => NeoColors.cardPurple,
    };
    return MetricCard(
      label: metric.label,
      value: metric.displayValue,
      change: metric.change,
      icon: icon,
      color: color,
    );
  }
}
