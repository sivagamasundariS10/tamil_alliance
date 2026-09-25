import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../auth/mobile_auth_screen.dart';
import '../auth/otp_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),

              // 1. Top Pill Badge: VEDIC & MODERN MATCHMAKING
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFF701A33),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          size: 8,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'VEDIC & MODERN MATCHMAKING',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF701A33),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Brand Header: Icon + Tamil Alliance
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF701A33),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.favorite,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tamil Alliance',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF701A33),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Subtitle
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Connecting sacred lineage, cultural heritage, and modern aspirations globally.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6B7280),
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3. Hero Auspicious Union Banner Card
              Container(
                height: 185,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Background Wedding Image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/wedding_hero.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFF701A33),
                            child: const Center(
                              child: Icon(Icons.favorite, size: 60, color: Colors.white24),
                            ),
                          ),
                        ),
                      ),
                      // Gradient Overlay for readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xFF65001E).withValues(alpha: 0.75),
                                const Color(0xFF4A0015).withValues(alpha: 0.95),
                              ],
                              stops: const [0.2, 0.65, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Text content inside hero card
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Welcome to the ',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Colors.white70,
                                  ),
                                ),
                                const Text(
                                  'Auspicious Union',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.goldLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Row(
                              children: [
                                Icon(Icons.auto_awesome, size: 10, color: AppColors.gold),
                                SizedBox(width: 4),
                                Text(
                                  'MANGALYA DHARANAM',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.1,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Find Your Auspicious Union',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rooted in authentic tradition, built for forward-thinking families.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 4. Section Title: The Alliance Guarantee
              const Row(
                children: [
                  Icon(
                    Icons.verified,
                    color: Color(0xFF78350F), // Rosette verified badge
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'The Alliance Guarantee',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 5. Guarantee Card 1: 100% Lineage Verified
              _buildCustomGuaranteeCard(
                iconWidget: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.shield,
                      color: Color(0xFF701A33),
                      size: 28,
                    ),
                    Positioned(
                      top: 7,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
                iconBgColor: const Color(0xFFE5EDFF),
                title: '100% Lineage Verified',
                badgeText: 'Strict',
                badgeBg: const Color(0xFFF3E8FF),
                badgeTextColor: const Color(0xFF701A33),
                description:
                    'Zero fake profiles, authenticated by government ID & verified family background.',
              ),

              const SizedBox(height: 12),

              // Guarantee Card 2: Accurate 10-Porutham
              _buildCustomGuaranteeCard(
                iconWidget: const AstrologicalSunIcon(
                  color: Color(0xFF7C2D12),
                  size: 26,
                ),
                iconBgColor: const Color(0xFFFFEDD5),
                title: 'Accurate 10-Porutham',
                badgeText: 'Vedic Match',
                badgeBg: const Color(0xFFFFEDD5),
                badgeTextColor: const Color(0xFF9A3412),
                description:
                    'Deep astrological matching verified by learned Vedic astrologers with precision dosha analysis.',
              ),

              const SizedBox(height: 12),

              // Guarantee Card 3: Privacy & Encrypted
              _buildCustomGuaranteeCard(
                iconWidget: const Icon(
                  Icons.family_restroom,
                  color: Color(0xFF1D4ED8),
                  size: 28,
                ),
                iconBgColor: const Color(0xFFDBEAFE),
                title: 'Privacy & Encrypted',
                badgeText: 'Private',
                badgeBg: const Color(0xFFE0F2FE),
                badgeTextColor: const Color(0xFF0369A1),
                description:
                    'Contact numbers and full photo albums are unveiled only upon mutual parental consent.',
              ),

              const SizedBox(height: 14),

              // 6. Community Trust Card: 2,50,000+ Tamil Families
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.groups,
                          size: 18,
                          color: Color(0xFF701A33),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '2,50,000+ Tamil Families',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF701A33),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Worldwide',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Trusted across Chennai, Coimbatore, Madurai, Bengaluru, Singapore, Malaysia, the UK & North America.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4B5563),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Castes & Community Tags
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildCommunityChip('Iyer & Iyengar'),
                        _buildCommunityChip('Kongu Vellalar'),
                        _buildCommunityChip('Chettiar'),
                        _buildCommunityChip('Mudaliar & Pillai'),
                        _buildCommunityChip('+ 40 More'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 7. Tamil Sacred Quote & Divider
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFE5D5D8),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Text(
                          '"கற்பெனப்படுவது சொற்றிறம்பாமை"',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF701A33),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Auspicious New Beginnings',
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFE5D5D8),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 8. Primary CTA Button: Get Started / ஆரம்பிக்கவும் ->
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MobileAuthScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF65001E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started / ஆரம்பிக்கவும்',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 9. Login Text Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OtpLoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF65001E),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 10. Terms / Disclaimer Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'By continuing, you agree to our Sacred Trust Guidelines & family privacy pledge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomGuaranteeCard({
    required Widget iconWidget,
    required Color iconBgColor,
    required String title,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

class AstrologicalSunIcon extends StatelessWidget {
  final Color color;
  final double size;

  const AstrologicalSunIcon({
    super.key,
    this.color = const Color(0xFF7C2D12),
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SunPainter(color: color),
    );
  }
}

class _SunPainter extends CustomPainter {
  final Color color;
  _SunPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rayPaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final centerRadius = size.width * 0.15;

    // Center filled circle
    canvas.drawCircle(center, centerRadius, dotPaint);

    // 8 astrological rays
    final innerR = centerRadius + 2.5;
    final outerR = size.width * 0.44;

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      final dx = math.cos(angle);
      final dy = math.sin(angle);
      canvas.drawLine(
        Offset(center.dx + dx * innerR, center.dy + dy * innerR),
        Offset(center.dx + dx * outerR, center.dy + dy * outerR),
        rayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
