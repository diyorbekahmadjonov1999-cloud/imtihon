import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codial_crm/main.dart';
import 'package:codial_crm/providers/crm_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Codial CRM smoke test', (WidgetTester tester) async {
    // Configure Web Viewport size for test
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CrmProvider()),
        ],
        child: const CodialCrmApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Login Screen appears
    expect(find.text('CODIAL'), findsOneWidget);
    expect(find.text('Tizimga Kirish'), findsOneWidget);

    // Tap "Admin Paneliga Kirish"
    await tester.tap(find.text('Admin Paneliga Kirish'));
    await tester.pumpAndSettle();

    // Verify Admin Dashboard appears
    expect(find.text('Boshqaruv Paneli (Admin)'), findsOneWidget);
  });
}
