import 'dart:math' as math;
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

  // ============================================================
  // Controllers
  // ============================================================

  late final AnimationController controller;
  late final AnimationController breathingController;
  late final AnimationController particleController;
  late final AnimationController backgroundController;

  // ============================================================
  // Animations
  // ============================================================

  late final Animation<double> glowFade;
  late final Animation<double> nameFade;
  late final Animation<double> taglineFade;
  late final Animation<double> breathing;
  late final Animation<double> backgroundFade;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Glow powers up
    glowFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // Text fade
    nameFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.4, 0.8),
      ),
    );

    taglineFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1.0),
      ),
    );

    // Subtle breathing (starts later)
    breathing = Tween(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: breathingController, curve: Curves.easeInOut),
    );

    // Background solid -> gradient
    backgroundFade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: backgroundController, curve: Curves.easeInOut),
    );

    start();
  }

  Future<void> start() async {
    particleController.repeat();

    // Delay breathing slightly
    await Future.delayed(const Duration(milliseconds: 200));
    breathingController.repeat(reverse: true);

    // Fade gradient in
    backgroundController.forward();

    // Power up glow + text
    await controller.forward();

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
        const HomeScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    breathingController.dispose();
    particleController.dispose();
    backgroundController.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ====================================================
          // Solid Base (Matches Native Splash)
          // ====================================================

          Container(color: AppColors.primaryDark),

          // ====================================================
          // Gradient Fade-In Layer
          // ====================================================

          FadeTransition(
            opacity: backgroundFade,
            child: Container(
              decoration:
              const BoxDecoration(gradient: AppColors.authGradient),
            ),
          ),

          // ====================================================
          // Particle Background
          // ====================================================

          AnimatedBuilder(
            animation: particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(particleController.value),
                size: MediaQuery
                    .of(context)
                    .size,
              );
            },
          ),

          // ====================================================
          // Main Content
          // ====================================================

          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge(
                [controller, breathingController],
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: breathing.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ============================
                      // Logo + Power-Up Glow
                      // ============================

                      Stack(
                        alignment: Alignment.center,
                        children: [

                          FadeTransition(
                            opacity: glowFade,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.18),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Logo always visible (matches native splash)
                          Image.asset(
                            "assets/logo/spectro_logo_1.png",
                            width: 150,
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ============================
                      // App Name
                      // ============================

                      FadeTransition(
                        opacity: nameFade,
                        child: Text(
                          "SpectroCough",
                          style: AppTextStyles.headingLarge.copyWith(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ============================
                      // Tagline
                      // ============================

                      FadeTransition(
                        opacity: taglineFade,
                        child: Text(
                          "AI-Powered Respiratory Analysis",
                          style: AppTextStyles.bodyText.copyWith(
                            color:
                            Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Particle Painter
// ============================================================

class ParticlePainter extends CustomPainter {
  final double t;

  ParticlePainter(this.t);

  static final math.Random rng = math.Random(42);

  static final List<Particle> particles = List.generate(
    24,
        (i) =>
        Particle(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          size: rng.nextDouble() * 3 + 1,
          speed: rng.nextDouble() * 0.003 + 0.0015,
          phase: rng.nextDouble() * math.pi * 2,
          drift: (rng.nextDouble() - 0.5) * 0.002,
        ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final py = (p.y - p.speed * t * 10) % 1.0;
      final px =
          p.x + math.sin(t * math.pi * 2 + p.phase) * p.drift * 10;

      final alpha =
          (math.sin(t * math.pi * 2 + p.phase) * 0.5 + 0.5) * 0.4;

      final paint = Paint()
        ..color = AppColors.accent.withValues(alpha: alpha)
        ..maskFilter =
        const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(px * size.width, py * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.t != t;
}

class Particle {
  final double x, y, size, speed, phase, drift;

  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.drift,
  });
}