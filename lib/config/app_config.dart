// class AppConfig {
//   /// Base URL for API endpoints.
//   static const String baseUrl = 'https://daotao.vku.udn.vn/phuhuynh/api';
//   // {
//   //   try {
//   //     return 'https://daotao.vku.udn.vn/phuhuynh/api';
//   //   } catch (_) {
//   //     // dotenv not initialized
//   //     return '';
//   //   }
//   // }
// }
class AppConfig {
  // Dòng này sẽ lấy API_URL lúc bạn gõ lệnh build/run, nếu không có thì nó lấy link mặc định
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://daotao.vku.udn.vn/phuhuynh/api',
  );
}
