import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration loaded from environment variables.
///
/// Usage:
/// - Set USE_MOCK_API=true in .env to use mock data
/// - Set USE_MOCK_API=false in .env to use real API
class AppConfig {
  /// Override for testing purposes.
  /// Set this in tests to bypass dotenv loading.
  static bool? useMockApiOverride;

  /// Whether to use mock API instead of real API.
  /// Reads from USE_MOCK_API environment variable.
  /// Falls back to true if dotenv is not loaded (e.g., in tests).
  static bool get useMockApi {
    // Allow tests to override this value
    if (useMockApiOverride != null) {
      return useMockApiOverride!;
    }

    // Try to read from dotenv, default to true if not loaded
    try {
      return dotenv.env['USE_MOCK_API']?.toLowerCase() == 'true';
    } catch (_) {
      // dotenv not initialized, default to mock API
      return true;
    }
  }
}
