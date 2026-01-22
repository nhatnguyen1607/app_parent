import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'first_time_password_change_page.dart';
import '../repositories/student_repository.dart';
import '../models/user_model.dart';
import '../models/student_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _controller = AuthController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refreshCaptcha() {
    setState(() {
      _controller.generateCaptcha();
      _controller.captchaController.clear();
    });
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await _controller.login();

      setState(() {
        _isLoading = false;
      });

      if (response != null && mounted) {
        // Kiểm tra nếu success = true
        if (response['success'] == true) {
          final data = response['data'];

          // Nếu data = 1, sai số điện thoại hoặc mật khẩu
          if (data == 1) {
            _refreshCaptcha();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Số điện thoại hoặc mật khẩu không đúng. Vui lòng kiểm tra lại.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          // Nếu data = 0, đây là lần đăng nhập đầu tiên
          else if (data == 0) {
            final infoList = response['info'] as List<dynamic>;
            if (infoList.isNotEmpty) {
              final firstInfo = infoList[0];

              // Lấy 6 số cuối của password (cccd)
              final cccd = _controller.passwordController.text;
              final last6Digits = cccd.length >= 6
                  ? cccd.substring(cccd.length - 6)
                  : cccd;

              // Kiểm tra khớp với cmnd_cha hoặc cmnd_me
              String parentCCCD = '';
              final cmndCha = firstInfo['cmnd_cha']?.toString() ?? '';
              final cmndMe = firstInfo['cmnd_me']?.toString() ?? '';

              if (cmndCha.isNotEmpty && cmndCha.endsWith(last6Digits)) {
                parentCCCD = cmndCha;
              } else if (cmndMe.isNotEmpty && cmndMe.endsWith(last6Digits)) {
                parentCCCD = cmndMe;
              }

              final studentName =
                  '${firstInfo['hodem'] ?? ''} ${firstInfo['ten'] ?? ''}'
                      .trim();
              final studentCode = firstInfo['masv'] ?? '';

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FirstTimePasswordChangePage(
                    phoneNumber: _controller.phoneController.text,
                    studentName: studentName,
                    studentCode: studentCode,
                    parentCCCD: parentCCCD,
                  ),
                ),
              );
            }
          } else if (data == 3) {
            // Đăng nhập thành công - có thông tin chi tiết
            final infoList = response['info'] as List<dynamic>;
            if (infoList.isNotEmpty) {
              final firstInfo = infoList[0];

              // Kiểm tra phoneNumber với sdt_cha và sdt_me để xác định tên
              final phoneNumber = _controller.phoneController.text;
              final sdtCha = firstInfo['sdt_cha']?.toString() ?? '';
              final sdtMe = firstInfo['sdt_me']?.toString() ?? '';

              String parentName = 'Phụ huynh';
              String? parentEmail;
              
              if (phoneNumber == sdtCha && firstInfo['hotencha'] != null) {
                parentName = firstInfo['hotencha'];
                parentEmail = firstInfo['email_cha'];
              } else if (phoneNumber == sdtMe && firstInfo['hotenme'] != null) {
                parentName = firstInfo['hotenme'];
                parentEmail = firstInfo['email_me'];
              } else if (firstInfo['hotencha'] != null) {
                parentName = firstInfo['hotencha'];
                parentEmail = firstInfo['email_cha'];
              } else if (firstInfo['hotenme'] != null) {
                parentName = firstInfo['hotenme'];
                parentEmail = firstInfo['email_me'];
              }

              // Tạo User từ thông tin phụ huynh
              final user = User(
                phoneNumber: phoneNumber,
                name: parentName,
                email: parentEmail,
                fatherName: firstInfo['hotencha'],
                motherName: firstInfo['hotenme'],
                fatherPhone: firstInfo['sdt_cha'],
                motherPhone: firstInfo['sdt_me'],
              );

              // Tạo danh sách Student từ info
              final students = infoList
                  .map((info) => Student.fromJson(info))
                  .toList();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    user: user,
                    initialStudents: students,
                    repository: ApiStudentRepository(),
                  ),
                ),
              );
            }
          } else {
            // Các trường hợp khác - hiển thị thông báo lỗi
            _refreshCaptcha();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Đăng nhập thất bại
          _refreshCaptcha();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Lỗi kết nối hoặc response null
        if (mounted) {
          _refreshCaptcha();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không thể kết nối đến máy chủ. Vui lòng thử lại.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Validate thất bại - đổi mã captcha mới
      _refreshCaptcha();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      // Logo
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'lib/public/img/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Chữ
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ĐẠI HỌC ĐÀ NẴNG',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF213C73),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'TRƯỜNG ĐẠI HỌC CÔNG NGHỆ THÔNG TIN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBB2033),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'VÀ TRUYỀN THÔNG VIỆT - HÀN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBB2033),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'HỆ THỐNG DÀNH CHO PHỤ HUYNH VKU',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFFEB914),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Ảnh minh họa
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('lib/public/img/image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form đăng nhập
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Số điện thoại
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
                    controller: _controller.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Nhập số điện thoại phụ huynh',
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
                    validator: _controller.validatePhone,
                  ),
                  const SizedBox(height: 20),

                  // Mật khẩu
                  const Text(
                    'MẬT KHẨU:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controller.passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu',
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
                    validator: _controller.validatePassword,
                  ),
                  const SizedBox(height: 12),

                  // Hướng dẫn mật khẩu
                  Text(
                    'Nếu lần đầu phụ huynh đăng nhập, vui lòng nhập 06 số cuối CCCD của phụ huynh\n'
                    'Trong trường hợp phụ huynh không thể đăng nhập được. '
                    'Phụ huynh liên hệ số điện thoại:',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '0236.3.667.113 để được hỗ trợ',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFBB2033),
                      fontWeight: FontWeight.w500,
                    ),
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
                          controller: _controller.captchaController,
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
                          validator: _controller.validateCaptcha,
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
                              _controller.captchaText,
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

                  // Nút đăng nhập
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
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
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ghi chú
                  Text(
                    'Quý phụ huynh chưa biết cách xem thông tin của con em mình, '
                    'vui lòng liên lạc phòng Đào tạo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '0236.3.667.113',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFBB2033),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
