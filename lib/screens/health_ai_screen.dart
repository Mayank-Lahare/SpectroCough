import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';

class HealthAiScreen extends StatelessWidget {
  const HealthAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Health & AI')),
      body: const Center(child: Text('Health & AI Screen')),
    );
  }
}
