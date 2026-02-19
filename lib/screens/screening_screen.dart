import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';

class ScreeningScreen extends StatelessWidget {
  const ScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Screening')),
      body: const Center(child: Text('Screening Screen')),
    );
  }
}
