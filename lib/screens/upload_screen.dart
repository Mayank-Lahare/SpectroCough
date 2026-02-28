// ============================================================
// Upload Screen
// ------------------------------------------------------------
// Responsibilities:
// - Select WAV audio file
// - Choose audio type (Normal / Stethoscopic)
// - Send file + type to backend
// - Navigate to ResultScreen
// ============================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/loading_overlay.dart';
import '../services/api_service.dart';
import '../models/prediction_result.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  bool _isProcessing = false;

  String _audioType = "normal";

  // ============================================================
  // Pick WAV File
  // ============================================================

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // ============================================================
  // Analyze Audio
  // ============================================================

  Future<void> _analyze() async {
    if (_selectedFile == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final response = await ApiService.analyzeAudio(
        _selectedFile!,
        audioType: _audioType,
      );

      if (!mounted) return;

      // ============================================================
      // Convert backend JSON → PredictionResult model
      // ============================================================

      final prediction = PredictionResult.fromJson(response);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: prediction), // ✅ Fixed
        ),
      );
    } catch (e) {
      debugPrint("Upload error: $e");
    }

    setState(() {
      _isProcessing = false;
    });
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text("Upload Respiratory Audio")),

      body: LoadingOverlay(
        isLoading: _isProcessing,
        message: "Analyzing audio…",

        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Text("Select Audio Type", style: AppTextStyles.headingMedium),

              const SizedBox(height: 16),

              // ============================================================
              // Audio Type Segmented Buttons
              // ============================================================
              Row(
                children: [
                  _TypeButton(
                    label: "Normal",
                    selected: _audioType == "normal",
                    onTap: () => setState(() => _audioType = "normal"),
                  ),
                  const SizedBox(width: 12),
                  _TypeButton(
                    label: "Stethoscopic",
                    selected: _audioType == "stethoscopic",
                    onTap: () => setState(() => _audioType = "stethoscopic"),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text("Upload WAV File", style: AppTextStyles.headingMedium),

              const SizedBox(height: 16),

              // ============================================================
              // File Selection Card
              // ============================================================
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.buttonBlue.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.upload_file,
                        color: AppColors.buttonBlue,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _selectedFile == null
                              ? "Tap to select WAV file"
                              : _selectedFile!.path.split('/').last,
                          style: AppTextStyles.bodyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ============================================================
              // Primary Analyze Button
              // ============================================================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _selectedFile != null ? _analyze : null,
                  child: const Text(
                    "Analyze Respiratory Audio",
                    style: TextStyle(fontWeight: FontWeight.w600),
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
// Audio Type Button Widget
// ============================================================

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.buttonBlue : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.buttonBlue),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.buttonBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
