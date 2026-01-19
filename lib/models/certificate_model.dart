class Certificate {
  final String studentName;
  final String? physicalEducation; // Chứng chỉ Giáo dục thể chất
  final String? nationalDefense; // Chứng chỉ Giáo dục Quốc phòng
  final String? foreignLanguage; // Chứng chỉ Ngoại ngữ
  final String? informatics; // Chứng chỉ Tin học

  Certificate({
    required this.studentName,
    this.physicalEducation,
    this.nationalDefense,
    this.foreignLanguage,
    this.informatics,
  });
}

