class News {
  final int cmsID;
  final int categoryID;
  final String title;
  final String slug;
  final String content;
  final String? attachment;
  final String createdDate;
  final String categoryName;

  News({
    required this.cmsID,
    required this.categoryID,
    required this.title,
    required this.slug,
    required this.content,
    this.attachment,
    required this.createdDate,
    required this.categoryName,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      cmsID: json['CmsID'] ?? 0,
      categoryID: json['CategoryID'] ?? 0,
      title: json['Title'] ?? '',
      slug: json['Slug'] ?? '',
      content: json['Content'] ?? '',
      attachment: json['Attachment'],
      createdDate: json['CreatedDate'] ?? '',
      categoryName: json['CategoryName'] ?? '',
    );
  }

  // Format date from "2026-01-17 00:00:00" to "17/01/2026"
  String get dateFormatted {
    try {
      final parts = createdDate.split(' ')[0].split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (e) {
      // Return original if parsing fails
    }
    return createdDate;
  }
}
