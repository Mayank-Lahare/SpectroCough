import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Reports Screen')),
    );
  }
}
