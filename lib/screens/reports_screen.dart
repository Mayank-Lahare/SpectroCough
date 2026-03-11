// ============================================================
// Reports Screen (Premium + System Consistent)
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_drawer.dart';
import '../models/detailed_report_model.dart';
import '../screens/detailed_report_screen.dart';
// ============================================================
// Report Model
// ============================================================

class Report {
  final DateTime date;
  final String predictedClass;
  final double confidence;
  final Map<String, double> probabilities;
  final double top2Margin;
  final List<String> warnings;

  Report({
    required this.date,
    required this.predictedClass,
    required this.confidence,
    required this.probabilities,
    required this.top2Margin,
    required this.warnings,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      date: DateTime.parse(json["created_at"]),
      predictedClass: json["predicted_class"],
      confidence: (json["confidence"] as num).toDouble(),
      probabilities: Map<String, double>.from(
        json["class_probabilities"] ?? {},
      ),
      top2Margin: (json["top2_margin"] as num?)?.toDouble() ?? 0,
      warnings: List<String>.from(json["warnings"] ?? []),
    );
  }
}
// ============================================================
// Reports Screen
// ============================================================

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Report> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  // ============================================================

  Future<void> _loadReports() async {
    try {
      final data = await ApiService.fetchPredictions();

      if (!mounted) return;

      setState(() {
        _reports = data.map<Report>((item) => Report.fromJson(item)).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  // ============================================================

  Future<void> _clearHistory() async {
    final confirm = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _ClearHistorySheet(),
    );

    if (confirm != true) return;

    final success = await ApiService.clearPredictions();

    if (!mounted) return;

    if (success) {
      setState(() => _reports = []);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("History cleared")));
    }
  }

  // ============================================================
  // Confidence Color (System Status Aligned)
  // ============================================================

  Color _confidenceColor(double value) {
    if (value > 80) return AppColors.success;
    if (value > 50) return AppColors.warning;
    return AppColors.danger;
  }

  // ============================================================
  // Proper Case Helper (UI Formatting Only)
  // ============================================================

  String _toProperCase(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        centerTitle: true,
        actions: [
          if (_reports.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _reports.isEmpty
                ? const Center(
                    child: Text(
                      'No reports yet',
                      style: AppTextStyles.bodyText,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====================================================
                      // Header
                      // ====================================================
                      const Text(
                        'Previous Screenings',
                        style: AppTextStyles.headingMedium,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '${_reports.length} Screenings',
                        style: AppTextStyles.smallText,
                      ),

                      const SizedBox(height: 24),

                      // ====================================================
                      // List
                      // ====================================================
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _loadReports,
                          child: ListView.separated(
                            itemCount: _reports.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final report = _reports[index];

                              return TweenAnimationBuilder(
                                duration: Duration(
                                  milliseconds: 300 + (index * 50),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, double value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedReportScreen(
                                          report: DetailedReport(
                                            date: report.date,
                                            predictedClass: report.predictedClass,
                                            confidence: report.confidence,
                                            probabilities: report.probabilities,
                                          ),
                                        ),
                                      ),
                                    );},
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                DateFormat(
                                                  'dd MMM yyyy',
                                                ).format(report.date),
                                                style: AppTextStyles.smallText,
                                              ),
                                              Text(
                                                '${report.confidence.toStringAsFixed(0)}%',
                                                style: AppTextStyles.bodyText
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: _confidenceColor(
                                                        report.confidence,
                                                      ),
                                                    ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 8),

                                          Text(
                                            _toProperCase(
                                              report.predictedClass,
                                            ),
                                            style: AppTextStyles.bodyText
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                          ),

                                          const SizedBox(height: 12),

                                          LinearProgressIndicator(
                                            value: report.confidence / 100,
                                            backgroundColor: AppColors.surface,
                                            minHeight: 6,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: _confidenceColor(
                                              report.confidence,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Bottom Sheet
// ============================================================

class _ClearHistorySheet extends StatelessWidget {
  const _ClearHistorySheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        children: [
          const Text("Clear History?", style: AppTextStyles.headingMedium),
          const SizedBox(height: 12),
          const Text(
            "This will permanently delete all reports.",
            style: AppTextStyles.bodyText,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Clear"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
