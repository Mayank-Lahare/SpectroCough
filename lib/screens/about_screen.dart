import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('About Us')),
      body: const Center(child: Text('About Us Screen')),
    );
  }
}
