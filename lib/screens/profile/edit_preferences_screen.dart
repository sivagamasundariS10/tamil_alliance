import 'package:flutter/material.dart';

class EditPartnerPreferencesScreen extends StatefulWidget {
  final String? userName;

  const EditPartnerPreferencesScreen({
    super.key,
    this.userName,
  });

  @override
  State<EditPartnerPreferencesScreen> createState() => _EditPartnerPreferencesScreenState();
}

class _EditPartnerPreferencesScreenState extends State<EditPartnerPreferencesScreen> {
  // Preference States
  String _ageRange = '24 – 28 Yrs';
  String _ageSub = '(Born 1996 - 2000)';
  String _heightSpan = '5\'0" – 5\'8"';
  String _heightSub = '(152 - 173 cm)';
  String _maritalStatus = 'Never Married';
  String _motherTongue = 'Tamil (தமிழ்)';

  String _religion = 'Hindu';
  String _subSect = 'Smartha';
  List<String> _acceptedSubCastes = [
    'Brahmin - Vadama',
    'Brahmin - Brahacharanam',
    '+ Ashtasahasram (Flexible)',
  ];
  String _gothrams = 'Bharadwaja, Srivatsa, Haritha, Viswamitra, Kashyapa, Gautama, Sandilya';

  String _minPoruthams = '7+ out of 10';
  String _chevvai = 'Shuddha / Equal';
  String _rahuKethu = 'Conditional';
  String _papasamyam = 'Balanced';
  List<String> _preferredStars = ['Rohini', 'Mrigashira', 'Hastham', 'Swati', 'Revati', 'Uthiradam'];

  String _education = 'B.Tech / B.E, M.S, MBA, M.Tech, CA';
  String _occupation = 'Software / IT, Banking / Finance, Healthcare, Analytics';
  String _annualIncome = '₹15L – ₹40L+ / Yr';
  String _employmentSector = 'Private / Corporate';

  String _targetCities = 'Chennai, Bangalore, Hyderabad, Coimbatore';
  String _countries = 'India, USA, Singapore';
  String _ancestralRoots = 'Tamil Nadu Origin';

  String _dietary = 'Vegetarian (சைவம்)';
  String _habits = 'Teetotaler';
  String _familyStructure = 'Joint / Nuclear';
  String _cultural =
      'Carnatic Music appreciation, traditional festivals (Marghazhi, Navarathri), temple visits, alongside modern progressive thoughts';

