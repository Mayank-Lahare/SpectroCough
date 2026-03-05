import 'package:flutter/material.dart';
import 'package:spectrocough/theme/app_colors.dart';
import '../services/news_service.dart';
import '../models/news_article.dart';
import 'article_webview_screen.dart';

class HealthAiScreen extends StatefulWidget {
  const HealthAiScreen({super.key});

  @override
  State<HealthAiScreen> createState() => _HealthAiScreenState();
}

class _HealthAiScreenState extends State<HealthAiScreen> {
  late final Future<List<NewsArticle>> _future;

  @override
  void initState() {
    super.initState();
    _future = NewsService.fetchHealthAiNews(); // Cached once
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health & AI"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Unable to load updates.",
                style: theme.textTheme.bodyMedium,
              ),
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return Center(
              child: Text(
                "No updates available.",
                style: theme.textTheme.bodyMedium,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _ArticleCard(article: articles[index]);
            },
          );
        },
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final NewsArticle article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (article.url.isEmpty) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ArticleWebViewScreen(url: article.url, title: article.title),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article.imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    article.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (
                          BuildContext context,
                          Widget child,
                          int? frame,
                          bool wasSynchronouslyLoaded,
                        ) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }

                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(milliseconds: 300),
                            child: child,
                          );
                        },
                    errorBuilder:
                        (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return const SizedBox();
                        },
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                article.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
