import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  final String? mobileNumber;

  const RegistrationSuccessScreen({
    Key? key,
    this.mobileNumber,
  }) : super(key: key);

  @override
  State<RegistrationSuccessScreen> createState() => _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen>
    with TickerProviderStateMixin {
  // Main entrance and continuous celebration controllers
  late AnimationController _entranceController;
  late AnimationController _continuousConfettiController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _haloRotateController;

  late Animation<double> _cardScaleAnim;
  late Animation<double> _cardFadeAnim;
  late Animation<double> _checkScaleAnim;
  late Animation<double> _checkRotateAnim;
  late Animation<double> _rippleScaleAnim;
  late Animation<double> _rippleFadeAnim;

  // Particle list for full-screen and card celebration
  final List<_PhysicsParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // 1. Entrance Controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _cardScaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _cardFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _checkScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.85, curve: Curves.elasticOut),
      ),
    );

    _checkRotateAnim = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.75, curve: Curves.easeOutBack),
      ),
    );

    _rippleScaleAnim = Tween<double>(begin: 0.2, end: 2.2).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _rippleFadeAnim = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    // 2. Continuous confetti physics loop
    _continuousConfettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_updateParticles)
     ..repeat();

    // 3. Pulse / Shimmer / Halo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _haloRotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Spawn initial grand celebration particle burst
    _spawnInitialExplosion();

    _entranceController.forward();
  }

  void _spawnInitialExplosion() {
    final colors = [
      const Color(0xFFF59E0B), // Gold
      const Color(0xFFE11D48), // Rose
      const Color(0xFF881337), // Maroon
      const Color(0xFF10B981), // Emerald
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFF97316), // Orange
      const Color(0xFFEC4899), // Pink
      const Color(0xFF3B82F6), // Royal Blue
    ];

    // Card popper particles (left & right popper cannons)
    for (int i = 0; i < 90; i++) {
      final isLeft = i % 2 == 0;
      final startX = isLeft ? 0.22 : 0.78;
      final startY = 0.45;

      final angle = isLeft
          ? (-math.pi / 2) + (_random.nextDouble() * 0.8 - 0.2) // up and right
          : (-math.pi / 2) - (_random.nextDouble() * 0.8 - 0.2); // up and left
      final speed = 4.0 + _random.nextDouble() * 9.0;

      _particles.add(
        _PhysicsParticle(
          x: startX + (_random.nextDouble() * 0.04 - 0.02),
          y: startY,
          vx: math.cos(angle) * speed * 0.003,
          vy: math.sin(angle) * speed * 0.004,
          gravity: 0.00012 + _random.nextDouble() * 0.00008,
          color: colors[_random.nextInt(colors.length)],
          size: 4.0 + _random.nextDouble() * 6.0,
          rotation: _random.nextDouble() * math.pi * 2,
          vRot: (_random.nextDouble() - 0.5) * 0.15,
          flipSpeed: 0.05 + _random.nextDouble() * 0.1,
          shape: _ParticleShape.values[_random.nextInt(_ParticleShape.values.length)],
          lifetime: 1.0,
          fadeRate: 0.003 + _random.nextDouble() * 0.003,
        ),
      );
    }

    // Sky falling confetti across full screen
    for (int i = 0; i < 45; i++) {
      _particles.add(
        _PhysicsParticle(
          x: _random.nextDouble(),
          y: -0.1 - _random.nextDouble() * 0.3,
          vx: (_random.nextDouble() - 0.5) * 0.0015,
          vy: 0.0015 + _random.nextDouble() * 0.0025,
          gravity: 0.00005,
          color: colors[_random.nextInt(colors.length)],
          size: 4.0 + _random.nextDouble() * 5.0,
          rotation: _random.nextDouble() * math.pi * 2,
          vRot: (_random.nextDouble() - 0.5) * 0.1,
          flipSpeed: 0.05 + _random.nextDouble() * 0.08,
          shape: _ParticleShape.values[_random.nextInt(_ParticleShape.values.length)],
          lifetime: 1.0,
          fadeRate: 0.0015,
        ),
      );
    }
  }

  void _triggerTapConfetti(TapDownDetails details, Size screenSize) {
    final colors = [
      const Color(0xFFF59E0B),
      const Color(0xFFBE123C),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];
    final relX = details.globalPosition.dx / screenSize.width;
    final relY = details.globalPosition.dy / screenSize.height;

    for (int i = 0; i < 24; i++) {
      final angle = _random.nextDouble() * math.pi * 2;
      final speed = 3.0 + _random.nextDouble() * 8.0;

      _particles.add(
        _PhysicsParticle(
          x: relX,
          y: relY,
          vx: math.cos(angle) * speed * 0.003,
          vy: math.sin(angle) * speed * 0.003 - 0.003, // bias upward
          gravity: 0.00012,
          color: colors[_random.nextInt(colors.length)],
          size: 4.0 + _random.nextDouble() * 6.0,
          rotation: _random.nextDouble() * math.pi * 2,
          vRot: (_random.nextDouble() - 0.5) * 0.2,
          flipSpeed: 0.06 + _random.nextDouble() * 0.1,
          shape: _ParticleShape.values[_random.nextInt(_ParticleShape.values.length)],
          lifetime: 1.0,
          fadeRate: 0.005 + _random.nextDouble() * 0.005,
        ),
      );
    }
  }

  void _updateParticles() {
    if (!mounted) return;

    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.x += p.vx;
      p.y += p.vy;
      p.vy += p.gravity;
      p.vx += math.sin(p.y * 15) * 0.00008; // natural wind sway
      p.rotation += p.vRot;
      p.flip += p.flipSpeed;
      p.lifetime -= p.fadeRate;

      if (p.y > 1.2 || p.lifetime <= 0) {
        // Recycle top falling particles
        if (_particles.length <= 60 && _random.nextDouble() < 0.6) {
          p.y = -0.05;
          p.x = _random.nextDouble();
          p.vy = 0.0015 + _random.nextDouble() * 0.0025;
          p.vx = (_random.nextDouble() - 0.5) * 0.0015;
          p.lifetime = 1.0;
        } else {
          _particles.removeAt(i);
        }
      }
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _continuousConfettiController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _haloRotateController.dispose();
    super.dispose();
  }

  void _onContinue() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userPhone: widget.mobileNumber,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: GestureDetector(
          onTapDown: (details) => _triggerTapConfetti(details, screenSize),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // Main column
              Column(
                children: [
                  _buildTopAppBar(),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: AnimatedBuilder(
                          animation: Listenable.merge([
                            _entranceController,
                            _pulseController,
                            _shimmerController,
                            _haloRotateController,
                          ]),
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _cardFadeAnim,
                              child: Transform.scale(
                                scale: _cardScaleAnim.value,
                                child: _buildCelebrationCard(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Full Screen Interactive Confetti Particle Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _continuousConfettiController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _GrandConfettiPainter(particles: _particles),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top App Bar: Deep Maroon with TAMIL ALLIANCE + Gold Check
  // ─────────────────────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => const Icon(
                Icons.favorite,
                color: Color(0xFFE5A93C),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'TAMIL ALLIANCE',
            style: TextStyle(
              color: Color(0xFFF5D68B),
              fontFamily: 'serif',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.verified_rounded,
            color: Color(0xFFF5D68B),
            size: 15,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Central Animated Celebration Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildCelebrationCard() {
    final floatWave = math.sin(_pulseController.value * math.pi) * 3.0;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF701A33).withOpacity(0.08),
            blurRadius: 36,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background Card Festive Accents & Streamers
          Positioned.fill(
            child: CustomPaint(
              painter: _CardDecorationPainter(
                waveProgress: _pulseController.value,
                entranceProgress: _entranceController.value,
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),

                // Center Checkmark Circle with Radial Aura & Floating Effect
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial Shockwave Ripple 1
                      if (_rippleFadeAnim.value > 0.01)
                        Transform.scale(
                          scale: _rippleScaleAnim.value,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE5A93C).withOpacity(_rippleFadeAnim.value * 0.7),
                                width: 3,
                              ),
                            ),
                          ),
                        ),

                      // Radial Shockwave Ripple 2
                      if (_rippleFadeAnim.value > 0.01)
                        Transform.scale(
                          scale: _rippleScaleAnim.value * 1.3,
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF881337).withOpacity(_rippleFadeAnim.value * 0.4),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                      // Rotating Sparkling Rays Halo behind checkmark
                      Transform.rotate(
                        angle: _haloRotateController.value * math.pi * 2,
                        child: CustomPaint(
                          size: const Size(110, 110),
                          painter: _SparkleHaloPainter(color: const Color(0xFFFBBF24)),
                        ),
                      ),

                      // Bouncing Center Maroon Check Badge
                      Transform.translate(
                        offset: Offset(0, floatWave),
                        child: Transform.rotate(
                          angle: _checkRotateAnim.value,
                          child: Transform.scale(
                            scale: _checkScaleAnim.value,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF881337),
                                    Color(0xFF701A33),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF701A33).withOpacity(0.40),
                                    blurRadius: 22,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFE5A93C).withOpacity(0.30),
                                    blurRadius: 14,
                                    spreadRadius: -1,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // "Successfully Registered" Heading
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Flexible(
                      child: Text(
                        'Successfully Registered',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // "Continue" Button with Light Sweep Shimmer Effect
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Stack(
                    children: [
                      ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF701A33),
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFF701A33).withOpacity(0.45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),

                      // Shimmer light streak passing over button
                      Positioned.fill(
                        child: IgnorePointer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedBuilder(
                              animation: _shimmerController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    (MediaQuery.of(context).size.width * 0.8) *
                                            (_shimmerController.value * 2 - 0.5) -
                                        50,
                                    0,
                                  ),
                                  child: Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.0),
                                          Colors.white.withOpacity(0.35),
                                          Colors.white.withOpacity(0.0),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 3. Physics Confetti Particle Engine for Grand Celebration
// ─────────────────────────────────────────────────────────────
enum _ParticleShape { circle, rect, star, ribbon, diamond }

class _PhysicsParticle {
  double x; // 0.0 to 1.0 (relative to screen width)
  double y; // 0.0 to 1.0+ (relative to screen height)
  double vx;
  double vy;
  double gravity;
  Color color;
  double size;
  double rotation;
  double vRot;
  double flip = 0.0;
  double flipSpeed;
  _ParticleShape shape;
  double lifetime;
  double fadeRate;

  _PhysicsParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.color,
    required this.size,
    required this.rotation,
    required this.vRot,
    required this.flipSpeed,
    required this.shape,
    required this.lifetime,
    required this.fadeRate,
  });
}

class _GrandConfettiPainter extends CustomPainter {
  final List<_PhysicsParticle> particles;

  _GrandConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      if (p.lifetime <= 0) continue;

      final cx = p.x * w;
      final cy = p.y * h;
      final alpha = (p.lifetime.clamp(0.0, 1.0) * 255).toInt();
      paint.color = p.color.withAlpha(alpha);

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(p.rotation);

      // 3D flip effect via horizontal scale
      final scaleX = math.cos(p.flip);
      canvas.scale(scaleX.abs().clamp(0.15, 1.0), 1.0);

      switch (p.shape) {
        case _ParticleShape.circle:
          canvas.drawCircle(Offset.zero, p.size * 0.5, paint);
          break;

        case _ParticleShape.rect:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: p.size * 1.8, height: p.size * 0.8),
              const Radius.circular(1.5),
            ),
            paint,
          );
          break;

        case _ParticleShape.ribbon:
          final ribbonPath = Path();
          ribbonPath.moveTo(-p.size * 1.2, -p.size * 0.4);
          ribbonPath.quadraticBezierTo(0, p.size * 0.6, p.size * 1.2, -p.size * 0.4);
          ribbonPath.lineTo(p.size * 1.2, p.size * 0.2);
          ribbonPath.quadraticBezierTo(0, p.size * 1.2, -p.size * 1.2, p.size * 0.2);
          ribbonPath.close();
          canvas.drawPath(ribbonPath, paint);
          break;

        case _ParticleShape.diamond:
          final diamondPath = Path();
          diamondPath.moveTo(0, -p.size * 0.7);
          diamondPath.lineTo(p.size * 0.5, 0);
          diamondPath.lineTo(0, p.size * 0.7);
          diamondPath.lineTo(-p.size * 0.5, 0);
          diamondPath.close();
          canvas.drawPath(diamondPath, paint);
          break;

        case _ParticleShape.star:
          _drawSparkleStar(canvas, p.size * 0.8, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawSparkleStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    path.moveTo(0, -radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius);
    path.quadraticBezierTo(0, 0, -radius, 0);
    path.quadraticBezierTo(0, 0, 0, -radius);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _GrandConfettiPainter oldDelegate) => true;
}

// ─────────────────────────────────────────────────────────────
// 4. Card Streamers, Side Brackets & Party Poppers Painter
// ─────────────────────────────────────────────────────────────
class _CardDecorationPainter extends CustomPainter {
  final double waveProgress;
  final double entranceProgress;

  _CardDecorationPainter({
    required this.waveProgress,
    required this.entranceProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entranceProgress < 0.1) return;

    final w = size.width;
    final h = size.height;
    final wave = math.sin(waveProgress * math.pi * 2);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 1. Party Poppers on Left and Right (🎉)
    _drawPopper(canvas, Offset(24, 76 + wave * 2), -0.35, isLeft: true);
    _drawPopper(canvas, Offset(w - 24, 76 - wave * 2), 0.35, isLeft: false);

    // 2. Gold Streamer at top
    final goldPath = Path();
    goldPath.moveTo(w * 0.30 + wave * 4, 18);
    goldPath.cubicTo(
      w * 0.38 + wave * 5, 28,
      w * 0.32 - wave * 4, 42,
      w * 0.36, 52,
    );
    strokePaint
      ..color = const Color(0xFFEAB308).withOpacity(0.9 * entranceProgress)
      ..strokeWidth = 3.5;
    canvas.drawPath(goldPath, strokePaint);

    // Maroon Streamer at top
    final maroonPath = Path();
    maroonPath.moveTo(w * 0.68 - wave * 4, 20);
    maroonPath.cubicTo(
      w * 0.62 - wave * 5, 30,
      w * 0.70 + wave * 4, 44,
      w * 0.64, 54,
    );
    strokePaint
      ..color = const Color(0xFF881337).withOpacity(0.9 * entranceProgress)
      ..strokeWidth = 3.5;
    canvas.drawPath(maroonPath, strokePaint);

    // 3. Side Brackets / Curves around the title area
    // Left Emerald Arc
    final leftArcPath = Path();
    leftArcPath.moveTo(18, h * 0.52 - wave * 2);
    leftArcPath.cubicTo(
      10, h * 0.58,
      10, h * 0.64,
      18, h * 0.68 + wave * 2,
    );
    strokePaint
      ..color = const Color(0xFF10B981).withOpacity(0.95 * entranceProgress)
      ..strokeWidth = 3.2;
    canvas.drawPath(leftArcPath, strokePaint);

    // Right Pink Arc
    final rightArcPath = Path();
    rightArcPath.moveTo(w - 18, h * 0.52 + wave * 2);
    rightArcPath.cubicTo(
      w - 10, h * 0.58,
      w - 10, h * 0.64,
      w - 18, h * 0.68 - wave * 2,
    );
    strokePaint
      ..color = const Color(0xFFF43F5E).withOpacity(0.95 * entranceProgress)
      ..strokeWidth = 3.2;
    canvas.drawPath(rightArcPath, strokePaint);
  }

  void _drawPopper(Canvas canvas, Offset pos, double angle, {required bool isLeft}) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);

    final conePaint = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFFE2E8F0);

    // Party Cone body
    final conePath = Path();
    conePath.moveTo(0, 9);
    conePath.lineTo(-8, -9);
    conePath.lineTo(8, -9);
    conePath.close();

    conePaint.color = const Color(0xFFFBBF24);
    canvas.drawPath(conePath, conePaint);
    canvas.drawPath(conePath, stroke);

    // Stripes
    final stripePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = const Color(0xFF881337);
    canvas.drawLine(const Offset(-5, -3), const Offset(5, -3), stripePaint);
    canvas.drawLine(const Offset(-2.5, 3), const Offset(2.5, 3), stripePaint);

    // Streamers bursting out from cone mouth
    final burstPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.8;

    burstPaint.color = const Color(0xFF3B82F6);
    canvas.drawLine(const Offset(-4, -9), const Offset(-9, -16), burstPaint);

    burstPaint.color = const Color(0xFFEC4899);
    canvas.drawLine(const Offset(0, -9), const Offset(0, -18), burstPaint);

    burstPaint.color = const Color(0xFF10B981);
    canvas.drawLine(const Offset(4, -9), const Offset(9, -16), burstPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CardDecorationPainter oldDelegate) {
    return oldDelegate.waveProgress != waveProgress || oldDelegate.entranceProgress != entranceProgress;
  }
}

// ─────────────────────────────────────────────────────────────
// 5. Rotating Sparkle Halo Painter behind Checkmark
// ─────────────────────────────────────────────────────────────
class _SparkleHaloPainter extends CustomPainter {
  final Color color;

  _SparkleHaloPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withOpacity(0.35)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const numRays = 12;
    for (int i = 0; i < numRays; i++) {
      final angle = (i * math.pi * 2) / numRays;
      final innerR = (i % 2 == 0) ? 44.0 : 48.0;
      final outerR = (i % 2 == 0) ? 54.0 : 51.0;

      final p1 = Offset(center.dx + math.cos(angle) * innerR, center.dy + math.sin(angle) * innerR);
      final p2 = Offset(center.dx + math.cos(angle) * outerR, center.dy + math.sin(angle) * outerR);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparkleHaloPainter oldDelegate) => false;
}
