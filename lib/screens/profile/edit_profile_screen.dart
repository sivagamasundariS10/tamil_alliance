import 'package:flutter/material.dart';
import 'edit_preferences_screen.dart';
import 'edit_basic_details_screen.dart';
import 'edit_education_career_screen.dart';
import 'edit_family_details_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String? userName;

  const EditProfileScreen({
    super.key,
    this.userName,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Affluence state
  String _selectedAffluence = 'Upper Middle';
  String _selectedPropertyStatus = 'Own House / Villa';

  // Profile data states
  late String _fullName;
  String _dob = '14 Oct 1996 (29 Yrs)';
  String _maritalStatus = 'Never Married';
  String _heightWeight = '5\' 11" (180 cm) • 74 kg';
  String _motherTongue = 'Tamil (தமிழ்)';
  String _dietLifestyle = 'Pure Vegetarian • Non–Smoker';

  // Career states
  String _highestDegree = 'B.Tech (Computer Science) + Executive MBA';
  String _college = 'PSG College of Tech, Coimbatore • IIM Bangalore';
  String _profession = 'Lead Cloud Solutions Architect';
  String _employer = 'Amazon Web Services (AWS) • OMR Chennai';
  String _annualIncome = '₹34,00,000 / Year';
  String _workLocation = 'Chennai (Hybrid /\nOnsite)';

  @override
  void initState() {
    super.initState();
    _fullName = widget.userName ?? 'Karthik Sundaram';
  }

  Future<void> _openEditBasicDetailsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBasicDetailsScreen(
          initialFullName: _fullName,
          initialDob: _dob,
          initialMaritalStatus: _maritalStatus,
          initialHeightWeight: _heightWeight,
          initialMotherTongue: _motherTongue,
          initialDietLifestyle: _dietLifestyle,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (result['fullName'] != null) _fullName = result['fullName'];
        if (result['dob'] != null) _dob = result['dob'];
        if (result['maritalStatus'] != null) _maritalStatus = result['maritalStatus'];
        if (result['heightWeight'] != null) _heightWeight = result['heightWeight'];
        if (result['motherTongue'] != null) _motherTongue = result['motherTongue'];
        if (result['dietLifestyle'] != null) _dietLifestyle = result['dietLifestyle'];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Basic Details updated and saved successfully!',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1E293B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _openEditEducationCareerScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEducationCareerScreen(
          initialHighestDegree: _highestDegree,
          initialCollege: _college,
          initialProfession: _profession,
          initialEmployer: _employer,
          initialAnnualIncome: _annualIncome,
          initialWorkLocation: _workLocation,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (result['highestDegree'] != null) _highestDegree = result['highestDegree'];
        if (result['college'] != null) _college = result['college'];
        if (result['profession'] != null) _profession = result['profession'];
        if (result['employer'] != null) _employer = result['employer'];
        if (result['annualIncome'] != null) _annualIncome = result['annualIncome'];
        if (result['workLocation'] != null) _workLocation = result['workLocation'];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Education & Career updated and saved successfully!',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1E293B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _openFamilyDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditFamilyDetailsScreen(),
      ),
    );
  }

  void _showEditSectionModal(String sectionTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit_outlined, color: Color(0xFF881337), size: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit $sectionTitle',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Update your verified information for $sectionTitle. Changes are instantly reflected across prospective alliance matches.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '$sectionTitle updated and saved successfully!',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF1E293B),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF881337),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save & Update Section', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      appBar: _buildCustomAppBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Cover Photo & Avatar Header
            _buildCoverAndAvatarHeader(_fullName),
            const SizedBox(height: 12),

            // 2. Edit Preview Action Button
            _buildEditPreviewRow(),
            const SizedBox(height: 12),

            // 3. Name, ID, Bio & Lineage Tags
            _buildProfileSummarySection(_fullName),
            const SizedBox(height: 16),

            // 4. Basic Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildBasicDetailsCard(_fullName),
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

            // 8. Family Affluence & Assets Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: _buildFamilyAffluenceCard(),
            ),
            const SizedBox(height: 14),

            // 9. Partner Preferences Card
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
                        'Edit Profile',
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
                        content: Text('Viewing live prospective match preview.'),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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
        // Maroon Patterned Cover
        Container(
          height: 125,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5E0B22), Color(0xFF881337), Color(0xFF4C081A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative traditional rangoli circles
              Positioned(
                right: -25,
                top: -25,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(25), width: 1.5),
                  ),
                ),
              ),
              Positioned(
                right: 15,
                bottom: 10,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF5D68B).withAlpha(40), width: 1.5),
                  ),
                ),
              ),

              // Update Cover Button
              Positioned(
                top: 10,
                right: 12,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Update cover photo from sacred templates or gallery.'),
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

              // Sacred Privacy Shield pill
              Positioned(
                bottom: 10,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(70),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF5D68B).withAlpha(90), width: 0.8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.shield_outlined, size: 12, color: Color(0xFFF5D68B)),
                      SizedBox(width: 4),
                      Text(
                        'SACRED PRIVACY SHIELD',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF5D68B),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
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
  // 3. Edit Profile Action Row
  // ─────────────────────────────────────────────────────────────
  Widget _buildEditPreviewRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 14, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            color: const Color(0xFF800E2F),
            borderRadius: BorderRadius.circular(10),
            elevation: 1.5,
            shadowColor: const Color(0x33000000),
            child: InkWell(
              onTap: _openEditBasicDetailsScreen,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF059669)),
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
                  'Alliance ID: TA–78492',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF881337),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '• 29 Yrs • 5\' 11" (180 cm)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
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
  // 5. Basic Details Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildBasicDetailsCard(String name) {
    return _buildSectionContainer(
      icon: Icons.person_outline_rounded,
      iconColor: const Color(0xFFBE185D),
      title: 'BASIC DETAILS',
      subtitle: 'Personal identity and vitals',
      showDivider: true,
      onEditTap: _openEditBasicDetailsScreen,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPreferenceDataBox('FULL NAME', name)),
                const SizedBox(width: 8),
                Expanded(child: _buildPreferenceDataBox('DATE OF BIRTH', _dob)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPreferenceDataBox('MARITAL STATUS', _maritalStatus)),
                const SizedBox(width: 8),
                Expanded(child: _buildPreferenceDataBox('HEIGHT & WEIGHT', _heightWeight)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildPreferenceDataBox('MOTHER TONGUE', _motherTongue)),
                const SizedBox(width: 8),
                Expanded(child: _buildPreferenceDataBox('DIET & LIFESTYLE', _dietLifestyle)),
              ],
            ),
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
      showDivider: true,
      onEditTap: () => _showEditSectionModal('Astrology & Horoscope'),
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
                        'Auto-parsed by Vedic AstroEngine • 12 Houses\nValidated',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.25),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => _showEditSectionModal('Jathagam Chart'),
                  child: const Text(
                    'Edit\nChart',
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
  // 7. Education & Career Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCareerCard() {
    return _buildSectionContainer(
      icon: Icons.school_outlined,
      iconColor: const Color(0xFF2563EB),
      title: 'EDUCATION & CAREER',
      subtitle: 'Professional pedigree & income',
      showDivider: true,
      onEditTap: _openEditEducationCareerScreen,
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
                    children: [
                      const Text(
                        'HIGHEST DEGREE',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF831843)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _highestDegree,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _college,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
                    children: [
                      const Text(
                        'PROFESSION & EMPLOYER',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF831843)),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _profession,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _employer,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
                  child: _buildPreferenceDataBox('ANNUAL INCOME', _annualIncome),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPreferenceDataBox('WORK LOCATION', _workLocation),
                ),
              ],
            ),
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
      showDivider: true,
      onEditTap: _openFamilyDetailsScreen,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildPreferenceDataBox('COMMUNITY & GOTHRAM', 'Brahmin – Vadama\n(Koundinya)'),
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
  // 9. Family Affluence & Assets Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyAffluenceCard() {
    return _buildSectionContainer(
      icon: Icons.diamond_rounded,
      iconColor: const Color(0xFF38BDF8),
      iconBgColor: const Color(0xFFF6ECEB),
      title: 'FAMILY AFFLUENCE & ASSETS',
      subtitle: 'Economic standing & property status',
      showDivider: true,
      onEditTap: _openFamilyDetailsScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Affluence Tier',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFE11D48),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4 Grid Affluence Tiers
          Row(
            children: [
              Expanded(
                child: _buildAffluenceOption(
                  title: 'Middle Class',
                  subtitle: 'Below 1Cr',
                  isSelected: _selectedAffluence == 'Middle Class',
                  onTap: () => setState(() => _selectedAffluence = 'Middle Class'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAffluenceOption(
                  title: 'Upper Middle',
                  subtitle: 'Upto 1Cr - 5Cr',
                  isGoldBadge: true,
                  isSelected: _selectedAffluence == 'Upper Middle',
                  onTap: () => setState(() => _selectedAffluence = 'Upper Middle'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildAffluenceOption(
                  title: 'Affluent/Rich',
                  subtitle: 'Upto ₹5Cr - 25Cr',
                  isSelected: _selectedAffluence == 'Affluent/Rich',
                  onTap: () => setState(() => _selectedAffluence = 'Affluent/Rich'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAffluenceOption(
                  title: 'Elite',
                  subtitle: 'Upto ₹25Cr+',
                  isSelected: _selectedAffluence == 'Elite',
                  onTap: () => setState(() => _selectedAffluence = 'Elite'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Residential Property Status
          Row(
            children: const [
              Text(
                'Residential Property Status',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFE11D48),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildPropertyStatusOption(
                  title: 'Own House / Villa',
                  isSelected: _selectedPropertyStatus == 'Own House / Villa',
                  onTap: () => setState(() => _selectedPropertyStatus = 'Own House / Villa'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildPropertyStatusOption(
                  title: 'Rented / Leased',
                  isSelected: _selectedPropertyStatus == 'Rented / Leased',
                  onTap: () => setState(() => _selectedPropertyStatus = 'Rented / Leased'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAffluenceOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool isGoldBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF831843) : const Color(0xFFFAF7F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF831843) : const Color(0xFFEDE4D5),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : const Color(0xFF831843),
                  ),
                ),
                if (isGoldBadge && isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_rounded, size: 16, color: Color(0xFFF5D68B)),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFFFDE8E8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyStatusOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFAF7F2) : const Color(0xFFFAF7F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF831843) : const Color(0xFFEDE4D5),
            width: isSelected ? 2.0 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF831843) : const Color(0xFFCBD5E1),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.5,
                        height: 8.5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF831843),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF831843) : const Color(0xFF475569),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 10. Partner Preferences Card
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
      onEditTap: () => _showEditSectionModal('Partner Preferences'),
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
          const SizedBox(height: 12),

          // Edit All Partner Preferences Button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditPartnerPreferencesScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCE7F3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 16,
                    color: Color(0xFF881337),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Edit All Partner Preferences',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF881337),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF881337),
                  ),
                ],
              ),
            ),
          ),
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
    Color? iconBgColor,
    required String title,
    required String subtitle,
    required Widget child,
    String? badgeText,
    Color? badgeColor,
    Color? badgeTextColor,
    bool showDivider = false,
    VoidCallback? onEditTap,
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
                  color: iconBgColor ?? iconColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: iconBgColor != null ? const Color(0xFFEDE4D5) : iconColor.withAlpha(35)),
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
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
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
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: badgeTextColor ?? const Color(0xFFB45309),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (onEditTap != null)
                InkWell(
                  onTap: onEditTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFCE7F3)),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: Color(0xFF881337),
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
              fontSize: 13,
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
