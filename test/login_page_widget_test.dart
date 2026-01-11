import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:app_parent/views/login_page.dart';

// Simple TestAssetBundle to avoid asset loading errors in widget tests
class TestAssetBundle extends CachingAssetBundle {
  static const List<int> _kTransparentPng = <int>[
    137,
    80,
    78,
    71,
    13,
    10,
    26,
    10,
    0,
    0,
    0,
    13,
    73,
    72,
    68,
    82,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    1,
    8,
    6,
    0,
    0,
    0,
    31,
    21,
    196,
    137,
    0,
    0,
    0,
    13,
    73,
    68,
    65,
    84,
    8,
    153,
    99,
    0,
    0,
    0,
    2,
    0,
    1,
    0,
    18,
    103,
    129,
    28,
    0,
    0,
    0,
    0,
    73,
    69,
    78,
    68,
    174,
    66,
    96,
    130,
  ];

  @override
  Future<ByteData> load(String key) async {
    // Return a tiny valid PNG for any png asset so image codec doesn't fail in tests.
    if (key.toLowerCase().endsWith('.png')) {
      final bytes = Uint8List.fromList(_kTransparentPng);
      return ByteData.view(bytes.buffer);
    }
    return Future.value(ByteData(0));
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      Future.value('');

  @override
  Future<T> loadStructuredBinaryData<T>(
    String key,
    FutureOr<T> Function(ByteData) parser,
  ) async {
    // Provide a valid encoded empty map so AssetManifest binary decoding won't fail.
    final codec = StandardMessageCodec();
    final encoded = codec.encodeMessage(<String, dynamic>{});
    final bytes = encoded ?? Uint8List(0);
    // Use the bytes' offset and length so we don't include unrelated bytes from the
    // underlying buffer (which can corrupt StandardMessageCodec decoding).
    final bd = ByteData.view(
      bytes.buffer,
      bytes.offsetInBytes,
      bytes.lengthInBytes,
    );
    return parser(bd);
  }
}

void main() {
  testWidgets('successful login navigates to HomePage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    // Find the captcha text shown on screen
    final captchaFinder = find.byWidgetPredicate((widget) {
      return widget is Text &&
          widget.data != null &&
          RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(widget.data!);
    });

    expect(captchaFinder, findsOneWidget);
    final Text captchaWidget = tester.widget<Text>(captchaFinder);
    final captchaText = captchaWidget.data!;

    // Find the three TextFormFields (phone, password, captcha)
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(3));
    final phoneField = fields.at(0);
    final passwordField = fields.at(1);
    final captchaField = fields.at(2);

    expect(phoneField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(captchaField, findsOneWidget);

    await tester.enterText(phoneField, '0123456789');
    await tester.enterText(passwordField, 'password');
    await tester.enterText(captchaField, captchaText);

    // Tap the login button
    final loginBtn = find.widgetWithText(ElevatedButton, 'Đăng nhập');
    expect(loginBtn, findsOneWidget);

    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);
    // login() has a 1 second simulated delay
    await tester.pump(const Duration(milliseconds: 500));
    // should show CircularProgressIndicator while loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // HomePage greeting contains 'Xin chào phụ huynh'
    expect(find.textContaining('Xin chào phụ huynh'), findsOneWidget);
  });

  testWidgets('wrong captcha refreshes captcha text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    final captchaFinder = find.byWidgetPredicate((widget) {
      return widget is Text &&
          widget.data != null &&
          RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(widget.data!);
    });
    expect(captchaFinder, findsOneWidget);
    final Text captchaWidget = tester.widget<Text>(captchaFinder);
    final original = captchaWidget.data!;

    // Fill phone and password correctly but wrong captcha
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(3));
    final phoneField = fields.at(0);
    final passwordField = fields.at(1);
    final captchaField = fields.at(2);

    await tester.enterText(phoneField, '0123456789');
    await tester.enterText(passwordField, 'password');
    await tester.enterText(captchaField, 'WRONG');

    final loginBtn = find.widgetWithText(ElevatedButton, 'Đăng nhập');
    await tester.ensureVisible(loginBtn);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // After validation failure, captcha should be refreshed and different
    final newCaptchaWidget = tester.widget<Text>(
      find.byWidgetPredicate((widget) {
        return widget is Text &&
            widget.data != null &&
            RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(widget.data!);
      }),
    );

    expect(newCaptchaWidget.data, isNot(original));
  });
}
