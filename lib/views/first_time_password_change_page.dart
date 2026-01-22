import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../repositories/auth_repository.dart';

class FirstTimePasswordChangePage extends StatefulWidget {
  final String phoneNumber;
  final String studentName;
  final String studentCode;
  final String parentCCCD;

  const FirstTimePasswordChangePage({
    super.key,
    required this.phoneNumber,
    required this.studentName,
    required this.studentCode,
    required this.parentCCCD,
  });

  @override
  State<FirstTimePasswordChangePage> createState() =>
      _FirstTimePasswordChangePageState();
}

class _FirstTimePasswordChangePageState
    extends State<FirstTimePasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _captchaController = TextEditingController();
  final AuthController _loginController = AuthController();
  final _authRepository = ApiAuthRepository();

  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;
  bool _isPolicyAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _rePasswordController.dispose();
    _captchaController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  void _refreshCaptcha() {
    setState(() {
      _loginController.generateCaptcha();
      _captchaController.clear();
    });
  }

  void _handlePasswordChange() async {
    if (!_isPolicyAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng đọc và đồng ý với chính sách sử dụng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Validate parameters
        if (widget.parentCCCD.isEmpty) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'CCCD phụ huynh không hợp lệ. Vui lòng đăng nhập lại.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Call API to change password via repository
        final result = await _authRepository.changePassword(
          _newPasswordController.text.trim(),
          widget.parentCCCD,
          widget.phoneNumber,
        );

        setState(() {
          _isLoading = false;
        });

        if (result != null) {
          if (mounted) {
            if (result['success'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Đổi mật khẩu thành công. Vui lòng đăng nhập lại.',
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              // Quay lại màn hình login
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result['message'] ??
                        'Đổi mật khẩu thất bại. Vui lòng thử lại.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              _refreshCaptcha();
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Không thể kết nối đến máy chủ. Vui lòng thử lại.',
                ),
                backgroundColor: Colors.red,
              ),
            );
            _refreshCaptcha();
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
          _refreshCaptcha();
        }
      }
    } else {
      _refreshCaptcha();
    }
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu mới';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String? _validateRePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu';
    }
    if (value != _newPasswordController.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  String? _validateCaptcha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã bảo mật';
    }
    if (value != _loginController.captchaText) {
      return 'Mã bảo mật không đúng';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF213C73),
        title: const Text(
          'Đổi mật khẩu lần đầu',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Logo và tiêu đề
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset(
                          'lib/public/img/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ĐẠI HỌC ĐÀ NẴNG',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF213C73),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'TRƯỜNG ĐẠI HỌC CÔNG NGHỆ THÔNG TIN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBB2033),
                              ),
                            ),
                            const Text(
                              'VÀ TRUYỀN THÔNG VIỆT - HÀN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFBB2033),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Chính sách
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CAM KẾT SỬ DỤNG CỔNG THÔNG TIN PHỤ HUYNH',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF213C73),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Căn cứ theo Thông báo số: 1788, ngày 28/10/2024 của Trường Đại học Công nghệ Thông tin và Truyền thông Việt - Hàn về việc triển khai sử dụng Cổng thông tin Phụ huynh.',
                          style: TextStyle(fontSize: 11, height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tôi, phụ huynh của sinh viên: ${widget.studentName}, mã sinh viên ${widget.studentCode}, xin cam kết thực hiện đầy đủ các nội dung sau:',
                          style: const TextStyle(fontSize: 11, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        _buildPolicyItem(
                          '1',
                          'Truy cập và sử dụng Cổng thông tin Phụ huynh thường xuyên để cập nhật thông tin về tình hình học tập, rèn luyện của sinh viên tại trường.',
                        ),
                        _buildPolicyItem(
                          '2',
                          'Chủ động tìm hiểu và sử dụng các tính năng của Cổng thông tin bao gồm: tra cứu thông tin sinh viên, thông tin học phí, kết quả học tập, chuyên cần, thời khóa biểu, chương trình đào tạo và các thông tin chung khác.',
                        ),
                        _buildPolicyItem(
                          '3',
                          'Thực hiện đúng các quy định về bảo mật thông tin khi sử dụng Cổng thông tin, không chia sẻ tài khoản đăng nhập với người khác và không sử dụng thông tin trên Cổng thông tin cho các mục đích trái phép.',
                        ),
                        _buildPolicyItem(
                          '4',
                          'Thông báo kịp thời cho Nhà trường khi phát hiện bất kỳ sự cố kỹ thuật hoặc nội dung không chính xác trên Cổng thông tin.',
                        ),
                        _buildPolicyItem(
                          '5',
                          'Cam kết đọc kỹ và tuân thủ hướng dẫn sử dụng hệ thống cổng thông tin phụ huynh để sử dụng Cổng thông tin một cách hiệu quả.',
                        ),
                        _buildPolicyItem(
                          '6',
                          'Hợp tác với Nhà trường trong việc sử dụng Cổng thông tin Phụ huynh để nâng cao hiệu quả công tác quản lý và hỗ trợ sinh viên.',
                        ),
                        _buildPolicyItem(
                          '7',
                          'Liên hệ với Phòng Công tác Sinh viên khi gặp bất kỳ khó khăn hoặc vướng mắc nào trong quá trình sử dụng Cổng thông tin.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checkbox đồng ý
                  Row(
                    children: [
                      Checkbox(
                        value: _isPolicyAccepted,
                        onChanged: (value) {
                          setState(() {
                            _isPolicyAccepted = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFFFEB914),
                      ),
                      const Expanded(
                        child: Text(
                          'Tôi đã đọc và đồng ý với các điều khoản trên',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Số điện thoại (read-only)
                  const Text(
                    'SỐ ĐIỆN THOẠI:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: widget.phoneNumber,
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CCCD phụ huynh (read-only)
                  const Text(
                    'CCCD PHỤ HUYNH:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: widget.parentCCCD,
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mật khẩu mới
                  const Text(
                    'MẬT KHẨU MỚI:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu mới',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: _validateNewPassword,
                  ),
                  const SizedBox(height: 20),

                  // Nhập lại mật khẩu
                  const Text(
                    'NHẬP LẠI MẬT KHẨU:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _rePasswordController,
                    obscureText: !_isRePasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Nhập lại mật khẩu',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isRePasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isRePasswordVisible = !_isRePasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: _validateRePassword,
                  ),
                  const SizedBox(height: 20),

                  // Mã bảo mật
                  const Text(
                    'MÃ BẢO MẬT:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _captchaController,
                          decoration: InputDecoration(
                            hintText: 'Nhập mã',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: _validateCaptcha,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEB914),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _loginController.captchaText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _refreshCaptcha,
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Nút xác nhận
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handlePasswordChange,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEB914),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Xác nhận đổi mật khẩu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
