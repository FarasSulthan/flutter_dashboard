import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'theme/neo_theme.dart';

void main() {
  runApp(const FarashaApp());
}

class FarashaApp extends StatelessWidget {
  const FarashaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farasha Dashboard',
      debugShowCheckedModeBanner: false,
      theme: NeoTheme.themeData,
      home: const DashboardPage(),
    );
  }
}
