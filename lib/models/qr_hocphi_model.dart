import 'dart:typed_data';

/// Dữ liệu mã QR học phí từ API qrhocphi_taomoi
/// Hiển thị từ [imageUrl] (nếu có) hoặc [imageBytes] (decode từ info base64)
class QrHocPhiData {
  final String? imageUrl;
  final Uint8List? imageBytes;

  QrHocPhiData({this.imageUrl, this.imageBytes});

  bool get hasImage => (imageUrl != null && imageUrl!.isNotEmpty) || (imageBytes != null && imageBytes!.isNotEmpty);
}