  void _showEditSectionDialog(String sectionName) {
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
                Text(
                  'Edit $sectionName',
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Customize your exact match criteria for $sectionName. All potential matches will be filtered according to this rule.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$sectionName preference criteria updated successfully!'),
                    backgroundColor: const Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800E2F),
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save & Apply Criteria', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPreferences() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset All Preferences?'),
        content: const Text('This will reset your partner criteria to standard cultural recommendations.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferences reset to default.'),
                  backgroundColor: Color(0xFF800E2F),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF800E2F),
            ),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
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
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Card
            _buildPartnerCriteriaHeaderCard(),
            const SizedBox(height: 16),

            // 1. Basic & Physical Criteria
            _buildBasicPhysicalCriteriaCard(),
            const SizedBox(height: 16),

            // 2. Community & Lineage
            _buildCommunityLineageCard(),
            const SizedBox(height: 16),

            // 3. Astrology & Poruthams
            _buildAstrologyPoruthamsCard(),
            const SizedBox(height: 16),

            // 4. Education & Career
            _buildEducationCareerCard(),
            const SizedBox(height: 16),

            // 5. Location & Residence
            _buildLocationResidenceCard(),
            const SizedBox(height: 16),

            // 6. Lifestyle & Values
            _buildLifestyleValuesCard(),
            const SizedBox(height: 20),

            // Save Preferences Button
            _buildSavePreferencesButton(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. App Bar
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
                const Expanded(
                  child: Text(
                    'Partner Preferences',
                    style: TextStyle(
                      color: Color(0xFFF5D68B),
                      fontFamily: 'serif',
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _resetPreferences,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 1.2),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 18),
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
  // 2. Partner Criteria Header Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildPartnerCriteriaHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Partner Criteria',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${widget.userName ?? 'Karthik Sundaram'} Alliance ID: TA-78492 • Tamil Brahmin Alliance',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: const Text(
              '"Seeking a culturally grounded, family-oriented partner with post-graduate education and shared traditional Tamil values."',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterPill('24 – 28 Yrs'),
              _buildFilterPill('Brahmin - Vadama / Brahacharanam'),
              _buildFilterPill('B.Tech / MBA / MS'),
              _buildFilterPill('Chennai / USA / Blr'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE4D5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF831843),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Section Card Builder
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitleTamil,
    String? badgeText,
    required VoidCallback onEditTap,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: iconColor.withAlpha(35)),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFFCE7F3)),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF831843),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitleTamil,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF7F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFEDE4D5)),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: Color(0xFF831843),
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

  // ─────────────────────────────────────────────────────────────
  // 4. Data Box Helpers
  // ─────────────────────────────────────────────────────────────
  Widget _buildDataBox({
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDE4D5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF831843),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Card 1: Basic & Physical Criteria
  // ─────────────────────────────────────────────────────────────
  Widget _buildBasicPhysicalCriteriaCard() {
    return _buildSectionCard(
      icon: Icons.favorite_border_rounded,
      iconColor: const Color(0xFFE11D48),
      title: 'BASIC & PHYSICAL CRITERIA',
      subtitleTamil: 'அடிப்படை & உடல் தகுதிகள்',
      onEditTap: () => _showEditSectionDialog('Basic & Physical Criteria'),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'AGE RANGE',
                  value: _ageRange,
                  subtitle: _ageSub,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'HEIGHT SPAN',
                  value: _heightSpan,
                  subtitle: _heightSub,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'MARITAL STATUS',
                  value: _maritalStatus,
                  subtitle: 'Single alliance',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'MOTHER TONGUE',
                  value: _motherTongue,
                  subtitle: 'Mandatory',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Card 2: Community & Lineage
  // ─────────────────────────────────────────────────────────────
  Widget _buildCommunityLineageCard() {
    return _buildSectionCard(
      icon: Icons.account_balance_outlined,
      iconColor: const Color(0xFF8B5CF6),
      title: 'COMMUNITY & LINEAGE',
      subtitleTamil: 'சமூகம் & பரம்பரை',
      onEditTap: () => _showEditSectionDialog('Community & Lineage'),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'RELIGION',
                  value: _religion,
                  subtitle: 'Vedic Tradition',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'SUB-SECT / KULAM',
                  value: _subSect,
                  subtitle: 'Orthodox / Open',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ACCEPTED SUB-CASTES',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF831843),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _acceptedSubCastes.map((subCaste) {
                    final bool isFlexible = subCaste.contains('+');
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isFlexible ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isFlexible ? const Color(0xFFCBD5E1) : const Color(0xFFEDE4D5),
                        ),
                      ),
                      child: Text(
                        subCaste,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isFlexible ? FontWeight.w600 : FontWeight.w800,
                          color: isFlexible ? const Color(0xFF64748B) : const Color(0xFF1E293B),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildDataBox(
            label: 'ACCEPTED GOTHRAMS',
            value: _gothrams,
            subtitle: 'Except self gothram (Koundinya)',
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Card 3: Astrology & Poruthams
  // ─────────────────────────────────────────────────────────────
  Widget _buildAstrologyPoruthamsCard() {
    return _buildSectionCard(
      icon: Icons.wb_sunny_outlined,
      iconColor: const Color(0xFFD97706),
      title: 'ASTROLOGY & PORUTHAMS',
      subtitleTamil: 'ஜாதகம் & பொருத்தங்கள்',
      badgeText: 'VEDIC',
      onEditTap: () => _showEditSectionDialog('Astrology & Poruthams'),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'MIN. PORUTHAMS',
                  value: _minPoruthams,
                  subtitle: 'Dina, Gana, Yoni req.',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'CHEVVAI (KUJA)',
                  value: _chevvai,
                  subtitle: 'Kavacham / No Dosham',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'RAHU-KETHU DOSHAM',
                  value: _rahuKethu,
                  subtitle: 'Matched and Remedy',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'PAPASAMYAM',
                  value: _papasamyam,
                  subtitle: '+2 Point threshold',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4D5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PREFERRED NAKSHATRAMS (UTHIRADAM ALLIANCES)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF831843),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _preferredStars.map((star) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEDE4D5)),
                      ),
                      child: Text(
                        star,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Card 4: Education & Career
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCareerCard() {
    return _buildSectionCard(
      icon: Icons.school_outlined,
      iconColor: const Color(0xFF0284C7),
      title: 'EDUCATION & CAREER',
      subtitleTamil: 'கல்வி & தொழில்',
      onEditTap: () => _showEditSectionDialog('Education & Career'),
      child: Column(
        children: [
          _buildDataBox(
            label: 'EDUCATIONAL QUALIFICATION',
            value: _education,
            subtitle: 'Premier Institutions preferred (IIT, IIM, BITS, Anna Univ)',
          ),
          const SizedBox(height: 8),
          _buildDataBox(
            label: 'OCCUPATION & DOMAIN',
            value: _occupation,
            subtitle: 'Tier-1 Product / Consulting MNCs, Govt or Research',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'ANNUAL INCOME',
                  value: _annualIncome,
                  subtitle: '(\$120k+ if US based)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'EMPLOYMENT SECTOR',
                  value: _employmentSector,
                  subtitle: 'Govt / PSU open',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Card 5: Location & Residence
  // ─────────────────────────────────────────────────────────────
  Widget _buildLocationResidenceCard() {
    return _buildSectionCard(
      icon: Icons.location_on_outlined,
      iconColor: const Color(0xFF831843),
      title: 'LOCATION & RESIDENCE',
      subtitleTamil: 'இருப்பிடம் & பூர்வீகம்',
      onEditTap: () => _showEditSectionDialog('Location & Residence'),
      child: Column(
        children: [
          _buildDataBox(
            label: 'TARGET CITIES',
            value: _targetCities,
            subtitle: 'Willingness to relocate to Chennai or Hybrid work',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'COUNTRIES',
                  value: _countries,
                  subtitle: 'H1B / PR acceptable',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'ANCESTRAL ROOTS',
                  value: _ancestralRoots,
                  subtitle: 'Thanjavur, Trichy belt',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 10. Card 6: Lifestyle & Values
  // ─────────────────────────────────────────────────────────────
  Widget _buildLifestyleValuesCard() {
    return _buildSectionCard(
      icon: Icons.location_on_outlined,
      iconColor: const Color(0xFF831843),
      title: 'LIFESTYLE & VALUES',
      subtitleTamil: 'வாழ்க்கை முறை & ஒழுக்கம்',
      onEditTap: () => _showEditSectionDialog('Lifestyle & Values'),
      child: Column(
        children: [
          _buildDataBox(
            label: 'DIETARY EXPECTATION',
            value: _dietary,
            subtitle: 'No eggs / non-veg inside domestic household',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDataBox(
                  label: 'HABITS',
                  value: _habits,
                  subtitle: 'Non-Smoker, Non-Drinker',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDataBox(
                  label: 'FAMILY STRUCTURE',
                  value: _familyStructure,
                  subtitle: 'Harmonious bonding',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDataBox(
            label: 'CULTURAL INCLINATION',
            value: _cultural,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 11. Save Preferences Bottom Button
  // ─────────────────────────────────────────────────────────────
  Widget _buildSavePreferencesButton() {
    return Material(
      color: const Color(0xFF800E2F),
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: const Color(0x33000000),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Partner Preferences saved successfully!'),
                ],
              ),
              backgroundColor: Color(0xFF059669),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Save Preferences',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.check_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
