import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _fade(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slide(double start, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Widget _animated({
    required Widget child,
    required double start,
    required double end,
  }) {
    return FadeTransition(
      opacity: _fade(start, end),
      child: SlideTransition(position: _slide(start, end), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('About Us'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animated(start: 0.0, end: 0.25, child: const _HeroBanner()),

              const SizedBox(height: 28),

              _animated(start: 0.15, end: 0.45, child: const _AboutCard()),

              const SizedBox(height: 16),

              _animated(start: 0.3, end: 0.6, child: const _TeamCard()),

              const SizedBox(height: 16),

              _animated(start: 0.45, end: 0.75, child: const _EthicsCard()),

              const SizedBox(height: 16),

              _animated(start: 0.6, end: 1.0, child: const _ContactCard()),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HERO BANNER
// ============================================================

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 40 : 24,
        vertical: isWide ? 40 : 32,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.authGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              color: AppColors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'SpectroCough',
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.white,
              fontSize: isWide ? 32 : 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'AI-Powered Respiratory Analysis',
            style: AppTextStyles.smallText.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Academic AI Prototype',
              style: TextStyle(color: AppColors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INFO CARDS
// ============================================================

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.info_outline_rounded,
      title: 'About the System',
      color: AppColors.primary,
      child: Text(
        'SpectroCough is an AI-driven respiratory sound analysis system developed as an academic research initiative. '
        'It demonstrates how machine learning techniques can assist in early-stage screening of respiratory conditions '
        'through acoustic pattern recognition.',
        style: AppTextStyles.bodyText,
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.group_outlined,
      title: 'Development Team',
      color: AppColors.accent,
      child: Column(
        children: const [
          _TeamMemberTile(
            name: 'Harshal Jadhav',
            role: 'Machine Learning Research & Project Coordination',
          ),
          _TeamMemberTile(
            name: 'Aryan Gaikwad',
            role: 'Machine Learning Model Development & Evaluation',
          ),
          _TeamMemberTile(
            name: 'Mayank Lahare',
            role: 'Full Stack Application Development & Backend Integration',
          ),
          _TeamMemberTile(
            name: 'Abhishek Parmar',
            role: 'Web Platform Development',
          ),
        ],
      ),
    );
  }
}

class _EthicsCard extends StatelessWidget {
  const _EthicsCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.shield_outlined,
      title: 'Purpose & Ethical Use',
      color: AppColors.warning,
      child: Text(
        'This system is designed strictly for research and educational demonstration purposes. '
        'It does not provide medical diagnoses. All predictions are probabilistic outputs generated '
        'by trained models and should not replace professional medical consultation.',
        style: AppTextStyles.bodyText,
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.mail_outline_rounded,
      title: 'Contact & Attribution',
      color: AppColors.success,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'For academic collaboration, technical discussions, or project inquiries:',
            style: AppTextStyles.bodyText,
          ),

          SizedBox(height: 12),

          _ContactItem(
            icon: Icons.email_outlined,
            text: 'codingsnepais@gmail.com',
          ),

          SizedBox(height: 8),

          _ContactItem(
            icon: Icons.code,
            text: 'GitHub: https://github.com/CodingSenpais',
          ),

          SizedBox(height: 8),

          _ContactItem(
            icon: Icons.language,
            text: 'Web Platform: under development',
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.success),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTextStyles.smallText)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.headingMedium),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: color.withValues(alpha: 0.2), thickness: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  final String name;
  final String role;

  const _TeamMemberTile({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accent.withValues(alpha: 0.2),
            child: Text(
              name[0],
              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.headingSmall),
                Text(role, style: AppTextStyles.smallText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
