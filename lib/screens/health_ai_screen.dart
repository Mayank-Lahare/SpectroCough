// ============================================================
// Health & AI Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:spectrocough/theme/app_colors.dart';
import '../services/news_service.dart';
import '../models/news_article.dart';
import 'article_webview_screen.dart';

class HealthAiScreen extends StatelessWidget {
  const HealthAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Health & AI',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: NewsService.fetchHealthAiNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingSkeleton();
          }

          if (snapshot.hasError) {
            return const _EmptyState(
              icon: Icons.cloud_off_rounded,
              message: 'Unable to load updates.',
              sub: 'Check your connection and try again.',
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return const _EmptyState(
              icon: Icons.article_outlined,
              message: 'No updates available.',
              sub: 'Check back soon for the latest health & AI news.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // forces FutureBuilder rebuild
              (context as Element).markNeedsBuild();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: _HeroCard(article: articles[0]),
                  );
                }

                if (index == 1 && articles.length > 1) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(label: 'Latest'),
                      _CompactCard(article: articles[index]),
                    ],
                  );
                }

                return _CompactCard(article: articles[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// Hero Card
// ============================================================

class _HeroCard extends StatelessWidget {
  final NewsArticle article;

  const _HeroCard({required this.article});

  void _open(BuildContext context) {
    if (article.url.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ArticleWebViewScreen(url: article.url, title: article.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (article.imageUrl.isNotEmpty)
              Transform.scale(
                scale: 1.05,
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  frameBuilder: (ctx, child, frame, sync) => AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 350),
                    child: child,
                  ),
                  errorBuilder: (context, error, stackTrace) =>
                      const _ImagePlaceholder(),
                ),
              )
            else
              const _ImagePlaceholder(),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.primaryDark.withValues(alpha: 0.82),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            const Positioned(top: 14, left: 14, child: _Tag(label: 'Featured')),

            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                  if (article.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Compact Card
// ============================================================

class _CompactCard extends StatelessWidget {
  final NewsArticle article;

  const _CompactCard({required this.article});

  void _open(BuildContext context) {
    if (article.url.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ArticleWebViewScreen(url: article.url, title: article.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _open(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: article.imageUrl.isNotEmpty
                      ? Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) =>
                              const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (article.description.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 11,
                            color: AppColors.accent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Read article',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Section Header
// ============================================================

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Tag
// ============================================================

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ============================================================
// Image Placeholder
// ============================================================

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.health_and_safety_outlined,
          size: 42,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ============================================================
// Loading
// ============================================================

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ============================================================
// Empty State
// ============================================================

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
