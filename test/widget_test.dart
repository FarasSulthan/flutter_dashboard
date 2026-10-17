import 'package:farasha_dashboard/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the dashboard overview', (tester) async {
    await tester.pumpWidget(const FarashaApp());

    expect(find.text('Selamat pagi, Anisa!'), findsOneWidget);
    expect(find.text('👋 ADMIN'), findsOneWidget);
    expect(find.text('Total Pendapatan'), findsOneWidget);
    expect(find.text('Transaksi Terbaru'), findsOneWidget);
  });
}
