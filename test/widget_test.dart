import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physioghar/main.dart';

void main() {
  testWidgets('PhysioGharApp initializes and navigates across all tabs cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400); // 392 x 872
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: PhysioGharApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PhysioGharApp), findsOneWidget);

    // Navigate to Schedule (index 1)
    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Schedule'), findsWidgets);

    // Test Schedule: Tap filter "Open"
    final openFilter = find.text('Open');
    if (openFilter.evaluate().isNotEmpty) {
      await tester.tap(openFilter.first);
      await tester.pumpAndSettle();
    }

    // Test Schedule: Navigate week with next/prev buttons
    final nextWeekBtn = find.byTooltip('Next Week');
    if (nextWeekBtn.evaluate().isNotEmpty) {
      await tester.tap(nextWeekBtn);
      await tester.pumpAndSettle();
    }

    // Navigate to Sessions (index 2)
    await tester.tap(find.byIcon(Icons.healing_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Sessions'), findsWidgets);

    // Test Sessions: Switch to Upcoming tab
    final upcomingTab = find.text('Upcoming');
    if (upcomingTab.evaluate().isNotEmpty) {
      await tester.tap(upcomingTab.first);
      await tester.pumpAndSettle();
    }

    // Switch to Completed tab
    final completedTab = find.text('Completed');
    if (completedTab.evaluate().isNotEmpty) {
      await tester.tap(completedTab);
      await tester.pumpAndSettle();
    }

    // Navigate to Patients (index 3)
    await tester.tap(find.byIcon(Icons.people_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Patients'), findsWidgets);

    // Test Patients: Search for a patient
    await tester.enterText(find.byType(TextField), 'Sita');
    await tester.pumpAndSettle();
    expect(find.text('Sita Sharma'), findsWidgets);

    // Test Patients: Tap on Sita Sharma to view details
    await tester.tap(find.text('Sita Sharma'));
    await tester.pumpAndSettle();
    expect(find.text('Patient Details'), findsOneWidget);
    expect(find.text('Call Patient'), findsOneWidget);
    expect(find.text('Associated Sessions'), findsOneWidget);

    // Go back to Patients list
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
  });
}
