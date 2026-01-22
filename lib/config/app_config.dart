import 'package:flutter_dotenv/flutter_dotenv.dart';
class AppConfig {
  /// Base URL for API endpoints.
  static String get baseUrl {
    try {
      return dotenv.env['BASE_URL'] ?? '';
    } catch (_) {
      // dotenv not initialized
      return '';
    }
  }
}
