import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Result')),
      body: const Center(child: Text('Result Screen')),
    );
  }
}
