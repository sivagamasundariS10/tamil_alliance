import 'package:flutter/material.dart';
import 'alliance_filter_screen.dart';

class AllianceScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const AllianceScreen({
    super.key,
    this.onNavigateToHome,
  });

  @override
  State<AllianceScreen> createState() => _AllianceScreenState();
}

class _AllianceScreenState extends State<AllianceScreen> {
  int _selectedFilterIndex = 0;
  bool _isShortlisted = false;
  int _shortlistCount = 342;
  bool _isInterestSent = false;
  bool _isNextShortlisted = false;
  bool _isNextInterestSent = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _filters = [
    {'title': 'All', 'isSpecial': false},
    {
      'title': 'Uthama Match\n(For premium only)',
      'isSpecial': true,
      'icon': Icons.workspace_premium_rounded,
    },
    {
      'title': 'Govt ID Verified',
      'isSpecial': false,
      'icon': Icons.shield_outlined,
    },
    {
      'title': 'Mutual Alliance',
      'isSpecial': false,
      'icon': Icons.handshake_outlined,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSendInterest() {
    setState(() {
      _isInterestSent = !_isInterestSent;
    });

    if (_isInterestSent) {
      print('====================================================');
      print('💌 [USER ACTION: SACRED INTEREST SENT]');
      print('   Candidate   : Dr. Priyadarshini Sundaram');
      print('   Alliance ID : TA-74345');
      print('   Status      : Notification & SMS Dispatched ✓');
      print('====================================================');

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sacred Interest Sent to Dr. Priyadarshini! Tap button again anytime to Unsend.',
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
    } else {
      print('====================================================');
      print('↩️ [USER ACTION: SACRED INTEREST UNSENT / WITHDRAWN]');
      print('   Candidate   : Dr. Priyadarshini Sundaram');
      print('   Alliance ID : TA-74345');
      print('   Status      : Interest Revoked Successfully');
      print('====================================================');

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.undo_rounded, color: Color(0xFFF59E0B), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sacred Interest withdrawn / unsent successfully.',
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

  void _handleShortlist() {
    setState(() {
      _isShortlisted = !_isShortlisted;
      _shortlistCount += _isShortlisted ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isShortlisted
              ? 'Dr. Priyadarshini added to your shortlisted matches.'
              : 'Dr. Priyadarshini removed from your shortlist.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleNextShortlist() {
    setState(() {
      _isNextShortlisted = !_isNextShortlisted;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isNextShortlisted ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
              color: _isNextShortlisted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _isNextShortlisted
                    ? 'Ananya Ramachandran added to your shortlist.'
                    : 'Ananya Ramachandran removed from shortlist.',
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
  }

  void _handleNextSendInterest() {
    setState(() {
      _isNextInterestSent = !_isNextInterestSent;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_isNextInterestSent) {
      print('====================================================');
      print('💌 [USER ACTION: SACRED INTEREST SENT TO NEXT MATCH]');
      print('   Candidate   : Ananya Ramachandran');
      print('   Status      : Dispatched ✓');
      print('====================================================');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Interest sent to Ananya! Tap button again anytime to Unsend.',
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
    } else {
      print('====================================================');
      print('↩️ [USER ACTION: INTEREST UNSENT FOR NEXT MATCH]');
      print('   Candidate   : Ananya Ramachandran');
      print('   Status      : Revoked / Unsent');
      print('====================================================');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.undo_rounded, color: Color(0xFFF59E0B), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Interest to Ananya withdrawn / unsent successfully.',
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

  void _showJathagamChakramModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Color(0xFF4338CA), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                             '12-House Rasi & Navamsam Chakram',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Dr. Priyadarshini Sundaram • 10 Porutham Analysis',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // Rasi Grid Visual
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'ராசி கட்டம் (Rasi Chart)',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF78350F)),
                            ),
                            const SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(color: const Color(0xFFD97706), width: 1.5),
                              children: [
                                TableRow(children: [
                                  _buildChakramCell('மீனம்\nபுதன்'),
                                  _buildChakramCell('மேஷம்\nசூரியன்'),
                                  _buildChakramCell('ரிஷபம்\nசுக்ரன்'),
                                  _buildChakramCell('மிதுனம்\nராகு'),
                                ]),
                                TableRow(children: [
                                  _buildChakramCell('கும்பம்'),
                                  Container(
                                    height: 54,
                                    color: const Color(0xFFFEF3C7),
                                    child: const Center(
                                      child: Text(
                                        'லக்னம்\nசிம்மம்',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 54,
                                    color: const Color(0xFFFEF3C7),
                                    child: const Center(
                                      child: Text(
                                        'ராசி:\nமகம் 2',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                                      ),
                                    ),
                                  ),
                                  _buildChakramCell('கடகம்\nசந்திரன்'),
                                ]),
                                TableRow(children: [
                                  _buildChakramCell('மகரம்\nசனி'),
                                  _buildChakramCell('தனுசு\nகுரு'),
                                  _buildChakramCell('விருச்சி\nகேது'),
                                  _buildChakramCell('கன்னி\nசெவ்வாய்'),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 10 Porutham Summary Table
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'பத்து பொருத்தங்கள் விவரம் (10 Porutham Results)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 10),
                            _buildPoruthamRow('1. தினப் பொருத்தம் (Dina)', 'உத்தமம் (Uthamam)', true),
                            _buildPoruthamRow('2. கணப் பொருத்தம் (Gana)', 'உத்தமம் (Uthamam)', true),
                            _buildPoruthamRow('3. மகேந்திரப் பொருத்தம் (Mahendra)', 'பொருத்தம் உண்டு', true),
                            _buildPoruthamRow('4. ஸ்திரீ தீர்க்கப் பொருத்தம் (Sthree)', 'உத்தமம்', true),
                            _buildPoruthamRow('5. யோனிப் பொருத்தம் (Yoni)', 'உத்தமம் (பகை இல்லை)', true),
                            _buildPoruthamRow('6. ராசிப் பொருத்தம் (Rasi)', 'சுபப் பொருத்தம்', true),
                            _buildPoruthamRow('7. ராசியாதிபதி பொருத்தம் (Adhipathi)', 'மித்ரு பாவம்', true),
                            _buildPoruthamRow('8. வசியப் பொருத்தம் (Vasya)', 'உண்டு', true),
                            _buildPoruthamRow('9. ரஜ்ஜுப் பொருத்தம் (Rajju)', 'உத்தமம் (சிரோ ரஜ்ஜு)', true),
                            _buildPoruthamRow('10. வேதைப் பொருத்தம் (Vedhai)', 'வேதை இல்லை', true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChakramCell(String text) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(2),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF451A03)),
        ),
      ),
    );
  }

  Widget _buildPoruthamRow(String title, String status, bool isMatch) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
          Row(
            children: [
              Icon(
                isMatch ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isMatch ? const Color(0xFF059669) : const Color(0xFFDC2626),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isMatch ? const Color(0xFF059669) : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Filter Pills Row
          _buildFilterPillsRow(),
          const SizedBox(height: 10),

          // 2. Search & Filter Bar
          _buildSearchFilterBar(),
          const SizedBox(height: 14),

          // 3. Main Hero Profile Card (Dr. Priyadarshini Sundaram)
          _buildMainProfileCard(),
          const SizedBox(height: 20),

          // 4. Next Auspicious Match in Queue
          _buildNextAuspiciousMatchSection(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Filter Pills Row (All, Uthama Match, Govt ID Verified, Mutual)
  // ─────────────────────────────────────────────────────────────
  Widget _buildFilterPillsRow() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (ctx, idx) {
          final filter = _filters[idx];
          final isSelected = _selectedFilterIndex == idx;
          final bool isSpecial = filter['isSpecial'] == true;

          return InkWell(
            onTap: () => setState(() => _selectedFilterIndex = idx),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF701A33)
                    : (isSpecial ? const Color(0xFFFFFBEB) : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF701A33)
                      : (isSpecial ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
                  width: 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFF701A33).withAlpha(40),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter['icon'] != null) ...[
                    Icon(
                      filter['icon'] as IconData,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : (isSpecial ? const Color(0xFFD97706) : const Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    filter['title'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isSpecial ? const Color(0xFF92400E) : const Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Search by ID & Filter Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildSearchFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          // Filter Button
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllianceFilterScreen(),
                ),
              );

              if (result != null && mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filters applied! Updating Alliance matches...',
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
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.tune_rounded, size: 14, color: Color(0xFF475569)),
                  SizedBox(width: 4),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Search Field
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                      decoration: const InputDecoration(
                        hintText: 'search by ID Number',
                        hintStyle: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
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
  // 3. Main Profile Card (Dr. Priyadarshini Sundaram)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMainProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3A. Hero Photo with Overlays
          _buildHeroPhotoWithOverlays(),

          // 3B. Details Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Active Today + Menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Flexible(
                            child: Text(
                              'Dr. Priyadarshini Sundaram',
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: 17.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Active Today',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6D28D9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert_rounded, size: 20, color: Color(0xFF64748B)),
                  ],
                ),
                const SizedBox(height: 6),

                // Degree & Age
                Text.rich(
                  TextSpan(
                    text: 'M.B.B.S, M.D. (Pediatrics)',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF701A33),
                    ),
                    children: const [
                      TextSpan(
                        text: ' • 26 Yrs, 5\' 5" (165 cm)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Job & Native
                const Text(
                  'Senior Resident Physician, Apollo Children\'s Hospital, Chennai • Native: Coimbatore',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),

                // 3C. Lineage Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: const [
                      Text(
                        'Lineage: ',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      _LineagePill(label: 'Kongu Vellalar'),
                      _LineagePill(label: 'Cheran Kulam'),
                      _LineagePill(label: 'Shiva Gothram'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 3D. Vedic Astrology Porutham Card
                _buildVedicAstrologyCard(),
                const SizedBox(height: 14),

                // 3E. Family Heritage & Background
                _buildFamilyHeritageCard(),
                const SizedBox(height: 16),

                // 3F. Action Buttons (Shortlist & Share)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _handleShortlist,
                        icon: Icon(
                          _isShortlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 15,
                          color: _isShortlisted ? const Color(0xFFE11D48) : const Color(0xFF6366F1),
                        ),
                        label: Text(
                          'Shortlist ($_shortlistCount)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: _isShortlisted ? const Color(0xFFE11D48) : const Color(0xFF4338CA),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEF2FF),
                          side: const BorderSide(color: Color(0xFFC7D2FE)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Biodata link copied to clipboard for sharing.'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share_outlined, size: 15, color: Color(0xFF0D9488)),
                        label: const Text(
                          'Share Biodata',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0FDFA),
                          side: const BorderSide(color: Color(0xFF99F6E4)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 3G. Send Sacred Interest Button (Toggles Send and Unsend)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleSendInterest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isInterestSent ? const Color(0xFF0F766E) : const Color(0xFF701A33),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isInterestSent ? Icons.undo_rounded : Icons.favorite_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _isInterestSent ? 'Interest Sent (Tap to Unsend)' : 'Send Sacred Interest',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _isInterestSent
                              ? 'Tap this button to withdraw / unsend your interest'
                              : 'Instant SMS & App notification sent to registered users',
                          style: const TextStyle(
                            fontSize: 8.5,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
  // 3A. Hero Photo with Overlays & Watermark
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroPhotoWithOverlays() {
    return Stack(
      children: [
        // Photo
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.asset(
            'assets/images/alliance_priyadarshini.jpg',
            height: 360,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (ctx, err, stack) => Image.asset(
              'assets/images/bride_portrait.jpg',
              height: 360,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),

        // Watermark in Center
        Positioned.fill(
          child: Center(
            child: Transform.rotate(
              angle: -0.2,
              child: Text(
                'Tamil Alliance ID-74345',
                style: TextStyle(
                  color: Colors.white.withAlpha(45),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),

        // Overlay Top-Left: 100% ID Verified
        Positioned(
          top: 12,
          left: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(235),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified_user_rounded, color: Color(0xFF0284C7), size: 12),
                    SizedBox(width: 4),
                    Text(
                      '100% ID Verified',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              // Overlay: Vedic Horoscope Match
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF701A33).withAlpha(230),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.auto_awesome, color: Color(0xFFFDE68A), size: 11),
                    SizedBox(width: 4),
                    Text(
                      'Vedic Horoscope Match',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Overlay Top-Right: 1/5 Photos
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt_outlined, color: Colors.white, size: 11),
                SizedBox(width: 4),
                Text(
                  '1/5 Photos',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3D. Vedic Astrology Porutham Card Container
  // ─────────────────────────────────────────────────────────────
  Widget _buildVedicAstrologyCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Vedic Astrology Porutham + 9/10 Matched
          Row(
            children: [
              const Icon(Icons.account_balance_rounded, size: 15, color: Color(0xFFB45309)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Vedic Astrology Porutham',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: const Text(
                  '9 / 10 Matched',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4338CA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Two White Boxes: Rasi & Nakshatram
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Rasi', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                      SizedBox(height: 2),
                      Text(
                        'Simha (Leo)',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Nakshatram', style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                      SizedBox(height: 2),
                      Text(
                        'Magham (Padam 2)',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Chevvai Dosham Status
          Row(
            children: const [
              Icon(Icons.check_circle_outline_rounded, size: 14, color: Color(0xFF059669)),
              SizedBox(width: 5),
              Text(
                'Chevvai Dosham: ',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
              ),
              Expanded(
                child: Text(
                  'No Dosham (செவ்வாய் தோஷம் இல்லை)',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rajju Porutham
          Row(
            children: const [
              Text(
                'Rajju Porutham: ',
                style: TextStyle(fontSize: 10.5, color: Color(0xFF475569)),
              ),
              Expanded(
                child: Text(
                  '★ Uthama / Supreme Match',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Porutham Check Pills
          Wrap(
            spacing: 6,
            runSpacing: 5,
            children: const [
              _PoruthamPill(title: '✓ Dina'),
              _PoruthamPill(title: '✓ Gana'),
              _PoruthamPill(title: '✓ Mahendra'),
              _PoruthamPill(title: '✓ Yoni'),
              _PoruthamPill(title: '✓ Rasi'),
              _PoruthamPill(title: '✓ Rasyadhipathi'),
              _PoruthamPill(title: '✓ Vasya'),
              _PoruthamPill(title: '✓ Vedhai'),
            ],
          ),
          const SizedBox(height: 10),

          // View Full 12-House Chakram Button
          InkWell(
            onTap: _showJathagamChakramModal,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Text(
                      'View Full 12-House Chakram & Jathagam',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4338CA),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF4338CA)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3E. Family Heritage & Background
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyHeritageCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.family_restroom_rounded, size: 16, color: Color(0xFFBE185D)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Family Heritage & Background',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildHeritageRow('Status:', 'Upper Middle Class • Nuclear Family'),
          _buildHeritageRow('Father:', 'Chief Civil Engineer (Retd. TNEB, Coimbatore)'),
          _buildHeritageRow('Mother:', 'Homemaker, MA Tamil Literature'),
          _buildHeritageRow('Siblings:', '1 Younger Brother (Software Architect, Bengaluru)'),
          const SizedBox(height: 8),

          // Lifestyle Pills
          Wrap(
            spacing: 6,
            runSpacing: 5,
            children: const [
              _LifestylePill(
                icon: Icons.eco_outlined,
                label: 'Vegetarian',
                color: Color(0xFF059669),
                bgColor: Color(0xFFECFDF5),
              ),
              _LifestylePill(
                icon: Icons.smoke_free_rounded,
                label: 'Non-Smoker',
                color: Color(0xFFDC2626),
                bgColor: Color(0xFFFEF2F2),
              ),
              _LifestylePill(
                icon: Icons.no_drinks_outlined,
                label: 'Non-Drinker',
                color: Color(0xFF7C3AED),
                bgColor: Color(0xFFF5F3FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeritageRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Next Auspicious Match in Queue (Ananya Ramachandran)
  // ─────────────────────────────────────────────────────────────
  Widget _buildNextAuspiciousMatchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
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
              const Expanded(
                child: Text(
                  'Next Auspicious Match in Queue',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '91% Match',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mini Card Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/home_samyuktha.jpg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    width: 64,
                    height: 64,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.person, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ananya Ramachandran',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'B.Tech, MBA • Senior Product Manager',
                      style: TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Google Bengaluru • 27 Yrs, 5\' 4"',
                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Kongu Vellalar • Sadayam Nakshatram',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _handleNextShortlist,
                  icon: Icon(
                    _isNextShortlisted ? Icons.bookmark_added_rounded : Icons.bookmark_border_rounded,
                    size: 15,
                    color: _isNextShortlisted ? const Color(0xFF701A33) : const Color(0xFF475569),
                  ),
                  label: Text(
                    _isNextShortlisted ? 'Shortlisted' : 'Shortlist',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: _isNextShortlisted ? const Color(0xFF701A33) : const Color(0xFF334155),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _isNextShortlisted ? const Color(0xFFFDF2F4) : Colors.white,
                    side: BorderSide(
                      color: _isNextShortlisted ? const Color(0xFF9E1B42) : const Color(0xFFCBD5E1),
                      width: _isNextShortlisted ? 1.2 : 1.0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _handleNextSendInterest,
                  icon: Icon(
                    _isNextInterestSent ? Icons.undo_rounded : Icons.favorite_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isNextInterestSent ? 'Sent (Unsend)' : 'Send Interest',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isNextInterestSent ? const Color(0xFF0F766E) : const Color(0xFF701A33),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sub-components
// ─────────────────────────────────────────────────────────────
class _LineagePill extends StatelessWidget {
  final String label;
  const _LineagePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF334155),
        ),
      ),
    );
  }
}

class _PoruthamPill extends StatelessWidget {
  final String title;
  const _PoruthamPill({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF047857),
        ),
      ),
    );
  }
}

class _LifestylePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _LifestylePill({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
