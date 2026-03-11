import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/detailed_report_model.dart';
import '../services/api_service.dart';
import '../services/pdf_service.dart';

import '../theme/app_colors.dart';

import '../widgets/report/hero_result_card.dart';
import '../widgets/report/section_card.dart';
import '../widgets/report/probability_row.dart';
import '../widgets/report/disclaimer_card.dart';

import '../utils/symptom_map.dart';


/// ============================
/// Detailed Report Screen
/// ============================
class DetailedReportScreen extends StatefulWidget {
  final DetailedReport report;

  const DetailedReportScreen({
    super.key,
    required this.report,
  });

  @override
  State<DetailedReportScreen> createState() => _DetailedReportScreenState();
}

class _DetailedReportScreenState extends State<DetailedReportScreen>
    with SingleTickerProviderStateMixin {

  String? _username;
  late final AnimationController _animController;

  /// ---------------- Init ----------------
  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward();

    _loadUser();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// ---------------- Load Current User ----------------
  Future<void> _loadUser() async {
    final user = await ApiService.getCurrentUser();

    if (!mounted) return;

    setState(() => _username = user?["name"]);
  }

  /// ---------------- Staggered Animation Helper ----------------
  Widget _animated(int index, Widget child) {
    final start = (index * 0.08).clamp(0.0, 0.7).toDouble();
    final end = (start + 0.42).clamp(0.0, 1.0).toDouble();
    final interval = Interval(start, end, curve: Curves.easeOut);

    return FadeTransition(
      opacity: CurvedAnimation(parent: _animController, curve: interval),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _animController, curve: interval),
        ),
        child: child,
      ),
    );
  }

  /// ============================ Build UI ============================
  @override
  Widget build(BuildContext context) {

    final report = widget.report;

    final date =
    DateFormat('dd MMM yyyy | HH:mm').format(report.date.toLocal());

    /// Sort probability values (highest first)
    final probabilities = report.probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topClass =
    probabilities.isNotEmpty ? probabilities.first.key : '';

    /// Get symptoms for predicted class
    final symptoms =
        symptomMap[report.predictedClass.toLowerCase()] ??
            ['No associated symptoms found'];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      /// ---------------- AppBar ----------------
      appBar: AppBar(
        title: const Text(
          'Detailed Report',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: AppColors.primary,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),

      /// ---------------- Floating Export Button ----------------
      floatingActionButton: PopupMenuButton<int>(
        tooltip: "Export Report",

        onSelected: (value) {
          if (value == 0) {
            PdfService.generateReportPdf(
              widget.report,
              username: _username,
            );
          }

          if (value == 1) {
            PdfService.generateReportPdf(
              widget.report,
              username: _username,
            );
          }
        },

        itemBuilder: (context) => const [

          PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_outlined),
                SizedBox(width: 10),
                Text("Download PDF"),
              ],
            ),
          ),

          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.print_outlined),
                SizedBox(width: 10),
                Text("Print Report"),
              ],
            ),
          ),
        ],

        child: FloatingActionButton(
          backgroundColor: AppColors.primaryDark,
          onPressed: null,
          child: const Icon(Icons.download_rounded),
        ),
      ),

      /// ---------------- Screen Body ----------------
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),

          children: [

            /// Report Header
            _animated(
              0,
              _ReportHeader(username: _username, date: date),
            ),

            const SizedBox(height: 20),

            /// Prediction Result
            _animated(
              1,
              HeroResultCard(report: report),
            ),

            const SizedBox(height: 20),

            /// Probability Distribution
            _animated(
              2,
              SectionCard(
                title: 'Class Probability Distribution',
                child: Column(
                  children: probabilities.map((entry) {
                    return ProbabilityRow(
                      label: entry.key,
                      value: entry.value / 100,
                      isTop: entry.key == topClass,
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Possible Symptoms
            _animated(
              3,
              SectionCard(
                title: 'Possible Symptoms',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: symptoms.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.07),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'These symptoms may or may not apply to you.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Disclaimer
            _animated(
              4,
              const DisclaimerCard(),
            ),
          ],
        ),
      ),
    );
  }
}


/// ============================
/// Report Header
/// ============================
class _ReportHeader extends StatelessWidget {

  final String? username;
  final String date;

  const _ReportHeader({
    required this.username,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

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

          /// Report Icon
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.description_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          /// Title + Metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'SpectroCough Screening Report',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [

                    if (username != null)
                      _MetaPill(
                        icon: Icons.person_outline_rounded,
                        label: username!,
                      ),

                    _MetaPill(
                      icon: Icons.access_time_rounded,
                      label: date,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// ============================
/// Metadata Pill
/// ============================
class _MetaPill extends StatelessWidget {

  final IconData icon;
  final String label;

  const _MetaPill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 10,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: 4),

          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}