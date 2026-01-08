import 'package:flutter/material.dart';
import 'dart:math';
import '../models/user_model.dart';

class LoginController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  bool isLoading = false;
  String _captchaText = '';

  LoginController() {
    generateCaptcha();
  }

  String get captchaText => _captchaText;

  // Sinh mã captcha ngẫu nhiên
  void generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
    final random = Random();
    _captchaText = String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // Hàm đăng nhập - hiện tại chỉ là mock, sau này sẽ gọi API
  Future<User?> login() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock validation - sau này thay bằng API call thật
    if (phoneController.text.isNotEmpty && 
        passwordController.text.isNotEmpty &&
        captchaController.text.isNotEmpty) {
      return User(
        phoneNumber: phoneController.text,
        name: 'Phụ huynh',
      );
    }
    return null;
  }

  // Validate số điện thoại
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (value.length < 10) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  // Validate mật khẩu
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    return null;
  }

  // Validate captcha
  String? validateCaptcha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã bảo mật';
    }
    if (value != _captchaText) {
      return 'Mã bảo mật không đúng';
    }
    return null;
  }

  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    captchaController.dispose();
  }
}
