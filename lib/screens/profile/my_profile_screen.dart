import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MyProfileScreen extends StatefulWidget {
  final String? userName;

  const MyProfileScreen({
    super.key,
    this.userName,
  });

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  void _showEditProfileBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Biodata & Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Update your verified personal details, education, career, and family background.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile details updated successfully! ✓'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF701A33),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

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
              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
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

  @override
  Widget build(BuildContext context) {
    final String displayName = widget.userName ?? 'Karthik Sundaram';

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cover Photo & Avatar Header
            _buildCoverAndAvatarHeader(displayName),
            const SizedBox(height: 12),

            // 2. Action Buttons (Edit Profile & Edit Preferences)
            _buildProfileActionsRow(),
            const SizedBox(height: 14),

            // 3. Name, ID, Bio & Lineage Tags
            _buildProfileSummarySection(displayName),
            const SizedBox(height: 16),

            // 4. Basic Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildBasicDetailsCard(displayName),
            ),
            const SizedBox(height: 14),

            // 5. Astrology & Horoscope Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildAstrologyCard(),
            ),
            const SizedBox(height: 14),

            // 6. Education & Career Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildEducationCareerCard(),
            ),
            const SizedBox(height: 14),

            // 7. Family Lineage & Roots Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildFamilyLineageCard(),
            ),
            const SizedBox(height: 14),

            // 8. Partner Preferences Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildPartnerPreferencesCard(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
                          fontSize: 16,
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
                            style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
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
                        content: Text('Viewing public prospective match preview.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Settings icon (White circular button)
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.settings_outlined, color: Color(0xFF701A33), size: 18),
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
          height: 120,
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
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(15), width: 1.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withAlpha(15), width: 1.5),
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
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFF701A33),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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
  // 3. Profile Action Buttons Row
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileActionsRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 38, left: 14, right: 14),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showEditProfileBottomSheet,
              icon: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF701A33),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _showEditProfileBottomSheet,
              icon: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.white),
              label: const Text(
                'Edit Preferences',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF701A33),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Name, ID, Bio & Lineage Tags
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
                  fontSize: 18,
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
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
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
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '• 29 Yrs • 5\' 11" (180 cm)',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            '• Chennai, Tamil Nadu',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),

          // Bio Quote Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: const Text(
              '"Lead Cloud Architect in Amazon Chennai. Seeking a culturally grounded, ambitious Tamil alliance from an orthodox yet progressive family."',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.normal,
                color: Color(0xFF78350F),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tag Pills
          Wrap(
            spacing: 6,
            runSpacing: 6,
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
  // 5. Basic Details Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildBasicDetailsCard(String name) {
    return _buildSectionContainer(
      icon: Icons.person_outline_rounded,
      iconColor: const Color(0xFFBE185D),
      title: 'BASIC DETAILS',
      subtitle: 'Personal identity and vitals',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDataBox('FULL NAME', name, labelColor: const Color(0xFF991B1B))),
              const SizedBox(width: 8),
              Expanded(child: _buildDataBox('DATE OF BIRTH', '14 Oct 1996 (29 Yrs)', labelColor: const Color(0xFF991B1B))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDataBox('MARITAL STATUS', 'Never Married', labelColor: const Color(0xFF991B1B))),
              const SizedBox(width: 8),
              Expanded(child: _buildDataBox('HEIGHT & WEIGHT', '5\' 11" (180 cm) • 74 kg', labelColor: const Color(0xFF991B1B))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDataBox('MOTHER TONGUE', 'Tamil (தமிழ்)', labelColor: const Color(0xFF991B1B))),
              const SizedBox(width: 8),
              Expanded(child: _buildDataBox('DIET & LIFESTYLE', 'Pure Vegetarian • Non-Smoker', labelColor: const Color(0xFF991B1B))),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Astrology & Horoscope Card
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAstrologyDataBox(
                  'RASI (MOON SIGN)',
                  'Makaram (Capricorn)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAstrologyDataBox(
                  'NAKSHATRAM (STAR)',
                  'Uthiradam (Padam 2)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAstrologyDataBox(
                  'LAGNAM (ASCENDANT)',
                  'Mesham (Aries)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAstrologyDataBox(
                  'CHEVVAI / RAHU DOSHAM',
                  'No Dosham\n(Shuddha)',
                  isVerifiedDosham: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Attached PDF Document Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
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
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Certified_Jathagam_Karthik.pdf',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Auto-parsed by Vedic AstroEngine • 12 Houses\nValidated',
                        style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B), height: 1.25),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _showJathagamChartModal,
                  child: const Text(
                    'View\nChart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
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
  // 7. Education & Career Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCareerCard() {
    return _buildSectionContainer(
      icon: Icons.school_outlined,
      iconColor: const Color(0xFF2563EB),
      title: 'EDUCATION & CAREER',
      subtitle: 'Professional pedigree & income',
      child: Column(
        children: [
          // Highest Degree Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF2F8),
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
                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF991B1B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'B.Tech (Computer Science) + Executive MBA',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'PSG College of Tech, Coimbatore • IIM Bangalore',
                        style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
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
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF2F8),
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
                        style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF991B1B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Lead Cloud Solutions Architect',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Amazon Web Services (AWS) • OMR Chennai',
                        style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildAstrologyDataBox('ANNUAL INCOME', '₹34,00,000 / Year'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAstrologyDataBox('WORK LOCATION', 'Chennai (Hybrid /\nOnsite)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Family Lineage & Roots Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyLineageCard() {
    return _buildSectionContainer(
      icon: Icons.diversity_3_rounded,
      iconColor: const Color(0xFFDB2777),
      title: 'FAMILY LINEAGE & ROOTS',
      subtitle: 'Gothram, heritage and family background',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAstrologyDataBox('COMMUNITY & GOTHRAM', 'Brahmin – Vadama\n(Koundinya)'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAstrologyDataBox('FAMILY VALUES', 'Orthodox / Traditional'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAstrologyDataBox('FATHER\'S PROFILE', 'Retd. Dy GM, State\nBank of India'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAstrologyDataBox('MOTHER\'S PROFILE', 'Home Maker (Carnatic\nSinger)'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAstrologyDataBox('SIBLINGS', '1 Younger Sister\n(Married in US)'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAstrologyDataBox('ANCESTRAL TOWN', 'Kumbakonam,\nThanjavur'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Partner Preferences Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildPartnerPreferencesCard() {
    return _buildSectionContainer(
      icon: Icons.favorite_border_rounded,
      iconColor: const Color(0xFFE11D48),
      title: 'PARTNER PREFERENCES',
      subtitle: 'Desired criteria & compatibility rules',
      badgeText: 'MATCHING: 88%',
      badgeColor: const Color(0xFFFFF1F2),
      badgeTextColor: const Color(0xFFBE123C),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDataBox('AGE & HEIGHT RANGE', '24 - 28 Yrs • 5\'2" - 5\'8" (158 - 172 cm)')),
              const SizedBox(width: 8),
              Expanded(child: _buildDataBox('MARITAL STATUS', 'Never Married / Single')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDataBox('COMMUNITY & RELIGION', 'Hindu • Brahmin - Vadama, Brahacharanam')),
              const SizedBox(width: 8),
              Expanded(child: _buildDataBox('ASTROLOGY & DOSHAM', 'Min 7+ Poruthams • Chevvai / Non-Dosham')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDataBox('EDUCATION & OCCUPATION', 'B.Tech, MBA, MS • IT / Software / Tech')),
              const SizedBox(width: 8),
              Expanded(child: _buildDataBox('ANNUAL INCOME & LOCATION', '₹12L - ₹40L+ / Yr • Chennai, Bangalore, USA')),
            ],
          ),
          const SizedBox(height: 8),
          _buildDataBox('DIET & LIFESTYLE HABITS', 'Pure Vegetarian • Never Smokes • Non-Drinker'),
        ],
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
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor ?? const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: badgeTextColor ?? const Color(0xFFB45309),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildDataBox(String label, String value, {Color? textColor, Color? labelColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              color: labelColor ?? const Color(0xFF94A3B8),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor ?? const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologyDataBox(
    String label,
    String value, {
    bool isVerifiedDosham = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF991B1B),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          if (isVerifiedDosham)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF059669),
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF701A33)),
      ),
    );
  }
}
