import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const initialAnimationDuration = Duration(milliseconds: 1800);
  static const breathingDuration = Duration(milliseconds: 2400);

  late final AnimationController controller;
  late final AnimationController breathingController;

  late final Animation<double> logoFade;
  late final Animation<double> nameFade;
  late final Animation<double> taglineFade;
  late final Animation<double> scale;
  late final Animation<double> breathing;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: initialAnimationDuration,
    );

    breathingController = AnimationController(
      vsync: this,
      duration: breathingDuration,
    );

    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    logoFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: curved, curve: const Interval(0.0, 0.4)));

    nameFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: curved, curve: const Interval(0.3, 0.7)));

    taglineFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: curved, curve: const Interval(0.6, 1.0)));

    scale = Tween<double>(begin: 0.96, end: 1.0).animate(curved);

    breathing = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: breathingController, curve: Curves.easeInOut),
    );

    start();
  }

  Future<void> start() async {
    await controller.forward();

    // Begin subtle breathing loop
    breathingController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authGradient),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft radial glow background
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.6,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            AnimatedBuilder(
              animation: Listenable.merge([controller, breathingController]),
              builder: (context, child) {
                return Transform.scale(
                  scale: scale.value * breathing.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: logoFade,
                        child: Image.asset(
                          "assets/icon/spectro_icon_2.png",
                          width: 170,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: nameFade,
                        child: Text(
                          "SpectroCough",
                          style: AppTextStyles.headingLarge.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: taglineFade,
                        child: Text(
                          "AI-Powered Respiratory Analysis",
                          style: AppTextStyles.bodyText.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
