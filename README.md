# app_parent

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Hướng dẫn tạm thời: mock data và chuyển sang API (Tiếng Việt)

> Vị trí mock test

- Các mock dùng cho tests đã được gom vào thư mục `test/helpers/`:
  - `test/helpers/mock_data.dart` — dữ liệu mô phỏng (User, Student...)
  - `test/helpers/mock_student_repository.dart` — repository mock dùng trong tests

> Cách hoạt động tại runtime

- Runtime hiện mặc định sử dụng `ApiStudentRepository` (nằm ở `lib/repositories/api_student_repository.dart`).
- Hàm tiện ích `getStudentRepository()` nằm trong `lib/repositories/repository_provider.dart` trả repository mặc định.

> Khi API thật sẵn sàng

1. Implement `ApiStudentRepository.fetchStudents()` để gọi API thật và trả `List<Student>`.
2. Kiểm tra kỹ `getStudentRepository()` để đảm bảo trả `ApiStudentRepository()` (mặc định). Nếu bạn muốn chạy với mock tại runtime (chỉ trong development), có thể thay đổi provider hoặc truyền một repository khác vào `HomePage` (constructor có tham số `repository`).
3. Sau khi API hoạt động và tests đã chuyển sang dùng fixtures của backend, bạn có thể xóa hoàn toàn `test/helpers/*` nếu không cần dùng nữa.

> Gợi ý thêm

- Để giữ sạch code production, hạn chế để mock trong `lib/`. Dùng dependency injection (truyền repository) để dễ hoán đổi giữa mock và API.
- Nếu cần, tôi có thể giúp viết `ApiStudentRepository` mẫu (gọi endpoint giả) và thêm ví dụ cấu hình để bật/tắt mock runtime bằng flavor hoặc biến môi trường.

