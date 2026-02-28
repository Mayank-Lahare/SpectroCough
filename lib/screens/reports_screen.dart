// ============================================================
// Reports Screen
// ------------------------------------------------------------
// Responsibilities:
// - Fetch prediction history from backend
// - Display prediction results
// - Clear history from backend
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../services/api_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<dynamic> _reports = [];
  bool _loading = true;

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  // ============================================================
  // Fetch Reports
  // ============================================================

  Future<void> _loadReports() async {
    try {
      final data = await ApiService.fetchPredictions();

      if (!mounted) return;

      setState(() {
        _reports = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  // ============================================================
  // Clear History
  // ============================================================

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ClearHistoryDialog(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Reports')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _reports.isEmpty
              ? const Center(
                  child: Text('No reports yet', style: AppTextStyles.bodyText),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================================================
                    // Header Text
                    // ============================================================
                    const Text(
                      'Previous Screenings',
                      style: AppTextStyles.headingMedium,
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: ListView.separated(
                        itemCount: _reports.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _reports[index];

                          final formattedDate = DateFormat(
                            'dd MMM yyyy',
                          ).format(DateTime.parse(item["created_at"]));

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: AppTextStyles.smallText,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item["predicted_class"],
                                        style: AppTextStyles.bodyText.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.buttonBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${item["confidence"]}%',
                                    style: AppTextStyles.bodyText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ============================================================
                    // Clear History Button
                    // ============================================================
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _clearHistory,
                        child: const Text('Clear History'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ClearHistoryDialog extends StatelessWidget {
  const ClearHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Clear History?"),
      content: const Text("This will permanently delete all reports."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Clear"),
        ),
      ],
    );
  }
}
