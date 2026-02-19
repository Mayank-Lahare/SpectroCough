import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/loading_overlay.dart';
import 'result_screen.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecording = true;
  bool isProcessing = false;

  // Called when user taps Stop
  void _stopAndProcess() {
    setState(() {
      isRecording = false;
      isProcessing = true;
    });

    // TODO: Replace this delay with real backend call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Recording')),

      body: LoadingOverlay(
        isLoading: isProcessing,
        message: 'Analyzing respiratory sound…',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // =========================
                // STATUS TEXT
                // =========================
                Text(
                  isRecording ? 'Listening…' : 'Processing…',
                  style: AppTextStyles.headingMedium,
                ),

                const SizedBox(height: 40),

                // =========================
                // WAVEFORM PLACEHOLDER
                // =========================
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.graphic_eq,
                    size: 48,
                    color: AppColors.buttonBlue,
                  ),
                ),

                const SizedBox(height: 48),

                // =========================
                // STOP RECORDING BUTTON
                // =========================
                GestureDetector(
                  onTap: isRecording ? _stopAndProcess : null,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.buttonBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.hourglass_top,
                      color: AppColors.white,
                      size: 36,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  isRecording
                      ? 'Tap to stop recording'
                      : 'Analyzing audio…',
                  style: AppTextStyles.smallText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
