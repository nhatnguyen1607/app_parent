import 'package:flutter_test/flutter_test.dart';
import 'package:app_parent/controllers/login_controller.dart';

void main() {
  group('LoginController', () {
    test('generateCaptcha creates a 6-char captcha and changes when regenerated', () {
      final controller = LoginController();
      final first = controller.captchaText;

      expect(first, isNotEmpty);
      expect(first.length, 6);

      controller.generateCaptcha();
      final second = controller.captchaText;
      expect(second, isNot(first));
    });

    test('validatePhone returns error for empty/short and null for valid', () {
      final controller = LoginController();
      expect(controller.validatePhone(null), isNotNull);
      expect(controller.validatePhone(''), isNotNull);
      expect(controller.validatePhone('0123'), isNotNull);
      expect(controller.validatePhone('0123456789'), isNull);
    });

    test('validatePassword returns error for empty and null for non-empty', () {
      final controller = LoginController();
      expect(controller.validatePassword(null), isNotNull);
      expect(controller.validatePassword(''), isNotNull);
      expect(controller.validatePassword('secret'), isNull);
    });

    test('validateCaptcha returns error when mismatch and null when correct', () {
      final controller = LoginController();
      final correct = controller.captchaText;
      expect(controller.validateCaptcha(''), isNotNull);
      expect(controller.validateCaptcha('wrong'), isNotNull);
      expect(controller.validateCaptcha(correct), isNull);
    });

    test('login returns User when fields are non-empty and null otherwise', () async {
      final controller = LoginController();
      // empty controllers => null
      expect(await controller.login(), isNull);

      controller.phoneController.text = '0123456789';
      controller.passwordController.text = 'password';
      controller.captchaController.text = 'any';

      final user = await controller.login();
      expect(user, isNotNull);
      expect(user!.phoneNumber, '0123456789');
    });
  });
}
