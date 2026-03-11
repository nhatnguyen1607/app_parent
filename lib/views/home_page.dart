import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/student_model.dart';
import '../models/news_model.dart';
import 'student_detail_page.dart';
import 'news_detail_page.dart';

import '../repositories/student_repository.dart';
import '../controllers/news_controller.dart';

class HomePage extends StatefulWidget {
  final User user;
  final List<Student>? initialStudents;
  final StudentRepository repository;

  HomePage({
    super.key,
    required this.user,
    this.initialStudents,
    StudentRepository? repository,
  }) : repository = repository ?? ApiStudentRepository();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock data - sau này sẽ lấy từ API
  late List<Student> students;
  List<News> _newsList = [];
  Map<String, List<News>> _groupedNews = {};
  Map<String, bool> _expandedCategories = {};
  bool _isLoadingNews = true;
  final NewsController _newsController = NewsController();

  @override
  void initState() {
    super.initState();
    // Use injected students when provided, otherwise fetch from repository
    if (widget.initialStudents != null) {
      students = widget.initialStudents!;
    } else {
      students = [];
      widget.repository.fetchStudents().then((list) {
        if (mounted) {
          setState(() {
            students = list;
          });
        }
      });
    }
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoadingNews = true;
    });

    try {
      final news = await _newsController.getNews();
      final grouped = _newsController.groupNewsByCategory(news);

      setState(() {
        _newsList = news;
        _groupedNews = grouped;
        _isLoadingNews = false;
        // Initialize all categories as collapsed
        _expandedCategories = {for (var key in grouped.keys) key: false};
      });
    } catch (e) {
      setState(() {
        _isLoadingNews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hệ thống phụ huynh VKU',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBB2033),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: const Color(0xFFBB2033),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Đăng xuất',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Xác nhận đăng xuất'),
                          content: const Text(
                            'Bạn có chắc chắn muốn đăng xuất?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Đóng dialog
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/',
                                ); // Về trang login
                              },
                              child: const Text(
                                'Đăng xuất',
                                style: TextStyle(color: Color(0xFFBB2033)),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFBB2033), const Color(0xFF213C73)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Row(
                      children: [
                        // Icon VKU
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.asset(
                              'lib/public/img/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Thông tin trường
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TRƯỜNG ĐẠI HỌC CÔNG NGHỆ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.45,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'THÔNG TIN VÀ TRUYỀN THÔNG VIỆT - HÀN',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.45,
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lời chào
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.waving_hand,
                              color: Color(0xFFFEB914),
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Xin chào phụ huynh, ${widget.user.name}!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Chào mừng bạn đến với hệ thống tra cứu thông tin sinh viên. VKU - Tự hào là trường đại học công lập quốc tế hàng đầu về đào tạo CNTT.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.95),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Danh sách sinh viên và Tin tức
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Danh sách sinh viên
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBB2033),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Danh sách sinh viên',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF213C73),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBB2033).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${students.length} sinh viên',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFBB2033),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Danh sách sinh viên
                    ...students.map((student) => _buildStudentCard(student)),

                    const SizedBox(height: 30),

                    // Header Tin tức
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBB2033),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Tin tức',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF213C73),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tin tức sections
                    if (_isLoadingNews)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(
                            color: Color(0xFFBB2033),
                          ),
                        ),
                      )
                    else if (_groupedNews.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.newspaper,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Chưa có thông báo',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._groupedNews.entries.map((entry) {
                        return _buildNewsCategory(entry.key, entry.value);
                      }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child:
                  (student.avatarUrl != null && student.avatarUrl!.isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        student.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey[400],
                          );
                        },
                      ),
                    )
                  : Icon(Icons.person, size: 50, color: Colors.grey[400]),
            ),
            const SizedBox(width: 16),

            // Thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBB2033),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.badge, 'Mã SV:', student.studentCode),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.class_, 'Lớp:', student.className),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.school, 'Ngành:', student.major),
                  const SizedBox(height: 4),
                  _buildInfoRow(Icons.person, 'GVCN:', student.GVCN),
                  _buildInfoRow(
                    Icons.info,
                    '',
                    '${student.phone_gv}-${student.email_gv}',
                  ),
                  const SizedBox(height: 12),

                  // Nút xem chi tiết
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailPage(student: student),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1BA345),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        '📋 Xem Chi tiết',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCategory(String categoryName, List<News> newsList) {
    final isExpanded = _expandedCategories[categoryName] ?? false;
    final displayList = isExpanded ? newsList : newsList.take(5).toList();
    final hasMore = newsList.length > 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFBB2033), const Color(0xFF213C73)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.campaign, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${newsList.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // News list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayList.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[200]),
            itemBuilder: (context, index) {
              final news = displayList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(news: news),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFBB2033),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF213C73),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  news.dateFormatted,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // See more button
          if (hasMore)
            InkWell(
              onTap: () {
                setState(() {
                  _expandedCategories[categoryName] = !isExpanded;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isExpanded ? 'Thu gọn' : 'Xem thêm',
                      style: const TextStyle(
                        color: Color(0xFFBB2033),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFFBB2033),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
