// ============================================================
// PDF Service — Redesigned Report
// ------------------------------------------------------------
// Generates the downloadable clinical-style PDF report
// for SpectroCough screening results.
//
// Utility:
// - Converts DetailedReport model into a styled PDF document
// - Displays prediction, probabilities, symptoms, and disclaimer
// - Uses brand colors to match app UI
// ============================================================

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/detailed_report_model.dart';
import '../utils/symptom_map.dart'; // used since symptoms are not part of model

class PdfService {
  // ==========================================================
  // Brand Colors
  // Used to visually match the app UI theme inside the PDF
  // ==========================================================

  static const _tealDark = PdfColor.fromInt(0xFF0E3E4F);
  static const _teal = PdfColor.fromInt(0xFF124E63);
  static const _cyan = PdfColor.fromInt(0xFF2CBECF);

  static const _success = PdfColor.fromInt(0xFF2E7D5B);
  static const _warning = PdfColor.fromInt(0xFFB07A2A);
  static const _danger = PdfColor.fromInt(0xFF9C3D3D);

  static const _textPrimary = PdfColor.fromInt(0xFF1C2B33);
  static const _textSecondary = PdfColor.fromInt(0xFF5B6B73);

  static const _surface = PdfColor.fromInt(0xFFE7F1F5);
  static const _white = PdfColors.white;
  static const _bgLight = PdfColor.fromInt(0xFFF2F7F9);

  // ==========================================================
  // Confidence color utility
  // Used to color confidence badge based on score
  // ==========================================================

  static PdfColor _confidenceColor(double value) {
    if (value > 80) return _success;
    if (value > 50) return _warning;
    return _danger;
  }

  static String _confidenceLabel(double value) {
    if (value > 80) return 'HIGH CONFIDENCE';
    if (value > 50) return 'MODERATE CONFIDENCE';
    return 'LOW CONFIDENCE';
  }

  // ==========================================================
  // Class color utility
  // Used for probability bars
  // ==========================================================

  static PdfColor _classColor(String className) {
    switch (className.toLowerCase()) {
      case 'asthma':
        return _teal;
      case 'copd':
        return _cyan;
      case 'pneumonia':
        return _warning;
      case 'healthy':
        return _success;
      default:
        return _teal;
    }
  }

  // ==========================================================
  // MAIN FUNCTION
  // Generates the PDF and opens print/share dialog
  // ==========================================================

