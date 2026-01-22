import '../controllers/auth_controller.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>?> login(String phoneNumber, String cccd);
  Future<Map<String, dynamic>?> changePassword(
    String newPassword,
    String cccd,
    String phoneNumber,
  );
}

/// Repository layer cho Auth - chỉ đóng vai trò data source wrapper
/// Logic xử lý API đã được chuyển sang AuthController
class ApiAuthRepository implements AuthRepository {
  final AuthController _controller = AuthController();

  @override
  Future<Map<String, dynamic>?> login(String phoneNumber, String cccd) async {
    return await _controller.login(phoneNumber, cccd);
  }

  @override
  Future<Map<String, dynamic>?> changePassword(
    String newPassword,
    String cccd,
    String phoneNumber,
  ) async {
    return await _controller.changePassword(newPassword, cccd, phoneNumber);
  }
}
