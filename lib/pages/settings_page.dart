import 'package:flutter/material.dart';
import '../theme/neo_colors.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _activeTab = 0;

  // Form states
  final _storeNameController = TextEditingController(text: 'Farasha Store Jakarta');
  final _emailController = TextEditingController(text: 'admin@farashastore.com');
  final _phoneController = TextEditingController(text: '+62 812-9988-7766');
  final _taxController = TextEditingController(text: '11%');
  String _selectedCurrency = 'IDR (Rp)';

  bool _emailAlerts = true;
  bool _smsAlerts = false;
  bool _stockAlerts = true;
  bool _darkMode = false;

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Color(0xFF166534)),
            SizedBox(width: 8),
            Text('Pengaturan berhasil disimpan!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan Sistem',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: NeoColors.textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Konfigurasi profil toko, preferensi notifikasi, dan keamanan akun.',
                style: TextStyle(color: NeoColors.textMuted, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tabs
          Container(
            padding: const EdgeInsets.all(8),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TabButton(
                    label: 'Profil Toko',
                    icon: Icons.store_rounded,
                    selected: _activeTab == 0,
                    onTap: () => setState(() => _activeTab = 0),
                  ),
                  _TabButton(
                    label: 'Notifikasi',
                    icon: Icons.notifications_active_rounded,
                    selected: _activeTab == 1,
                    onTap: () => setState(() => _activeTab = 1),
                  ),
                  _TabButton(
                    label: 'Pembayaran',
                    icon: Icons.credit_card_rounded,
                    selected: _activeTab == 2,
                    onTap: () => setState(() => _activeTab = 2),
                  ),
                  _TabButton(
                    label: 'Keamanan & Akses',
                    icon: Icons.security_rounded,
                    selected: _activeTab == 3,
                    onTap: () => setState(() => _activeTab = 3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tab Content
          Container(
            padding: const EdgeInsets.all(24),
            decoration: NeoTheme.boxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_activeTab == 0) ...[
                  const Text('Profil & Informasi Toko', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _storeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Toko',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.storefront_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Kontak Toko',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor WhatsApp / Telepon',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_rounded),
                    ),
                  ),
                ] else if (_activeTab == 1) ...[
                  const Text('Preferensi Notifikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    activeThumbColor: NeoColors.primary,
                    title: const Text('Notifikasi Email Pesanan Baru', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Kirim email otomatis saat ada pesanan masuk.'),
                    value: _emailAlerts,
                    onChanged: (val) => setState(() => _emailAlerts = val),
                  ),
                  const Divider(color: NeoColors.border, height: 1),
                  SwitchListTile(
                    activeThumbColor: NeoColors.primary,
                    title: const Text('Peringatan Stok Menipis', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Beri tahu jika ada barang dengan stok di bawah 10 pcs.'),
                    value: _stockAlerts,
                    onChanged: (val) => setState(() => _stockAlerts = val),
                  ),
                  const Divider(color: NeoColors.border, height: 1),
                  SwitchListTile(
                    activeThumbColor: NeoColors.primary,
                    title: const Text('Notifikasi SMS', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Kirim pesan SMS untuk verifikasi transaksi.'),
                    value: _smsAlerts,
                    onChanged: (val) => setState(() => _smsAlerts = val),
                  ),
                ] else if (_activeTab == 2) ...[
                  const Text('Pengaturan Pembayaran & Pajak', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCurrency,
                    decoration: const InputDecoration(
                      labelText: 'Mata Uang Utama',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'IDR (Rp)', child: Text('Rupiah Indonesia (IDR)')),
                      DropdownMenuItem(value: 'USD (\$)', child: Text('US Dollar (USD)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCurrency = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _taxController,
                    decoration: const InputDecoration(
                      labelText: 'Tarif PPn / Tax Rate',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.percent_rounded),
                    ),
                  ),
                ] else ...[
                  const Text('Keamanan & Hak Akses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 16),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Saat Ini',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.key_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    activeThumbColor: NeoColors.primary,
                    title: const Text('Otentikasi Dua-Faktor (2FA)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Gunakan aplikasi Authenticator untuk perlindungan ekstra.'),
                    value: _darkMode,
                    onChanged: (val) => setState(() => _darkMode = val),
                  ),
                ],
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    NeoButton(
                      label: 'Simpan Perubahan',
                      color: NeoColors.primary,
                      icon: Icons.save_rounded,
                      onPressed: _saveSettings,
                    ),
                    NeoButton(
                      label: 'Reset Defaults',
                      color: Colors.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form direset ke nilai default.')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: selected
              ? NeoTheme.boxDecoration(
                  color: NeoColors.primary,
                  radius: 8,
                  shadow: const Offset(2, 2),
                )
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: NeoColors.textDark),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                  color: NeoColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
