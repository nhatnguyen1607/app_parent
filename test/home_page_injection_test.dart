import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_parent/views/home_page.dart';
import 'helpers/mock_data.dart';

void main() {
  testWidgets('HomePage uses injected initialStudents when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(user: mockUser, initialStudents: mockStudents),
      ),
    );

    // The header shows the number of students from the list
    expect(find.textContaining('${mockStudents.length} sinh viên'), findsOneWidget);

    // At least the first student should appear on screen
    expect(find.textContaining(mockStudents.first.name), findsOneWidget);
  });
}
