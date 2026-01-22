import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class AuthController {
  final String _baseUrl = AppConfig.baseUrl;
  
  // Controllers for login form
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();

  bool isLoading = false;
  String _captchaText = '';

  AuthController() {
    generateCaptcha();
  }

  String get captchaText => _captchaText;

  // Sinh mã captcha ngẫu nhiên
  void generateCaptcha() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789';
    final random = Random();
    _captchaText = String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Hàm đăng nhập - gọi API
  Future<Map<String, dynamic>?> login([String? phoneNumber, String? cccd]) async {
    try {
      final sdt = phoneNumber ?? phoneController.text.trim();
      final password = cccd ?? passwordController.text.trim();
      
      if (sdt.isEmpty || password.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/login?sdt=$sdt&cccd=$password'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> changePassword(
    String newPassword,
    String cccd,
    String phoneNumber,
  ) async {
    try {
      if (newPassword.isEmpty || cccd.isEmpty || phoneNumber.isEmpty) {
        return null;
      }

      final url = Uri.parse(
        '$_baseUrl/doipass?pass=$newPassword&cccd=$cccd&sdt=$phoneNumber',
      );

      print('Calling API: $url');
      print('Parameters: pass=$newPassword, cccd=$cccd, sdt=$phoneNumber');

      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Change password error: $e');
      return null;
    }
  }

  // Validate số điện thoại
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
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
