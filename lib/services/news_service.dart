import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class NewsService {
  static const String _apiKey = '8239b4ebf5a694d2c9c6be1b87662910';

  static Future<List<NewsArticle>> fetchHealthAiNews() async {
    final uri = Uri.parse(
      'https://gnews.io/api/v4/search'
          '?q=AI%20healthcare%20OR%20medical%20technology%20OR%20digital%20health%20OR%20health%20innovation'
          '&lang=en'
          '&sortby=publishedAt'
          '&max=10'
          '&token=$_apiKey',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['articles'] ?? [];

      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Health & AI news');
    }
  }
}
