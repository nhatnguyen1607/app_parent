import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../config/app_config.dart';

class NewsController {
  final _baseUrl = AppConfig.baseUrl;
  Future<List<News>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tintuc'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if 'info' field exists and is a list
        if (data.containsKey('info') && data['info'] is List) {
          List<dynamic> newsJson = data['info'];
          return newsJson.map((json) => News.fromJson(json)).toList();
        }

        // If no info field, return empty list
        return [];
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  // Group news by category
  Map<String, List<News>> groupNewsByCategory(List<News> newsList) {
    Map<String, List<News>> grouped = {};

    for (var news in newsList) {
      if (!grouped.containsKey(news.categoryName)) {
        grouped[news.categoryName] = [];
      }
      grouped[news.categoryName]!.add(news);
    }

    // Sort each category by CreatedDate (newest first)
    grouped.forEach((category, list) {
      list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    });

    return grouped;
  }
}
