// ============================================================
// Recording Screen
// ------------------------------------------------------------
// Responsibilities:
// - Handle microphone permission
// - Record cough audio (WAV, 16kHz)
// - Save recording in app directory
// - Send audio file to backend
// - Navigate to ResultScreen with backend response
// ============================================================

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


// UI & App Modules
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/loading_overlay.dart';
import 'result_screen.dart';
import '../services/api_service.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  // ============================================================
  // Recording Engine
  // ============================================================
  final AudioRecorder _recorder = AudioRecorder();

  // ============================================================
  // UI State
  // ============================================================
  bool isRecording = false;
  bool isProcessing = false;

  // Stores saved recording file path
  String? _filePath;

  // ============================================================
  // Lifecycle
  // ============================================================
  @override
  void initState() {
    super.initState();
    _startRecording(); // Automatically begin recording
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  // ============================================================
  // Start Recording
  // - Requests microphone permission
  // - Saves file inside app directory (safe storage)
  // ============================================================
  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();

    if (!status.isGranted) {
      debugPrint("Microphone permission denied");
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/cough_recording.wav';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000, // ML-friendly sampling rate
        bitRate: 128000,
      ),
      path: path,
    );

    _filePath = path;

    setState(() {
      isRecording = true;
    });
  }

  // ============================================================
  // Stop Recording & Send To Backend
  // - Stops recorder
  // - Calls ApiService
  // - Navigates to ResultScreen
  // ============================================================
  Future<void> _stopAndProcess() async {
    setState(() {
      isRecording = false;
      isProcessing = true;
    });

    await _recorder.stop();

    if (_filePath == null) {
      debugPrint("No recording file found");
      setState(() {
        isProcessing = false;
      });
      return;
    }

    try {
      final file = File(_filePath!);

      // 🔗 Backend Call
      final result = await ApiService.analyzeAudio(file);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(resultData: result)),
      );
    } catch (e) {
      debugPrint("Error calling backend: $e");

      setState(() {
        isProcessing = false;
      });
    }
  }

  // ============================================================
  // UI
  // ============================================================
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
                // Status Text
                Text(
                  isRecording ? 'Listening…' : 'Processing…',
                  style: AppTextStyles.headingMedium,
                ),

                const SizedBox(height: 40),

                // Waveform Placeholder
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

                // Stop Button
                GestureDetector(
                  onTap: isRecording ? _stopAndProcess : null,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
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
                  isRecording ? 'Tap to stop recording' : 'Analyzing audio…',
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
