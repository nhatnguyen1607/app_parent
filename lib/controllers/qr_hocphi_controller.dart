import 'dart:convert';
import 'dart:typed_data';
import '../config/app_config.dart';
import 'package:http/http.dart' as http;
import '../models/qr_hocphi_model.dart';

class QrHocPhiController {
    final String _baseUrl = AppConfig.baseUrl;
  /// Gọi API qrhocphi_taomoi?masv= để lấy ảnh QR thanh toán ngân hàng.
  /// Ưu tiên dùng [img] nếu có; không được thì dùng [info] decode base64.
  Future<QrHocPhiData> getQrHocPhi(String masv) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/qrhocphi_taomoi?masv=$masv',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Không kết nối được server (mã ${response.statusCode})');
      }

      final body = json.decode(response.body);
      if (body is! Map<String, dynamic>) {
        throw Exception('Dữ liệu trả về không hợp lệ');
      }

      String? imageUrl;
      Uint8List? imageBytes;

      // Ưu tiên lấy từ img
      final img = body['img'];
      if (img != null && img.toString().trim().isNotEmpty) {
        final imgStr = img.toString().trim();
        if (imgStr.startsWith('http://') || imgStr.startsWith('https://')) {
          imageUrl = imgStr;
        } else {
          // img có thể là chuỗi base64 (hoặc data:image/png;base64,...)
          final base64Raw = imgStr.contains(',')
              ? imgStr.split(',').last
              : imgStr.replaceFirst(RegExp(r'^data:image/[^;]+;base64,'), '');
          try {
            imageBytes = base64Decode(base64Raw);
          } catch (_) {}
        }
      }

      // Nếu chưa có ảnh thì dùng info (base64) — có thể là body['info'] hoặc body['data']
      if (!_hasImage(imageUrl, imageBytes)) {
        final info = body['info'] ?? body['data'];
        if (info != null) {
          final String raw;
          if (info is Map && info['img'] != null) {
            raw = info['img'].toString().trim();
          } else if (info is Map && info['base64'] != null) {
            raw = info['base64'].toString().trim();
          } else {
            raw = info.toString().trim();
          }
          if (raw.isNotEmpty) {
            try {
            final base64Raw = raw.contains(',')
                ? raw.split(',').last
                : raw.replaceFirst(RegExp(r'^data:image/[^;]+;base64,'), '');
            imageBytes = base64Decode(base64Raw);
            } catch (_) {}
          }
        }
      }

      return QrHocPhiData(imageUrl: imageUrl, imageBytes: imageBytes);
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Lỗi tải mã QR học phí: $e');
    }
  }

  bool _hasImage(String? url, Uint8List? bytes) {
    return (url != null && url.isNotEmpty) || (bytes != null && bytes.isNotEmpty);
  }
}
