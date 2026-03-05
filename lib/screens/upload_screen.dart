// ============================================================
// Upload Screen — Clinical Refined UI (Final Stable Version)
// ============================================================

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/loading_overlay.dart';
import '../services/api_service.dart';
import '../models/prediction_result.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  final String initialAudioType;

  const UploadScreen({super.key, required this.initialAudioType});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with SingleTickerProviderStateMixin {
  PlatformFile? _selectedFile;
  bool _isProcessing = false;
  late String _audioType;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _audioType = widget.initialAudioType;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
    }
  }

  Future<void> _analyze() async {
    if (_selectedFile == null) return;

    setState(() => _isProcessing = true);

    try {
      final response = await ApiService.analyzeAudio(
        _selectedFile!.bytes!,
        _selectedFile!.name,
        audioType: _audioType,
      );

      if (!mounted) return;

      final prediction = PredictionResult.fromJson(response);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(result: prediction)),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Analysis failed. Please try again.")),
        );
      }
    }

    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Respiratory Analysis", style: AppTextStyles.headingSmall),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isProcessing,
        message: "Analyzing audio...",
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderCard(),
              const SizedBox(height: 28),

              const _SectionLabel(label: "Audio Type"),
              const SizedBox(height: 12),

              _AudioTypeSelector(
                selected: _audioType,
                onChanged: (type) {
                  setState(() => _audioType = type);
                },
              ),

              const SizedBox(height: 32),

              Center(child: const _SectionLabel(label: "WAV File")),
              const SizedBox(height: 12),

              Center(
                child: _FileUploadCard(
                  selectedFile: _selectedFile,
                  pulseAnimation: _pulseAnimation,
                  onTap: _pickFile,
                ),
              ),

              if (_selectedFile != null) ...[
                const SizedBox(height: 14),
                _FileInfoRow(file: _selectedFile!),
              ],

              const SizedBox(height: 40),

              _AnalyzeButton(
                enabled: _selectedFile != null,
                onPressed: _analyze,
              ),

              const SizedBox(height: 18),

              Center(
                child: Text(
                  "Results are for informational purposes only.",
                  style: AppTextStyles.smallText.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
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
// Header Card
// ============================================================

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.graphic_eq, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload & Analyze",
                  style: AppTextStyles.headingSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Upload a WAV file to detect respiratory conditions.",
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Section Label
// ============================================================

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.smallText.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    );
  }
}

// ============================================================
// Audio Type Selector
// ============================================================

class _AudioTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _AudioTypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeOption(
          label: "Normal",
          icon: Icons.mic_none_rounded,
          selected: selected == "normal",
          onTap: () => onChanged("normal"),
        ),
        _TypeOption(
          label: "Stethoscopic",
          icon: Icons.monitor_heart_outlined,
          selected: selected == "stethoscopic",
          onTap: () => onChanged("stethoscopic"),
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.smallText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.textPrimary,
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
// File Upload Card
// ============================================================

class _FileUploadCard extends StatelessWidget {
  final PlatformFile? selectedFile;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const _FileUploadCard({
    required this.selectedFile,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedFile != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (_, child) {
          return Transform.scale(
            scale: hasFile ? 1.0 : pulseAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            color: hasFile
                ? AppColors.primary.withValues(alpha: 0.05)
                : AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hasFile ? AppColors.primary : AppColors.surface,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                hasFile
                    ? Icons.check_circle_rounded
                    : Icons.cloud_upload_outlined,
                size: 44,
                color: hasFile ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                hasFile ? "File selected" : "Tap to browse files",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  fontWeight: FontWeight.w600,
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
// File Info Row
// ============================================================

class _FileInfoRow extends StatelessWidget {
  final PlatformFile file;

  const _FileInfoRow({required this.file});

  @override
  Widget build(BuildContext context) {
    final fileName = file.name;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.audio_file_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              fileName,
              style: AppTextStyles.smallText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.check, color: AppColors.success),
        ],
      ),
    );
  }
}

// ============================================================
// Analyze Button
// ============================================================

class _AnalyzeButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _AnalyzeButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          elevation: enabled ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text("Analyze Audio", style: AppTextStyles.buttonText),
      ),
    );
  }
}
