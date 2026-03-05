import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/news_article.dart';

class NewsService {
  static String get _apiKey => dotenv.env['GNEWS_API_KEY'] ?? '';

  static Future<List<NewsArticle>> fetchHealthAiNews() async {
    final uri = Uri.parse(
      'https://gnews.io/api/v4/search'
          '?q=AI%20healthcare%20OR%20medical%20technology%20OR%20digital%20health%20OR%20health%20innovation'
          '&lang=en'
          '&sortby=publishedAt'
          '&max=10'
          '&token=$_apiKey',
    );

    final response =
    await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List articlesJson = (data['articles'] ?? []) as List;

      return articlesJson
          .map((json) => NewsArticle.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load Health & AI news');
    }
  }
}