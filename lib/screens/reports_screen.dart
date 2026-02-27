import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/prediction_result.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PredictionResults>('historyBox');

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Reports')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<PredictionResults> box, _) {
              final reports = box.values.toList().reversed.toList();

              if (reports.isEmpty) {
                return const Center(
                  child: Text('No reports yet', style: AppTextStyles.bodyText),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Previous Screenings',
                    style: AppTextStyles.headingMedium,
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      itemCount: reports.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = reports[index];
                        final formattedDate = DateFormat(
                          'dd MMM yyyy',
                        ).format(item.dateTime);

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: AppTextStyles.smallText,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.condition,
                                      style: AppTextStyles.bodyText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.buttonBlue,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  '${item.confidence.toStringAsFixed(2)}%',
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

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const ClearHistoryDialog(),
                        );

                        if (confirm == true) {
                          await box.clear();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('History cleared')),
                            );
                          }
                        }
                      },
                      child: const Text('Clear History'),
                    ),
                  ),
                ],
              );
            },
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
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 30,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.buttonBlue.withValues(alpha: 0.12),
              radius: 26,
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.buttonBlue,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Clear History?',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            const Text(
              'This action will permanently delete all previous reports.',
              style: AppTextStyles.smallText,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBlue,
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
