import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  // TEMP: dummy history data (replace with real storage later)
  List<Map<String, String>> _dummyHistory() {
    return const [
      {'date': '23 Jul', 'condition': 'Asthma', 'confidence': '88%'},
      {'date': '21 Jul', 'condition': 'Normal', 'confidence': '92%'},
      {'date': '19 Jul', 'condition': 'Bronchitis', 'confidence': '78%'},
      {'date': '15 Jul', 'condition': 'COPD', 'confidence': '81%'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final history = _dummyHistory();

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Reports')),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // SCREEN TITLE
              // =========================
              const Text(
                'Previous Screenings',
                style: AppTextStyles.headingMedium,
              ),

              const SizedBox(height: 16),

              // =========================
              // HISTORY LIST
              // =========================
              Expanded(
                child: history.isEmpty
                    ? const Center(
                  child: Text(
                    'No reports yet',
                    style: AppTextStyles.bodyText,
                  ),
                )
                    : ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = history[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Date + Condition
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['date'] ?? '',
                                  style: AppTextStyles.smallText,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['condition'] ?? '',
                                  style: AppTextStyles.bodyText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.buttonBlue,
                                  ),
                                ),
                              ],
                            ),

                            // Right: Confidence
                            Text(
                              item['confidence'] ?? '',
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

              // =========================
              // CLEAR HISTORY CTA (stub)
              // =========================
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement clear history
                  },
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
