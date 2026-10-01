import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';

class DownloadBiodataScreen extends StatefulWidget {
  final String? candidateName;
  final String? allianceId;

  const DownloadBiodataScreen({
    super.key,
    this.candidateName,
    this.allianceId,
  });

  @override
  State<DownloadBiodataScreen> createState() => _DownloadBiodataScreenState();
}

class _DownloadBiodataScreenState extends State<DownloadBiodataScreen> {
  void _showJathagamChartModal() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.auto_awesome, color: Color(0xFF701A33), size: 20),
            SizedBox(width: 8),
            Text(
              'Vedic Horoscope Chart',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Certified_Jathagam_Karthik.pdf',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF701A33)),
            ),
            SizedBox(height: 6),
            Text(
              'Thirukanitha & Vakya Panchangam with Dasa-Bhukti analysis verified by certified Astrologer.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF701A33), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _handleDownloadBiodata() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.cloud_download_rounded, color: Color(0xFF10B981), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Alliance Biodata (TA-78492) downloaded successfully as PDF! ✓',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const displayName = 'Karthik Sundaram';

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F5),
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cover Photo & Avatar Header
            _buildCoverAndAvatarHeader(displayName),
            const SizedBox(height: 48),

            // 2. Name, ID, Bio & Lineage Tags
            _buildProfileSummarySection(displayName),
            const SizedBox(height: 16),

            // 3. Basic Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildBasicDetailsCard(displayName),
            ),
            const SizedBox(height: 14),

            // 4. Astrology & Horoscope Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildAstrologyCard(),
            ),
            const SizedBox(height: 14),

            // 5. Education & Career Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildEducationCareerCard(),
            ),
            const SizedBox(height: 14),

            // 6. Family Lineage & Roots Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildFamilyLineageCard(),
            ),
            const SizedBox(height: 14),

            // 7. Partner Preferences Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildPartnerPreferencesCard(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyFooter(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Custom App Bar
  // ─────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        color: const Color(0xFF701A33),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_rounded, color: Color(0xFF701A33), size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          color: Color(0xFFF5D68B),
                          fontFamily: 'serif',
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Profile 95% Complete',
                            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Preview Button
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Viewing prospective match preview.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.visibility_outlined, color: Color(0xFF92400E), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Preview',
                          style: TextStyle(
                            color: Color(0xFF92400E),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Settings Circular White Button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.settings_outlined, color: Color(0xFF334155), size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Cover Photo & Avatar Header
  // ─────────────────────────────────────────────────────────────
  Widget _buildCoverAndAvatarHeader(String name) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover Banner
        Container(
          width: double.infinity,
          height: 125,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF701A33), Color(0xFF4C0B1E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Concentric circles watermark
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(20), width: 1.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withAlpha(20), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),

              // Update Cover Button
              Positioned(
                top: 12,
                right: 14,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Select image from gallery to update cover photo.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(90),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.camera_alt_outlined, color: Colors.white, size: 13),
                        SizedBox(width: 4),
                        Text(
                          'Update Cover',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Avatar Overlay (Silhouette with Gold Border)
        Positioned(
          left: 18,
          bottom: -36,
          child: Stack(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFDE68A), width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 58,
                    color: Color(0xFF9E3A5A),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Choose new profile avatar from gallery.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xFF701A33),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Name, ID, Bio & Lineage Tags
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileSummarySection(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + ID Verified Badge
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_rounded, color: Color(0xFF059669), size: 12),
                    SizedBox(width: 3),
                    Text(
                      'ID VERIFIED',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // Alliance ID & Info Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Alliance ID: TA-78492',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '• 29 Yrs • 5\' 11" (180 cm)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            '• Chennai, Tamil Nadu',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),

          // Bio Quote Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: const Text(
              '"Lead Cloud Architect in Amazon Chennai. Seeking a culturally grounded, ambitious Tamil alliance from an orthodox yet progressive family."',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                color: Color(0xFF475569),
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tag Pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _TagPill(label: 'B.Tech, MBA'),
              _TagPill(label: 'Brahmin – Vadama'),
              _TagPill(label: 'Uthiradam Nakshatra'),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Basic Details Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildBasicDetailsCard(String name) {
    return _buildSectionContainer(
      icon: Icons.person_outline_rounded,
      iconColor: const Color(0xFFBE185D),
      title: 'BASIC DETAILS',
      subtitle: 'Personal identity and vitals',
      showDivider: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPreferenceDataBox('FULL NAME', name)),
                const SizedBox(width: 8),
                Expanded(child: _buildPreferenceDataBox('DATE OF BIRTH', '14 Oct 1996 (29 Yrs)')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPreferenceDataBox('MARITAL STATUS', 'Never Married')),
                const SizedBox(width: 8),
                Expanded(child: _buildPreferenceDataBox('HEIGHT & WEIGHT', '5\' 11" (180 cm) • 74 kg')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPreferenceDataBox('MOTHER TONGUE', 'Tamil (தமிழ்)')),
                const SizedBox(width: 8),
                Expanded(child: _buildPreferenceDataBox('DIET & LIFESTYLE', 'Pure Vegetarian • Non-Smoker')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Astrology & Horoscope Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildAstrologyCard() {
    return _buildSectionContainer(
      icon: Icons.wb_sunny_outlined,
      iconColor: const Color(0xFFD97706),
      title: 'ASTROLOGY & HOROSCOPE',
      subtitle: 'Rasi, Nakshatra, Dosham & Natal Chart',
      badgeText: 'JATHAGAM',
      badgeColor: const Color(0xFFFEF3C7),
      badgeTextColor: const Color(0xFF92400E),
      showDivider: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox(
                    'RASI (MOON SIGN)',
                    'Makaram (Capricorn)',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox(
                    'NAKSHATRAM (STAR)',
                    'Uthiradam (Padam 2)',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox(
                    'LAGNAM (ASCENDANT)',
                    'Mesham (Aries)',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox(
                    'CHEVVAI / RAHU DOSHAM',
                    'No Dosham\n(Shuddha)',
                    isVerifiedDosham: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Attached PDF Document Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF881337),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'PDF',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Certified_Jathagam_Karthik.pdf',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Auto-parsed by Vedic AstroEngine • 12 Houses Validated',
                        style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), height: 1.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: _showJathagamChartModal,
                  child: const Text(
                    'View\nChart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF881337),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Education & Career Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCareerCard() {
    return _buildSectionContainer(
      icon: Icons.school_outlined,
      iconColor: const Color(0xFF2563EB),
      title: 'EDUCATION & CAREER',
      subtitle: 'Professional pedigree & income',
      showDivider: true,
      child: Column(
        children: [
          // Highest Degree Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.school_rounded, color: Color(0xFF1E293B), size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'HIGHEST DEGREE',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF831843)),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'B.Tech (Computer Science) – Executive MBA',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'PSG College of Tech, Coimbatore • IIM Bangalore',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Employer Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.business_center_rounded, color: Color(0xFF1E293B), size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'PROFESSION & EMPLOYER',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF831843)),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Lead Cloud Solutions Architect',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Amazon Web Services (AWS) • OMR Chennai',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox('ANNUAL INCOME', '₹34,00,000 / Year'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox('WORK LOCATION', 'Chennai (Hybrid /\nOnsite)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Family Lineage & Roots Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyLineageCard() {
    return _buildSectionContainer(
      icon: Icons.diversity_3_rounded,
      iconColor: const Color(0xFFDB2777),
      title: 'FAMILY LINEAGE & ROOTS',
      subtitle: 'Gothram, heritage and family background',
      showDivider: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox('COMMUNITY & GOTHRAM', 'Brahmin – Vadama\n(Kaundinya)'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox('FAMILY VALUES', 'Orthodox / Traditional'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox('FATHER\'S PROFILE', 'Retd. Dy GM, State\nBank of India'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox('MOTHER\'S PROFILE', 'Home Maker (Carnatic\nSinger)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox('SIBLINGS', '1 Younger Sister\n(Married in US)'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox('ANCESTRAL TOWN', 'Kumbakonam,\nThanjavur'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Partner Preferences Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildPartnerPreferencesCard() {
    return _buildSectionContainer(
      icon: Icons.favorite_border_rounded,
      iconColor: const Color(0xFF9F1239),
      title: 'PARTNER PREFERENCES',
      subtitle: 'Desired criteria & compatibility rules',
      badgeText: 'MATCHING',
      badgeColor: const Color(0xFFFFF1F2),
      badgeTextColor: const Color(0xFF9F1239),
      showDivider: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox(
                    'AGE & HEIGHT RANGE',
                    '24 – 28 Yrs • 5\'0" – 5\'8"\n(152–173 cm)',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox(
                    'MARITAL STATUS',
                    'Never Married / Single',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox(
                    'COMMUNITY & RELIGION',
                    'Hindu • Brahmin –\nVadama,\nBrahacharanam',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox(
                    'ASTROLOGY & DOSHAM',
                    'Min 7+ Poruthams •\nChevvai / Non-Dosham',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox(
                    'EDUCATION & OCCUPATION',
                    'B.Tech, MBA, MS • IT /\nSoftware / Tech',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox(
                    'ANNUAL INCOME &\nLOCATION',
                    '₹15L – ₹40L+ / Yr •\nChennai, Bangalore,\nUSA',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildPreferenceDataBox(
            'DIET & LIFESTYLE HABITS',
            'Pure Vegetarian • Never Smokes • Non-Drinker',
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Sticky Bottom Footer Button
  // ─────────────────────────────────────────────────────────────
  Widget _buildStickyFooter() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            offset: Offset(0, -3),
            blurRadius: 10,
          ),
        ],
        border: Border(
          top: BorderSide(color: Color(0xFFF1E5E9), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _handleDownloadBiodata,
              icon: const Icon(Icons.cloud_download_rounded, color: Colors.white, size: 22),
              label: const Text(
                'Alliance Biodata',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF701A33),
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: const Color(0x40701A33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Helper Widgets
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionContainer({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget child,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    bool showDivider = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: iconColor.withAlpha(35)),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor ?? const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFCE7F3)),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: badgeTextColor ?? const Color(0xFFB45309),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: 10),
            const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),
            const SizedBox(height: 12),
          ] else
            const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildPreferenceDataBox(
    String label,
    String value, {
    bool isVerifiedDosham = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE4D5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF831843),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          if (isVerifiedDosham)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF047857), size: 13),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF047857),
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                height: 1.35,
              ),
            ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEDE4D5)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF881337),
        ),
      ),
    );
  }
}
