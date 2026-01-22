import 'auth_repository.dart';
import '../controllers/auth_controller.dart';


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
