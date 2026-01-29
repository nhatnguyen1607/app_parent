import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';
import '../models/news_model.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;
  final _unescape = HtmlUnescape();

  NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết thông báo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBB2033),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFBB2033), const Color(0xFF213C73)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      news.categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        news.dateFormatted,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content
            Container(
              padding: const EdgeInsets.all(20),
              child: Html(
                data: _unescape.convert(news.content),
                onLinkTap: (url, _, __) async {
                  if (url != null) {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  }
                },
                style: {
                  "body": Style(
                    fontSize: FontSize(15),
                    lineHeight: const LineHeight(1.6),
                    color: Colors.black87,
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 16),
                    fontSize: FontSize(15),
                    lineHeight: const LineHeight(1.6),
                  ),
                  "strong": Style(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF213C73),
                  ),
                  "em": Style(
                    fontStyle: FontStyle.normal,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  "a": Style(
                    color: const Color(0xFFBB2033),
                    textDecoration: TextDecoration.underline,
                  ),
                  "ul": Style(
                    margin: Margins.only(bottom: 16, left: 20),
                  ),
                  "ol": Style(
                    margin: Margins.only(bottom: 16, left: 20),
                  ),
                  "li": Style(
                    margin: Margins.only(bottom: 8),
                    fontSize: FontSize(15),
                  ),
                  "table": Style(
                    border: Border.all(color: Colors.grey[300]!),
                    margin: Margins.only(bottom: 16, top: 16),
                    width: Width(100, Unit.percent),
                  ),
                  "td": Style(
                    padding: HtmlPaddings.all(10),
                    border: Border.all(color: Colors.grey[300]!),
                    fontSize: FontSize(14),
                    alignment: Alignment.centerLeft,
                  ),
                  "th": Style(
                    padding: HtmlPaddings.all(10),
                    backgroundColor: const Color(0xFFBB2033).withOpacity(0.1),
                    fontWeight: FontWeight.bold,
                    border: Border.all(color: Colors.grey[300]!),
                    fontSize: FontSize(14),
                    alignment: Alignment.center,
                  ),
                  "h1": Style(
                    fontSize: FontSize(22),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF213C73),
                    margin: Margins.only(top: 20, bottom: 12),
                  ),
                  "h2": Style(
                    fontSize: FontSize(20),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF213C73),
                    margin: Margins.only(top: 18, bottom: 10),
                  ),
                  "h3": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF213C73),
                    margin: Margins.only(top: 16, bottom: 8),
                  ),
                },
              ),
            ),

            // Attachment button if available
            if (news.attachment != null && news.attachment!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(news.attachment!);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.attachment, color: Colors.white),
                  label: const Text(
                    'Mở tài liệu đính kèm',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BA345),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