  static Future<void> generateReportPdf(
    DetailedReport report, {
    String? username,
  }) async {
    final pdf = pw.Document();

    // Load logo from assets
    final ByteData logoData = await rootBundle.load('assets/logo/spectro_logo_pdf.png');

    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    final confColor = _confidenceColor(report.confidence);
    final confLabel = _confidenceLabel(report.confidence);

    // Format generation timestamp
    final now = DateTime.now();

    final generatedAt =
        '${now.day.toString().padLeft(2, '0')} '
        '${_monthName(now.month)} ${now.year} | '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    // ========================================================
    // PAGE LAYOUT
    // ========================================================

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header band with branding
              _buildHeader(logo),

              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 24,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Metadata information row
                      _buildMetadataGrid(report, username, generatedAt),

                      pw.SizedBox(height: 20),

                      // Prediction + confidence
                      _buildResultRow(report, confColor, confLabel),

                      pw.SizedBox(height: 20),

                      // Probability bars
                      _buildSectionTitle('Class Probability Distribution'),
                      pw.SizedBox(height: 10),
                      _buildProbabilities(report),

                      pw.SizedBox(height: 20),

                      // Symptoms
                      _buildSectionTitle('Possible Symptoms'),
                      pw.SizedBox(height: 10),
                      _buildSymptomChips(report),

                      pw.Spacer(),

                      _buildDisclaimer(),

                      pw.SizedBox(height: 14),

                      pw.Divider(
                        thickness: 0.5,
                        color: _surface,
                      ),

                      pw.SizedBox(height: 6),

                    // Footer
                      _buildFooter(generatedAt),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Opens print/share dialog
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // ==========================================================
  // HEADER SECTION
  // ==========================================================

  static pw.Widget _buildHeader(pw.MemoryImage logo) {
    return pw.Container(
      color: _tealDark,
      padding: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 22),
      child: pw.Row(
        children: [
          pw.Container(
            width: 48,
            height: 48,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(24),
            ),
            padding: const pw.EdgeInsets.all(8),
            child: pw.Image(logo),
          ),

          pw.SizedBox(width: 16),

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'SpectroCough',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: _white,
                ),
              ),
              pw.Text(
                'AI Respiratory Pre-Screening Report',
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColor.fromInt(0xAAFFFFFF),
                ),
              ),
            ],
          ),

          pw.Spacer(),

          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: pw.BoxDecoration(
              color: _cyan,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              'SCREENING REPORT',
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: _white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // METADATA GRID
  // Shows user, screening date and generation time
  // ==========================================================

  static pw.Widget _buildMetadataGrid(
    DetailedReport report,
    String? username,
    String generatedAt,
  ) {
    final formattedDate =
        '${report.date.day.toString().padLeft(2, '0')} '
        '${_monthName(report.date.month)} ${report.date.year}';

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: _bgLight,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: _surface),
      ),
      child: pw.Row(
        children: [
          _metaCell('User', username ?? 'Not specified'),
          _metaDivider(),
          _metaCell('Screening Date', formattedDate),
          _metaDivider(),
          _metaCell('Generated', generatedAt),
        ],
      ),
    );
  }

  static pw.Widget _metaCell(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label.toUpperCase(),
            style: pw.TextStyle(fontSize: 8, color: _textSecondary),
          ),

          pw.SizedBox(height: 4),

          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _metaDivider() {
    return pw.Container(
      width: 1,
      height: 32,
      margin: const pw.EdgeInsets.symmetric(horizontal: 16),
      color: _surface,
    );
  }

  // ==========================================================
  // RESULT ROW
  // ==========================================================

  static pw.Widget _buildResultRow(
    DetailedReport report,
    PdfColor confColor,
    String confLabel,
  ) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(colors: [_tealDark, _teal]),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'PREDICTION RESULT',
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColor.fromInt(0xAAFFFFFF),
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Text(
                  formatCondition(report.predictedClass),
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: _white,
                  ),
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  'Confidence: ${report.confidence.toStringAsFixed(1)}%',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromInt(0xCCFFFFFF),
                  ),
                ),

                pw.SizedBox(height: 6),

                pw.LinearProgressIndicator(
                  value: report.confidence / 100,
                  backgroundColor: PdfColor.fromInt(0x33FFFFFF),
                  valueColor: confColor,
                  minHeight: 6,
                ),
              ],
            ),
          ),
        ),

        pw.SizedBox(width: 14),

        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(color: confColor, width: 1.5),
            ),
            child: pw.Column(
              children: [
                pw.Text(
                  'AI CONFIDENCE',
                  style: pw.TextStyle(fontSize: 8, color: _textSecondary),
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  '${report.confidence.toStringAsFixed(1)}%',
                  style: pw.TextStyle(
                    fontSize: 34,
                    fontWeight: pw.FontWeight.bold,
                    color: confColor,
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: confColor,
                    borderRadius: pw.BorderRadius.circular(20),
                  ),
                  child: pw.Text(
                    confLabel,
                    style: pw.TextStyle(fontSize: 8, color: _white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PROBABILITY BARS
  // ==========================================================

  static pw.Widget _buildProbabilities(DetailedReport report) {
    final entries = report.probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Column(
      children: entries.map((entry) {
        final pct = entry.value;
        final value = pct / 100;
        final barColor = _classColor(entry.key);

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      formatCondition(entry.key),
                      style: pw.TextStyle(fontSize: 11),
                    ),
                  ),

                  pw.Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: barColor,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 5),

              pw.LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints?.maxWidth ?? 0;
                  final width = maxWidth * value.clamp(0.0, 1.0);

                  return pw.Stack(
                    children: [
                      pw.Container(
                        height: 6,
                        width: maxWidth,
                        color: _surface,
                      ),

                      pw.Container(height: 6, width: width, color: barColor),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==========================================================
  // SYMPTOMS
  // ==========================================================

  static pw.Widget _buildSymptomChips(DetailedReport report) {
    final symptoms =
        symptomMap[report.predictedClass.toLowerCase()] ??
        ['Persistent cough', 'Wheezing', 'Chest tightness'];

    return pw.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: symptoms.map((s) {
        return pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: pw.BoxDecoration(
            color: _surface,
            borderRadius: pw.BorderRadius.circular(20),
          ),
          child: pw.Text(s, style: pw.TextStyle(fontSize: 10, color: _teal)),
        );
      }).toList(),
    );
  }

  // ==========================================================
  // DISCLAIMER
  // ==========================================================

  static pw.Widget _buildDisclaimer() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFFFF8EE),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        'This report is generated by an AI screening system and is not a medical diagnosis. '
        'Consult a healthcare professional for proper medical evaluation.',
        style: pw.TextStyle(fontSize: 9, color: _textSecondary),
      ),
    );
  }

  // ==========================================================
  // FOOTER
  // ==========================================================

  static pw.Widget _buildFooter(String generatedAt) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generated by SpectroCough AI | $generatedAt',
          style: pw.TextStyle(fontSize: 8, color: _textSecondary),
        ),

        pw.Text(
          'Confidential | Personal reference',
          style: pw.TextStyle(fontSize: 8, color: _textSecondary),
        ),
      ],
    );
  }

  // ==========================================================
  // Helper utilities
  // ==========================================================


  static String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  // Section title widget

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Row(
      children: [
        pw.Container(width: 3, height: 16, color: _cyan),

        pw.SizedBox(width: 8),

        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: _textPrimary,
          ),
        ),
      ],
    );
  }
}
