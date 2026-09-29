import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../registration/photos_privacy_screen.dart';
import '../alliance/alliance_screen.dart';
import '../premium/premium_screen.dart';
import '../interests/interests_screen.dart';
import '../chat/chat_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/my_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  final String? userPhone;
  final int initialTabIndex;

  const HomeScreen({
    super.key,
    this.userName,
    this.userPhone,
    this.initialTabIndex = 0,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _bottomNavIndex;
  final Set<String> _connectedProfileIds = {};

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = widget.initialTabIndex;
  }

  void _handleConnect(String idOrName, String name) {
    if (_connectedProfileIds.contains(idOrName)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interest has already been sent to $name.'),
          backgroundColor: const Color(0xFF334155),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _connectedProfileIds.add(idOrName);
    });

    print('====================================================');
    print('💌 [USER ACTION: CONNECT / SEND INTEREST]');
    print('   Target Profile : $name');
    print('   Target ID/Key  : $idOrName');
    print('   Status         : Interest Sent Successfully ✓');
    print('====================================================');

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: Color(0xFFEC4899), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Interest sent to $name! You will be notified when accepted.',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFF59E0B),
          onPressed: () {
            setState(() {
              _connectedProfileIds.remove(idOrName);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      appBar: _buildCustomAppBar(),
      body: _bottomNavIndex == 1
          ? AllianceScreen(onNavigateToHome: () => setState(() => _bottomNavIndex = 0))
          : _bottomNavIndex == 2
              ? PremiumScreen(onNavigateToHome: () => setState(() => _bottomNavIndex = 0))
              : _bottomNavIndex == 3
                  ? InterestsScreen(onNavigateToHome: () => setState(() => _bottomNavIndex = 0))
                  : _bottomNavIndex == 4
                      ? ChatScreen(onNavigateToHome: () => setState(() => _bottomNavIndex = 0))
                      : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // 1. Profile Hero Card (Dr. Siddharth Sundaresan)
                      _buildProfileHeroCard(),
                      const SizedBox(height: 14),

                      // 2. Complete Your Profile Progress Card
                      _buildCompleteProfileCard(),
                      const SizedBox(height: 18),

                      // 3. Profile Activity & Insights
                      _buildProfileActivityInsights(),
                      const SizedBox(height: 20),

                      // 4. Daily Recommendations Section
                      _buildDailyRecommendationsSection(),
                      const SizedBox(height: 20),

                      // 5. Recent Matches Handpicked For You Section
                      _buildRecentMatchesSection(),
                      const SizedBox(height: 20),

                      // 6. Newly Joined Section
                      _buildNewlyJoinedSection(),
                      const SizedBox(height: 20),

                      // 7. Help / Contact Support Banner
                      _buildSupportBanner(),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Custom App Bar
  // ─────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: Container(
        color: AppColors.primaryMaroon,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo + Title + Home Subtitle
                Image.asset(
                  'assets/images/logo.png',
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => const Icon(
                    Icons.favorite,
                    color: Color(0xFFF3D27C),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'TAMIL ALLIANCE',
                          style: TextStyle(
                            color: Color(0xFFF5D68B),
                            fontFamily: 'serif',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.verified_rounded,
                          color: Color(0xFFF5D68B),
                          size: 13,
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _bottomNavIndex == 1
                          ? 'Alliance'
                          : (_bottomNavIndex == 2
                              ? 'Premium'
                              : (_bottomNavIndex == 3
                                  ? 'Interests'
                                  : (_bottomNavIndex == 4 ? 'chat' : 'Home'))),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                if (_bottomNavIndex == 1) ...[
                  // Notification Bell with Badge (Image 2 design)
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.notifications_active_rounded, color: Color(0xFFF59E0B), size: 20),
                              SizedBox(width: 10),
                              Text('No new notifications for Alliance match', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          backgroundColor: const Color(0xFF1E293B),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 8.5,
                              height: 8.5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBBF24),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF701A33),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (_bottomNavIndex == 2) ...[
                  const SizedBox.shrink(),
                ] else if (_bottomNavIndex == 4) ...[
                  // Chat Screen: Settings icon is in the page body, keep only Alert in top bar
                  _buildAppBarAction(
                    icon: Icons.notifications_none_rounded,
                    label: 'Alert',
                    hasBadge: true,
                    badgeCount: '1',
                    onTap: () {},
                  ),
                ] else ...[
                  // Settings Action
                  _buildAppBarAction(
                    icon: Icons.tune_rounded,
                    label: 'Settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),

                  // Alert / Notification Action with Badge
                  _buildAppBarAction(
                    icon: Icons.notifications_none_rounded,
                    label: 'Alert',
                    hasBadge: true,
                    badgeCount: '1',
                    onTap: () {},
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required String label,
    bool hasBadge = false,
    String badgeCount = '',
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ),
              if (hasBadge)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      badgeCount,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Profile Hero Card (Dr. Siddharth Sundaresan)
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileHeroCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF701A33), Color(0xFF4C0B1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF701A33).withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Watermark concentric circles pattern on background
          Positioned(
            right: -20,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(12), width: 1.5),
              ),
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(12), width: 1.5),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Avatar with green verified check
                    Stack(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF3D27C), width: 2),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/groom_avatar.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(1),
                            child: const Icon(
                              Icons.check_circle,
                              color: Color(0xFF10B981),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.userName ?? 'Dr. Siddharth Sundaresan',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyProfileScreen(
                                        userName: widget.userName ?? 'Karthik Sundaram',
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(14),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xFFF3D27C),
                                    size: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Alliance ID • TA889123 • 31 Yrs • 5\'11" • Chennai',
                            style: TextStyle(
                              color: Color(0xFFFCE7F3),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Gold Badge + Completion Badge
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5B041),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    _CrownIcon(size: 11.5, color: Color(0xFF4A2500)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Kalyanam Gold',
                                      style: TextStyle(
                                        color: Color(0xFF4A2500),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5A0D23),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFF9E1B42)),
                                ),
                                child: const Text(
                                  'Profile: 95% Complete',
                                  style: TextStyle(
                                    color: Color(0xFFFEF3C7),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats Row (Interests Received, Sent, Accepted)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('12', 'Interests Received'),
                      Container(width: 1, height: 26, color: Colors.white24),
                      _buildStatColumn('28', 'Interests Sent'),
                      Container(width: 1, height: 26, color: Colors.white24),
                      _buildStatColumn('12', 'Accepted', isHighlighted: true),
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

  Widget _buildStatColumn(String count, String title, {bool isHighlighted = false}) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: isHighlighted ? const Color(0xFF4ADE80) : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF3E8FF),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. "Complete Your Profile" Action Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildCompleteProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFEF3C7), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '● ',
                style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11),
              ),
              const Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '+5% to 100%',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '3 tasks left',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Linear Gradient Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFF1F5F9)),
                  FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFF701A33)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Action Cards Row (Add Jathagam & More Photos)
          Row(
            children: [
              // Action 1: Add Jathagam
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showAddJathagamModal(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 16,
                              color: Color(0xFFD97706),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Add Jathagam',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  'Chart matching',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFF59E0B)),
                            ),
                            child: const Text(
                              '+ Add',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Action 2: More Photos
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showMorePhotosModal(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFBCFE8)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE7F3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 16,
                              color: Color(0xFFBE185D),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'More Photos',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                Text(
                                  '+3 photos needed',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Add Jathagam (Horoscope) Interactive Modal Bottom Sheet
  // ─────────────────────────────────────────────────────────────
  void _showAddJathagamModal(BuildContext context) {
    int selectedTab = 0; // 0: Upload PDF/Scan, 1: Enter Details
    String selectedRasi = 'Mesham (மேஷம்)';
    String selectedNakshatra = 'Aswini (அஸ்வினி)';
    bool chevvaiDosham = false;
    bool raghuKethuDosham = false;
    String? uploadedFileName;

    final List<String> rasiList = [
      'Mesham (மேஷம்)',
      'Rishabham (ரிஷபம்)',
      'Mithunam (மிதுனம்)',
      'Kadagam (கடகம்)',
      'Simmam (சிம்மம்)',
      'Kanni (கன்னி)',
      'Thulam (துலாம்)',
      'Vrischikam (விருச்சிகம்)',
      'Dhanusu (தனுசு)',
      'Makaram (மகரம்)',
      'Kumbam (கும்பம்)',
      'Meenam (மீனம்)',
    ];

    final List<String> nakshatraList = [
      'Aswini (அஸ்வினி)',
      'Bharani (பரணி)',
      'Krithigai (கிருத்திகை)',
      'Rohini (ரோகிணி)',
      'Mrigashirsha (மிருகசீரிஷம்)',
      'Thiruvathirai (திருவாதிரை)',
      'Punarpoosam (புனர்பூசம்)',
      'Poosam (பூசம்)',
      'Ayilyam (ஆயில்யம்)',
      'Makam (மகம்)',
      'Pooram (பூரம்)',
      'Uthiram (உத்திரம்)',
      'Hastham (ஹஸ்தம்)',
      'Chithirai (சித்திரை)',
      'Swathi (சுவாதி)',
      'Visakam (விசாகம்)',
      'Anusham (அனுஷம்)',
      'Kettai (கேட்டை)',
      'Moolam (மூலம்)',
      'Pooradam (பூராடம்)',
      'Uthiradam (உத்திராடம்)',
      'Thiruvonam (திருவோணம்)',
      'Avittam (அவிட்டம்)',
      'Sathayam (சதயம்)',
      'Poorattathi (பூரட்டாதி)',
      'Uthirattathi (உத்திரட்டாதி)',
      'Revathi (ரேவதி)',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.82,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFFD97706),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Add Jathagam (ஜாதகம் விவரங்கள்)',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                'For accurate 10 Porutham horoscope match',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Segmented Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => selectedTab = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedTab == 0 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: selectedTab == 0
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(15),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Upload Jathagam',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: selectedTab == 0 ? FontWeight.w800 : FontWeight.w600,
                                      color: selectedTab == 0 ? const Color(0xFF701A33) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => selectedTab = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: selectedTab == 1 ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: selectedTab == 1
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(15),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Enter Chart Details',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: selectedTab == 1 ? FontWeight.w800 : FontWeight.w600,
                                      color: selectedTab == 1 ? const Color(0xFF701A33) : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: selectedTab == 0
                          ? _buildUploadJathagamTab(
                              uploadedFileName: uploadedFileName,
                              onFileSelected: (name) => setModalState(() => uploadedFileName = name),
                            )
                          : _buildEnterChartDetailsTab(
                              rasiList: rasiList,
                              nakshatraList: nakshatraList,
                              selectedRasi: selectedRasi,
                              selectedNakshatra: selectedNakshatra,
                              chevvaiDosham: chevvaiDosham,
                              raghuKethuDosham: raghuKethuDosham,
                              onRasiChanged: (v) => setModalState(() => selectedRasi = v),
                              onNakshatraChanged: (v) => setModalState(() => selectedNakshatra = v),
                              onChevvaiChanged: (v) => setModalState(() => chevvaiDosham = v),
                              onRaghuKethuChanged: (v) => setModalState(() => raghuKethuDosham = v),
                            ),
                    ),
                  ),

                  // Footer Save Action
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Jathagam details saved! 10 Porutham match is now enabled.',
                                        style: TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF1E293B),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF701A33),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save & Enable 10 Porutham Score',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUploadJathagamTab({
    required String? uploadedFileName,
    required ValueChanged<String> onFileSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFFD97706),
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                uploadedFileName ?? 'Upload Horoscope / Jathagam PDF or Photo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Supports PDF, JPG, PNG (Max 10 MB)',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => onFileSelected('Jathagam_Scan_2026.pdf'),
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                    label: const Text('Upload PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB45309),
                      side: const BorderSide(color: Color(0xFFF59E0B)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => onFileSelected('Jathagam_Photo_Capture.jpg'),
                    icon: const Icon(Icons.camera_alt_rounded, size: 16),
                    label: const Text('Take Photo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: const [
              Icon(Icons.lock_outline_rounded, size: 16, color: Color(0xFF059669)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '100% Sacred & Secure: Only matched families approved by you can view full horoscope details.',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnterChartDetailsTab({
    required List<String> rasiList,
    required List<String> nakshatraList,
    required String selectedRasi,
    required String selectedNakshatra,
    required bool chevvaiDosham,
    required bool raghuKethuDosham,
    required ValueChanged<String> onRasiChanged,
    required ValueChanged<String> onNakshatraChanged,
    required ValueChanged<bool> onChevvaiChanged,
    required ValueChanged<bool> onRaghuKethuChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rasi Dropdown
        const Text(
          'Moon Sign / Rasi (ராசி)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedRasi,
              items: rasiList.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12.5)))).toList(),
              onChanged: (v) {
                if (v != null) onRasiChanged(v);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Nakshatram Dropdown
        const Text(
          'Star / Nakshatram (நட்சத்திரம்)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCBD5E1)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedNakshatra,
              items: nakshatraList.map((n) => DropdownMenuItem(value: n, child: Text(n, style: const TextStyle(fontSize: 12.5)))).toList(),
              onChanged: (v) {
                if (v != null) onNakshatraChanged(v);
              },
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Dosham Checkboxes
        const Text(
          'Dosham Details (தோஷம் விவரங்கள்)',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => onChevvaiChanged(!chevvaiDosham),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: chevvaiDosham ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                    border: Border.all(color: chevvaiDosham ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        chevvaiDosham ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        size: 18,
                        color: chevvaiDosham ? const Color(0xFFBE123C) : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Chevvai Dosham',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => onRaghuKethuChanged(!raghuKethuDosham),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: raghuKethuDosham ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                    border: Border.all(color: raghuKethuDosham ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        raghuKethuDosham ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        size: 18,
                        color: raghuKethuDosham ? const Color(0xFFBE123C) : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Rahu-Ketu Dosham',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Birth Place & Time
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Birth Place', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                  const SizedBox(height: 4),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text('Chennai, Tamil Nadu', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Birth Time', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                  const SizedBox(height: 4),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text('09:45 AM', style: TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // More Photos Interactive Action Modal
  // ─────────────────────────────────────────────────────────────
  void _showMorePhotosModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE7F3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Color(0xFFBE185D),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Add More Photos (+3 Photos Needed)',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Profiles with 3+ photos receive 8x more parent interest',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Option 1: Full Photo Privacy & Gallery Manager
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.collections_rounded, color: Color(0xFFBE123C), size: 20),
                  ),
                  title: const Text(
                    'Open Photo & Privacy Manager',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  subtitle: const Text(
                    'Manage all 5 gallery slots, watermark & privacy controls',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PhotosPrivacyScreen()),
                    );
                  },
                ),
                const Divider(height: 14),

                // Option 2: Upload from Phone Gallery
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: Color(0xFF7E22CE), size: 20),
                  ),
                  title: const Text(
                    'Upload from Gallery',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  subtitle: const Text(
                    'Select traditional attire, family or casual portrait',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PhotosPrivacyScreen()),
                    );
                  },
                ),
                const Divider(height: 14),

                // Option 3: Camera
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF1D4ED8), size: 20),
                  ),
                  title: const Text(
                    'Take New Photo (Camera)',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  subtitle: const Text(
                    'Capture instant portrait with high clarity',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PhotosPrivacyScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Profile Activity & Insights
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileActivityInsights() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Profile Activity & Insights',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '• Real-time Stats',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const Text(
                'View All >',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF701A33),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.visibility_outlined,
                  iconColor: const Color(0xFFBE123C),
                  iconBg: const Color(0xFFFDF2F4),
                  count: '34',
                  unit: 'Profiles',
                  title: 'Viewed by Me',
                  subtitle: 'Profiles you browsed',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.star_outline_rounded,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFFEF3C7),
                  count: '12',
                  unit: 'Saved',
                  title: 'Shortlisted by Me',
                  subtitle: 'Your favorite matches',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.person_outline_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  count: '58',
                  unit: 'Views',
                  title: 'Viewed My Profile',
                  subtitle: 'Interested members',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInsightCard(
                  icon: Icons.favorite_outline_rounded,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFECFDF5),
                  count: '19',
                  unit: 'Members',
                  title: 'Shortlisted Me',
                  subtitle: 'Saved your profile',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String count,
    required String unit,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: iconColor),
              ),
              const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFFCBD5E1)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF94A3B8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Daily Recommendations Section
  // ─────────────────────────────────────────────────────────────
  Widget _buildDailyRecommendationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 16,
                color: Color(0xFF701A33),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Daily Recommendations',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.schedule_rounded, size: 11, color: Color(0xFFB45309)),
                    SizedBox(width: 4),
                    Text(
                      'Profile 1 of 3 Today • Resets in 14h',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'தினசரி பரிந்துரைகள் • Handpicked Matches',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Carousel dots
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF701A33),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDailyMatchCard(
                  imagePath: 'assets/images/home_samyuktha.jpg',
                  matchTag: '92% Match',
                  idTag: '#TA-F-7634',
                  name: 'Samyuktha K.',
                  details: '26 Yrs • 5\'4" • B.Tech',
                  job: 'Software Architect • ₹22L',
                  casteStar: 'Iyer - Vadama • Rohini',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDailyMatchCard(
                  imagePath: 'assets/images/home_priyadarshini.jpg',
                  matchTag: '94% Match',
                  idTag: '#TA-F-78341',
                  name: 'Priyadarshini S.',
                  details: '28 Yrs • 5\'6" • M.S, MBA',
                  job: 'Product Manager • ₹32L',
                  casteStar: 'Brahmin • Hastham',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMatchCard({
    required String imagePath,
    required String matchTag,
    required String idTag,
    required String name,
    required String details,
    required String job,
    required String casteStar,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo with match badge & ID tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 120,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF831843),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    matchTag,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    idTag,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  job,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF701A33),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  casteStar,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),

                // Outlined Pink Connect button with interactive toggle
                Builder(
                  builder: (btnCtx) {
                    final bool isConnected = _connectedProfileIds.contains(idTag);
                    return SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: OutlinedButton.icon(
                        onPressed: () => _handleConnect(idTag, name),
                        icon: Icon(
                          isConnected ? Icons.check_circle_rounded : Icons.favorite_border,
                          size: 13,
                          color: isConnected ? const Color(0xFF059669) : const Color(0xFFBE185D),
                        ),
                        label: Text(
                          isConnected ? 'Sent' : 'Connect',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isConnected ? const Color(0xFF059669) : const Color(0xFFBE185D),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isConnected ? const Color(0xFF059669) : const Color(0xFFBE185D),
                          backgroundColor: isConnected ? const Color(0xFFECFDF5) : const Color(0xFFFFF1F2),
                          side: BorderSide(
                            color: isConnected ? const Color(0xFFA7F3D0) : const Color(0xFFFECDD3),
                          ),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Recent Matches Section
  // ─────────────────────────────────────────────────────────────
  Widget _buildRecentMatchesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Recent Matches Handpicked For You',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'View >',
                style: TextStyle(
                  color: Color(0xFF701A33),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Based on your 11-step sacred partner preferences',
            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildRecentMatchCard(
                  imagePath: 'assets/images/groom_avatar.jpg',
                  matchTag: '92% Match',
                  idTag: '#TA-M-76436',
                  name: 'Dr. Siddharth S.',
                  details: '31 Yrs • 5\'11" • M.D',
                  job: 'Cardiologist • ₹35L',
                  casteStar: 'Iyer - Vadama • Rohini',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRecentMatchCard(
                  imagePath: 'assets/images/bride_portrait.jpg',
                  matchTag: '94% Match',
                  idTag: '#TA-F-74345',
                  name: 'Priyadarshini S.',
                  details: '28 Yrs • 5\'6" • M.S, MBA',
                  job: 'Product Manager • ₹32L',
                  casteStar: 'Brahmin • Hastham',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMatchCard({
    required String imagePath,
    required String matchTag,
    required String idTag,
    required String name,
    required String details,
    required String job,
    required String casteStar,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo with match badge & ID tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 120,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF831843),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    matchTag,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(160),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    idTag,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  job,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF701A33),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  casteStar,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 8),

                // Connect button with interactive toggle
                Builder(
                  builder: (btnCtx) {
                    final bool isConnected = _connectedProfileIds.contains(idTag);
                    return SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton.icon(
                        onPressed: () => _handleConnect(idTag, name),
                        icon: Icon(
                          isConnected ? Icons.check_circle_rounded : Icons.favorite_border,
                          size: 13,
                          color: Colors.white,
                        ),
                        label: Text(
                          isConnected ? 'Sent' : 'Connect',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isConnected ? const Color(0xFF059669) : const Color(0xFF701A33),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Newly Joined Section
  // ─────────────────────────────────────────────────────────────
  Widget _buildNewlyJoinedSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.circle, size: 7, color: Color(0xFF10B981)),
                  SizedBox(width: 6),
                  Text(
                    'Newly Joined (Last 30 Days)',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const Text(
                'View All >',
                style: TextStyle(
                  color: Color(0xFF701A33),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            '(30 Days) • Fresh Sacred Alliances',
            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildNewlyJoinedCard(
                  imagePath: 'assets/images/groom_full.jpg',
                  timeTag: 'New • 2d ago',
                  casteTag: 'Vadama',
                  name: 'Karthik V.',
                  details: '28 Yrs • 5\'11" • Chennai',
                  job: 'Lead Architect • ₹30L',
                  casteStar: 'Kashyapa • Revathi',
                ),
                const SizedBox(width: 12),
                _buildNewlyJoinedCard(
                  imagePath: 'assets/images/home_priyadarshini.jpg',
                  timeTag: 'New • 5d ago',
                  casteTag: 'Iyer',
                  name: 'Bhavani S.',
                  details: '27 Yrs • 5\'6" • Bangalore',
                  job: 'Data Scientist • ₹26L',
                  casteStar: 'Bharadvaja • Anusham',
                ),
                const SizedBox(width: 12),
                _buildNewlyJoinedCard(
                  imagePath: 'assets/images/bride_portrait.jpg',
                  timeTag: 'New • 1w ago',
                  casteTag: 'Mudaliar',
                  name: 'Nithya M.',
                  details: '26 Yrs • 5\'3" • Coimbatore',
                  job: 'Assistant Professor • ₹12L',
                  casteStar: 'Srivatsa • Aswini',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewlyJoinedCard({
    required String imagePath,
    required String timeTag,
    required String casteTag,
    required String name,
    required String details,
    required String job,
    required String casteStar,
  }) {
    return Container(
      width: 165,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo with time tag and caste tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.asset(
                  imagePath,
                  height: 115,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 115,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 36),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF047857),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle, size: 5, color: Colors.white),
                      const SizedBox(width: 3),
                      Text(
                        timeTag,
                        style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD97706),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    casteTag,
                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF10B981)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  job,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF701A33)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  casteStar,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Amber Connect button with interactive toggle
                Builder(
                  builder: (btnCtx) {
                    final bool isConnected = _connectedProfileIds.contains(name);
                    return SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ElevatedButton.icon(
                        onPressed: () => _handleConnect(name, name),
                        icon: Icon(
                          isConnected ? Icons.check_circle_rounded : Icons.favorite_border,
                          size: 12,
                          color: isConnected ? Colors.white : const Color(0xFF451A03),
                        ),
                        label: Text(
                          isConnected ? 'Sent' : 'Connect',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isConnected ? Colors.white : const Color(0xFF451A03),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: isConnected ? Colors.white : const Color(0xFF451A03),
                          backgroundColor: isConnected ? const Color(0xFF059669) : const Color(0xFFF59E0B),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Help / Contact Support Banner
  // ─────────────────────────────────────────────────────────────
  Widget _buildSupportBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Color(0xFFB45309),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Need help in using tamil alliance',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF78350F),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'CONTACT THROUGH CALL OR CHAT',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF78350F),
                    side: const BorderSide(color: Color(0xFFF59E0B)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('CALL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF78350F),
                    side: const BorderSide(color: Color(0xFFF59E0B)),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('EMAIL', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Bottom Navigation Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          onTap: (idx) => setState(() => _bottomNavIndex = idx),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF701A33),
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 23),
              activeIcon: Icon(Icons.home_rounded, size: 23),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded, size: 23),
              activeIcon: Icon(Icons.people_rounded, size: 23),
              label: 'Alliance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_outlined, size: 31),
              activeIcon: Icon(Icons.workspace_premium_rounded, size: 31),
              label: 'Premium',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism_outlined, size: 23),
              activeIcon: Icon(Icons.volunteer_activism_rounded, size: 23),
              label: 'Interests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded, size: 23),
              activeIcon: Icon(Icons.chat_bubble_rounded, size: 23),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}

class _CrownIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _CrownIcon({
    this.size = 11.5,
    this.color = const Color(0xFF4A2500),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.25,
      height: size,
      child: CustomPaint(
        painter: _CrownPainter(color: color),
      ),
    );
  }
}

class _CrownPainter extends CustomPainter {
  final Color color;
  _CrownPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // 1. Underline base bar directly below crown
    canvas.drawLine(
      Offset(w * 0.08, h * 0.94),
      Offset(w * 0.92, h * 0.94),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round,
    );

    // 2. Crown Outline Path
    final path = Path();
    path.moveTo(w * 0.12, h * 0.78);
    path.lineTo(w * 0.12, h * 0.38);
    path.lineTo(w * 0.35, h * 0.58);
    path.lineTo(w * 0.50, h * 0.22);
    path.lineTo(w * 0.65, h * 0.58);
    path.lineTo(w * 0.88, h * 0.38);
    path.lineTo(w * 0.88, h * 0.78);
    path.close();

    canvas.drawPath(path, strokePaint);

    // 3. Dots on the 3 crown points
    canvas.drawCircle(Offset(w * 0.12, h * 0.34), 1.15, fillPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.18), 1.25, fillPaint);
    canvas.drawCircle(Offset(w * 0.88, h * 0.34), 1.15, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

