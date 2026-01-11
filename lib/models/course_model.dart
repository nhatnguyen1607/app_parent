class Course {
  final String code;
  final String name;
  final int credits;
  final String knowledgeBlock; // e.g., 'Cơ sở ngành', 'Giáo dục đại cương'
  final String requiredType; // 'Bắt buộc' or 'Tự chọn'
  final int semester; // numeric semester
  final double? grade; // điểm đạt được (nếu có)

  Course({
    required this.code,
    required this.name,
    required this.credits,
    required this.knowledgeBlock,
    required this.requiredType,
    required this.semester,
    this.grade,
  });
}