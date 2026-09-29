import 'package:flutter/material.dart';

class AllianceFilterScreen extends StatefulWidget {
  const AllianceFilterScreen({super.key});

  @override
  State<AllianceFilterScreen> createState() => _AllianceFilterScreenState();
}

class _AllianceFilterScreenState extends State<AllianceFilterScreen> {
  // ─── Filter State ───
  // 1. Age & Height
  RangeValues _ageRange = const RangeValues(21, 32);
  RangeValues _heightRange = const RangeValues(152, 183); // 5'0" (152cm) - 6'0" (183cm)

  // 2. Marital Status
  final Set<String> _selectedMaritalStatus = {'Never Married'};

  // 3. Mother Tongue
  final Set<String> _selectedMotherTongue = {'Tamil'};

  // 4. Religion, Caste & Gothram
  final List<String> _selectedSubCastes = [
    'Brahmin - Vadama',
    'Brahmin - Brahacharanam',
  ];
  bool _sagothramRestriction = true;
  final Set<String> _selectedGotras = {'Bharadwaja', 'Srivatsa', 'Haritha'};
  final List<String> _additionalGotras = ['Viswamitra', 'Kashyapa', 'Koundinya', 'Sadaayan'];

  // 5. Dosham / Chevvai Porutham
  final Set<String> _selectedDoshams = {'Chevvai / Manglik (செவ்வாய் தோஷம்)'};

  // 6. Location / Native Preference
  final Set<String> _selectedCountries = {'India'};
  final Set<String> _selectedStates = {'Tamil Nadu'};
  final Set<String> _selectedCities = {'Chennai', 'Coimbatore'};

  // 7. Education & Profession
  final Set<String> _selectedEducations = {'Doctor (MBBS/MD)'};
  final Set<String> _selectedProfessions = {'Doctor / Healthcare', 'IT / Software'};
  String _selectedIncome = '₹15L - ₹30L';

  // 8. Diet & Physical
  final Set<String> _selectedDiets = {'Pure Vegetarian'};
  String _selectedPhysicalStatus = 'Normal';

  // 9. Profile Badges
  final Set<String> _selectedBadges = {'100% ID Verified', 'Horoscope Available', 'Photo Only'};

  // 10. Porutham & Stars
  String _selectedPoruthamScore = '7+ / 10 Matched';
  final Set<String> _selectedStars = {'Rohini', 'Magam', 'Hastham', 'Uthiram'};

  // 11. Languages & Family
  final Set<String> _selectedLanguages = {'Tamil', 'English'};
  String _selectedFamilyValue = 'Traditional';
  String _selectedFamilyStatus = 'Upper Middle';

  // ─── Data Lists ───
  final List<String> _maritalOptions = ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce'];
  final List<String> _motherTongueOptions = ['Tamil', 'Telugu', 'Malayalam', 'Kannada', 'Hindi'];
  
  final List<String> _doshamOptions = [
    'Chevvai / Manglik (செவ்வாய் தோஷம்)',
    'Rahu-Ketu Dosham',
    'Sarpa Dosham',
    'No Dosham',
    'Doesn\'t Matter'
  ];

  final List<String> _countryOptions = ['India', 'USA', 'UAE / Gulf', 'Singapore', 'Malaysia', 'UK'];
  final List<String> _stateOptions = ['Tamil Nadu', 'Karnataka', 'Kerala', 'Maharashtra'];
  final List<String> _cityOptions = ['Chennai', 'Coimbatore', 'Madurai', 'Salem', 'Tiruppur', 'Erode', 'Tiruchirappalli', 'Bangalore'];

  final List<String> _educationOptions = [
    'Doctor (MBBS/MD)',
    'B.E / B.Tech',
    'MBA / PG',
    'CA / CS',
    'MS / M.Tech',
    'Any Graduate',
  ];

  final List<String> _professionOptions = [
    'Doctor / Healthcare',
    'IT / Software',
    'Civil Services',
    'Business',
    'Banking / Finance',
    'Govt Employee',
  ];

  final List<String> _incomeOptions = [
    '< ₹5L',
    '₹5L - ₹15L',
    '₹15L - ₹30L',
    '₹30L - ₹50L',
    '₹50L+',
  ];

  final List<String> _dietOptions = ['Pure Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan'];
  final List<String> _physicalOptions = ['Normal', 'Physically Challenged', 'Doesn\'t Matter'];
  final List<String> _badgeOptions = ['100% ID Verified', 'Horoscope Available', 'Photo Only', 'Active This Week'];
  final List<String> _poruthamScoreOptions = ['7+ / 10 Matched', '8+ / 10 Matched', '9+ / 10 Matched', 'Any Porutham'];
  
  final List<String> _starOptions = [
    'Ashwini', 'Rohini', 'Magam', 'Hastham', 'Uthiram', 'Thiruvonam', 'Swathi', 'Anusham', 'Revathi', 'Mirugaseerisham', 'Karthigai'
  ];

  final List<String> _languageOptions = ['Tamil', 'English', 'Telugu', 'Hindi', 'Malayalam'];
  final List<String> _familyValueOptions = ['Traditional', 'Moderate', 'Liberal', 'Orthodox'];
  final List<String> _familyStatusOptions = ['Middle Class', 'Upper Middle', 'Affluent'];

  // Advanced Gold Filters List
  final List<Map<String, dynamic>> _advancedGoldFilterItems = [
    {
      'title': '10 Porutham Deep Compatibility',
      'subtitle': 'Dina, Gana, Mahendra, Rasi, Rajju, Sthree, Yoni, Vasya, Veda',
      'icon': Icons.emoji_events_rounded,
    },
    {
      'title': 'Planetary Dasa Bukthi Matching',
      'subtitle': 'Analyze current & future running Dasa Bukthi compatibility',
      'icon': Icons.flare_rounded,
    },
    {
      'title': 'Annual Family Wealth & Property Worth',
      'subtitle': 'Filter profiles with family assets ₹1 Cr – ₹5 Cr+, Own House',
      'icon': Icons.account_balance_rounded,
    },
    {
      'title': 'Government / High-Ranking Officers Only',
      'subtitle': 'IAS, IPS, IRS, Class-1 Gazetted, PSU & State Govt Officers',
      'icon': Icons.military_tech_rounded,
    },
    {
      'title': 'Gothram & Ancestral Lineage Compatibility',
      'subtitle': 'Automatic Non-Sagaothiram & temple kulam validation',
      'icon': Icons.account_tree_rounded,
    },
    {
      'title': 'Own House & Real Estate Assets Criteria',
      'subtitle': 'Filter by owned independent houses, lands & commercial assets',
      'icon': Icons.home_work_rounded,
    },
    {
      'title': 'Permanent Resident (PR) / Green Card Filter',
      'subtitle': 'USA H1B/PR, Canada PR, Australia PR, UK Skilled Visa',
      'icon': Icons.flight_takeoff_rounded,
    },
    {
      'title': 'Top Tier Universities (IIT, IIM, AIIMS, Ivy League)',
      'subtitle': 'Premier institutions in India & Abroad',
      'icon': Icons.school_rounded,
    },
  ];

  String _formatHeight(double cm) {
    int totalInches = (cm / 2.54).round();
    int feet = totalInches ~/ 12;
    int inches = totalInches % 12;
    return '$feet\'0" (${cm.round()}cm)';
  }

  void _onResetAll() {
    setState(() {
      _ageRange = const RangeValues(21, 32);
      _heightRange = const RangeValues(152, 183);
      _selectedMaritalStatus.clear();
      _selectedMaritalStatus.add('Never Married');
      _selectedMotherTongue.clear();
      _selectedMotherTongue.add('Tamil');
      _selectedSubCastes.clear();
      _selectedSubCastes.addAll(['Brahmin - Vadama', 'Brahmin - Brahacharanam']);
      _sagothramRestriction = true;
      _selectedGotras.clear();
      _selectedGotras.addAll(['Bharadwaja', 'Srivatsa', 'Haritha']);
      _selectedDoshams.clear();
      _selectedDoshams.add('Chevvai / Manglik (செவ்வாய் தோஷம்)');
      _selectedCountries.clear();
      _selectedCountries.add('India');
      _selectedStates.clear();
      _selectedStates.add('Tamil Nadu');
      _selectedCities.clear();
      _selectedCities.addAll(['Chennai', 'Coimbatore']);
      _selectedEducations.clear();
      _selectedEducations.add('Doctor (MBBS/MD)');
      _selectedProfessions.clear();
      _selectedProfessions.addAll(['Doctor / Healthcare', 'IT / Software']);
      _selectedIncome = '₹15L - ₹30L';
      _selectedDiets.clear();
      _selectedDiets.add('Pure Vegetarian');
      _selectedPhysicalStatus = 'Normal';
      _selectedBadges.clear();
      _selectedBadges.addAll(['100% ID Verified', 'Horoscope Available', 'Photo Only']);
      _selectedPoruthamScore = '7+ / 10 Matched';
      _selectedStars.clear();
      _selectedStars.addAll(['Rohini', 'Magam', 'Hastham', 'Uthiram']);
      _selectedLanguages.clear();
      _selectedLanguages.addAll(['Tamil', 'English']);
      _selectedFamilyValue = 'Traditional';
      _selectedFamilyStatus = 'Upper Middle';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All filters reset to default'),
        backgroundColor: Color(0xFF64748B),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  int _calculateActiveCount() {
    int count = 2; // Age + Height
    count += _selectedMaritalStatus.length;
    count += _selectedMotherTongue.length;
    count += _selectedSubCastes.length;
    count += _selectedGotras.length;
    count += _selectedDoshams.length;
    count += _selectedCities.length;
    count += _selectedEducations.length;
    count += _selectedProfessions.length;
    count += 1; // income
    count += _selectedDiets.length;
    count += _selectedBadges.length;
    count += _selectedStars.length;
    return count;
  }

  void _showAddCustomDialog({required String title, required Function(String) onAdd}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF701A33))),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter name...',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          InkWell(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                onAdd(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF701A33),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _calculateActiveCount();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF701A33),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 22,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Search Filters &',
              style: TextStyle(
                fontFamily: 'serif',
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'Preferences',
              style: TextStyle(
                fontFamily: 'serif',
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: _onResetAll,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'Reset\nAll',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFE5B84B),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {},
            splashRadius: 20,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Sub-Header
            _buildSubHeader(),
            const SizedBox(height: 12),

            // Card 1: 1. Age Preference
            _buildAgePreferenceCard(),
            const SizedBox(height: 12),

            // Card 2: 2. Height Span
            _buildHeightSpanCard(),
            const SizedBox(height: 12),

            // Card 3: 3. Marital Status
            _buildMaritalStatusCard(),
            const SizedBox(height: 12),

            // Card 4: 4. Mother Tongue
            _buildMotherTongueCard(),
            const SizedBox(height: 12),

            // Card 5: 5. Religion, Caste & Gothram
            _buildReligionCasteGothramCard(),
            const SizedBox(height: 12),

            // Card 6: 6. Dosham / Chevvai Porutham
            _buildDoshamCard(),
            const SizedBox(height: 12),

            // Card 7: 7. Location / Native Preference
            _buildLocationCard(),
            const SizedBox(height: 12),

            // Card 8: 8. Education Qualification
            _buildEducationCard(),
            const SizedBox(height: 12),

            // Card 9: 9. Profession & Annual Income
            _buildProfessionIncomeCard(),
            const SizedBox(height: 12),

            // Card 10: 10. Diet Preference
            _buildDietCard(),
            const SizedBox(height: 12),

            // Card 11: 11. Physical Status
            _buildPhysicalStatusCard(),
            const SizedBox(height: 12),

            // Card 12: 12. Verified Profiles & Horoscope
            _buildProfileBadgesCard(),
            const SizedBox(height: 12),

            // Card 13: 13. Minimum Porutham Score
            _buildPoruthamScoreCard(),
            const SizedBox(height: 12),

            // Card 14: 14. Preferred Stars / Nakshatras
            _buildPreferredStarsCard(),
            const SizedBox(height: 12),

            // Card 15: 15. Languages Known
            _buildLanguagesCard(),
            const SizedBox(height: 12),

            // Card 16: 16. Family Values & Status
            _buildFamilyValuesStatusCard(),
            const SizedBox(height: 16),

            // Card 17: 👑 Advanced Match Filters (Golden Premium Card)
            _buildAdvancedMatchFiltersGoldenCard(),
            const SizedBox(height: 18),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(activeCount),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Top Sub-Header (Standard Alliance Filters)
  // ─────────────────────────────────────────────────────────────
  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 2, top: 4, bottom: 2),
      child: Row(
        children: const [
          Icon(Icons.tune_rounded, size: 18, color: Color(0xFF701A33)),
          SizedBox(width: 8),
          Text(
            'Standard Alliance Filters',
            style: TextStyle(
              fontFamily: 'serif',
              color: Color(0xFF701A33),
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 1: 1. Age Preference
  // ─────────────────────────────────────────────────────────────
  Widget _buildAgePreferenceCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.chair_alt_outlined, size: 18, color: Color(0xFF701A33)),
                  SizedBox(width: 8),
                  Text(
                    '1. Age Preference',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF2F4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_ageRange.start.round()} Yrs – ${_ageRange.end.round()} Yrs',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF701A33),
              inactiveTrackColor: const Color(0xFFEAE6E1),
              trackHeight: 3.5,
              rangeThumbShape: const HollowRangeSliderThumbShape(
                enabledThumbRadius: 8.5,
                borderWidth: 2.5,
                borderColor: Color(0xFF701A33),
                fillColor: Colors.white,
              ),
              overlayColor: const Color(0xFF701A33).withAlpha(30),
            ),
            child: RangeSlider(
              values: _ageRange,
              min: 18,
              max: 45,
              onChanged: (val) => setState(() => _ageRange = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('18 Yrs', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                Text(
                  'Selected: ${_ageRange.start.round()}–${_ageRange.end.round()} Yrs',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                const Text('45+ Yrs', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 2: 2. Height Span
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeightSpanCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.straighten_rounded, size: 18, color: Color(0xFF701A33)),
                  SizedBox(width: 8),
                  Text(
                    '2. Height Span',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3EF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '5\'0" (${_heightRange.start.round()}cm) – 6\'0" (${_heightRange.end.round()}cm)',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF701A33),
              inactiveTrackColor: const Color(0xFFEAE6E1),
              trackHeight: 3.5,
              rangeThumbShape: const HollowRangeSliderThumbShape(
                enabledThumbRadius: 8.5,
                borderWidth: 2.5,
                borderColor: Color(0xFF701A33),
                fillColor: Colors.white,
              ),
              overlayColor: const Color(0xFF701A33).withAlpha(30),
            ),
            child: RangeSlider(
              values: _heightRange,
              min: 137,
              max: 198,
              onChanged: (val) => setState(() => _heightRange = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('4\'6" (137cm)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                Text('6\'6"+ (198cm)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 3: 3. Marital Status
  // ─────────────────────────────────────────────────────────────
  Widget _buildMaritalStatusCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '3. Marital Status',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _maritalOptions.map((opt) {
              final isSel = _selectedMaritalStatus.contains(opt);
              return _buildPillChip(
                label: opt,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedMaritalStatus.length > 1) _selectedMaritalStatus.remove(opt);
                    } else {
                      _selectedMaritalStatus.add(opt);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 4: 4. Mother Tongue
  // ─────────────────────────────────────────────────────────────
  Widget _buildMotherTongueCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '4. Mother Tongue',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _motherTongueOptions.map((opt) {
              final isSel = _selectedMotherTongue.contains(opt);
              return _buildPillChip(
                label: opt,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedMotherTongue.length > 1) _selectedMotherTongue.remove(opt);
                    } else {
                      _selectedMotherTongue.add(opt);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 5: 5. Religion, Caste & Gothram (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildReligionCasteGothramCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.temple_hindu_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '5. Religion, Caste & Gothram',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Box 1: Sub-caste Preferences
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF2EDE6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sub-caste Preferences:',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._selectedSubCastes.map((subCaste) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedSubCastes.remove(subCaste);
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCEEEF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                subCaste,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF701A33),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.close_rounded, size: 14, color: Color(0xFF701A33)),
                            ],
                          ),
                        ),
                      );
                    }),
                    InkWell(
                      onTap: () {
                        _showAddCustomDialog(
                          title: 'Add Sub-caste / Caste',
                          onAdd: (name) {
                            setState(() {
                              if (!_selectedSubCastes.contains(name)) _selectedSubCastes.add(name);
                            });
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E0D8)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add_rounded, size: 14, color: Color(0xFF701A33)),
                            SizedBox(width: 4),
                            Text(
                              'Add Caste',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF701A33),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Box 2: Sagothram Restriction
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF2EDE6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sagothram Restriction',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Auto-exclude own gotra (Kaundinya) per Vedic shastras',
                        style: TextStyle(fontSize: 10.5, color: Color(0xFF78716C)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _sagothramRestriction = !_sagothramRestriction),
                  child: Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _sagothramRestriction ? const Color(0xFF701A33) : const Color(0xFFD6D3D1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Section 3: Accepted Gotras
          const Text(
            'Accepted Gotras:',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._selectedGotras.map((gotra) {
                return _buildPillChip(
                  label: gotra,
                  isSelected: true,
                  onTap: () {
                    setState(() {
                      _selectedGotras.remove(gotra);
                      if (!_additionalGotras.contains(gotra)) _additionalGotras.add(gotra);
                    });
                  },
                );
              }),
              ..._additionalGotras.map((gotra) {
                return _buildPillChip(
                  label: '+ $gotra',
                  isSelected: false,
                  onTap: () {
                    setState(() {
                      _additionalGotras.remove(gotra);
                      _selectedGotras.add(gotra);
                    });
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 6: Dosham / Chevvai Porutham
  // ─────────────────────────────────────────────────────────────
  Widget _buildDoshamCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '6. Dosham / Chevvai Porutham',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _doshamOptions.map((d) {
              final isSel = _selectedDoshams.contains(d);
              return _buildPillChip(
                label: d,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedDoshams.length > 1) _selectedDoshams.remove(d);
                    } else {
                      _selectedDoshams.add(d);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 7: Location / Native Preference
  // ─────────────────────────────────────────────────────────────
  Widget _buildLocationCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '7. Location / Native Preference',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Country', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _countryOptions.map((cnt) {
              final isSel = _selectedCountries.contains(cnt);
              return _buildPillChip(
                label: cnt,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedCountries.length > 1) _selectedCountries.remove(cnt);
                    } else {
                      _selectedCountries.add(cnt);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Text('State', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _stateOptions.map((st) {
              final isSel = _selectedStates.contains(st);
              return _buildPillChip(
                label: st,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedStates.length > 1) _selectedStates.remove(st);
                    } else {
                      _selectedStates.add(st);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Text('Preferred Cities / Districts', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._cityOptions.map((city) {
                final isSel = _selectedCities.contains(city);
                return _buildPillChip(
                  label: city,
                  isSelected: isSel,
                  onTap: () {
                    setState(() {
                      if (isSel) {
                        _selectedCities.remove(city);
                      } else {
                        _selectedCities.add(city);
                      }
                    });
                  },
                );
              }),
              _buildAddButton(
                label: '+ Add City',
                onTap: () {
                  _showAddCustomDialog(
                    title: 'Add Preferred City',
                    onAdd: (name) {
                      setState(() {
                        if (!_cityOptions.contains(name)) _cityOptions.add(name);
                        _selectedCities.add(name);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 8: Education Qualification
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.school_outlined, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '8. Education Qualification',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._educationOptions.map((edu) {
                final isSel = _selectedEducations.contains(edu);
                return _buildPillChip(
                  label: edu,
                  isSelected: isSel,
                  onTap: () {
                    setState(() {
                      if (isSel) {
                        _selectedEducations.remove(edu);
                      } else {
                        _selectedEducations.add(edu);
                      }
                    });
                  },
                );
              }),
              _buildAddButton(
                label: '+ Add Degree',
                onTap: () {
                  _showAddCustomDialog(
                    title: 'Add Education Degree',
                    onAdd: (name) {
                      setState(() {
                        if (!_educationOptions.contains(name)) _educationOptions.add(name);
                        _selectedEducations.add(name);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 9: Profession & Annual Income
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfessionIncomeCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.work_outline_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '9. Profession & Annual Income',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Profession / Sector', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _professionOptions.map((prof) {
              final isSel = _selectedProfessions.contains(prof);
              return _buildPillChip(
                label: prof,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      _selectedProfessions.remove(prof);
                    } else {
                      _selectedProfessions.add(prof);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Annual Income Range', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _incomeOptions.map((inc) {
              final isSel = _selectedIncome == inc;
              return _buildPillChip(
                label: inc,
                isSelected: isSel,
                onTap: () => setState(() => _selectedIncome = inc),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 10: Diet Preference
  // ─────────────────────────────────────────────────────────────
  Widget _buildDietCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.restaurant_outlined, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '10. Diet Preference',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dietOptions.map((d) {
              final isSel = _selectedDiets.contains(d);
              return _buildPillChip(
                label: d,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedDiets.length > 1) _selectedDiets.remove(d);
                    } else {
                      _selectedDiets.add(d);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 11: Physical Status
  // ─────────────────────────────────────────────────────────────
  Widget _buildPhysicalStatusCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.accessibility_new_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '11. Physical Status',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _physicalOptions.map((opt) {
              final isSel = _selectedPhysicalStatus == opt;
              return _buildPillChip(
                label: opt,
                isSelected: isSel,
                onTap: () => setState(() => _selectedPhysicalStatus = opt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 12: Profile Badges & Verification
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileBadgesCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.verified_user_outlined, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '12. Verified Profiles & Horoscope',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _badgeOptions.map((b) {
              final isSel = _selectedBadges.contains(b);
              return _buildPillChip(
                label: b,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      _selectedBadges.remove(b);
                    } else {
                      _selectedBadges.add(b);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 13: 10 Porutham Score
  // ─────────────────────────────────────────────────────────────
  Widget _buildPoruthamScoreCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.stars_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '13. Minimum Porutham Score',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _poruthamScoreOptions.map((score) {
              final isSel = _selectedPoruthamScore == score;
              return _buildPillChip(
                label: score,
                isSelected: isSel,
                onTap: () => setState(() => _selectedPoruthamScore = score),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 14: Preferred Stars / Nakshatras
  // ─────────────────────────────────────────────────────────────
  Widget _buildPreferredStarsCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.brightness_5_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '14. Preferred Nakshatras (நட்சத்திரம்)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _starOptions.map((star) {
              final isSel = _selectedStars.contains(star);
              return _buildPillChip(
                label: star,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      _selectedStars.remove(star);
                    } else {
                      _selectedStars.add(star);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 15: Languages Known
  // ─────────────────────────────────────────────────────────────
  Widget _buildLanguagesCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.language_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '15. Languages Known',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languageOptions.map((lang) {
              final isSel = _selectedLanguages.contains(lang);
              return _buildPillChip(
                label: lang,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedLanguages.length > 1) _selectedLanguages.remove(lang);
                    } else {
                      _selectedLanguages.add(lang);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 16: Family Values & Status
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyValuesStatusCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.family_restroom_rounded, size: 18, color: Color(0xFF701A33)),
              SizedBox(width: 8),
              Text(
                '16. Family Values & Status',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Family Values', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _familyValueOptions.map((val) {
              final isSel = _selectedFamilyValue == val;
              return _buildPillChip(
                label: val,
                isSelected: isSel,
                onTap: () => setState(() => _selectedFamilyValue = val),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          const Text('Family Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _familyStatusOptions.map((st) {
              final isSel = _selectedFamilyStatus == st;
              return _buildPillChip(
                label: st,
                isSelected: isSel,
                onTap: () => setState(() => _selectedFamilyStatus = st),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 17: 👑 Advanced Match Filters (Golden Premium Box)
  // ─────────────────────────────────────────────────────────────
  Widget _buildAdvancedMatchFiltersGoldenCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5B84B), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14D97706),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.workspace_premium_rounded, color: Color(0xFFB45309), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Advanced Match Filters 👑',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF78350F),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: const Text(
                  '👑 PREMIUM ONLY',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Unlock deeper compatibility filters to discover soulmate matches with 100% precision.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF92400E),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // Advanced Feature Items
          ...List.generate(_advancedGoldFilterItems.length, (idx) {
            final item = _advancedGoldFilterItems[idx];

            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('👑 "${item['title']}" is unlocked with Tamil Alliance Gold/Diamond Plan.'),
                    backgroundColor: const Color(0xFF701A33),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, size: 20, color: const Color(0xFFD97706)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['subtitle'] as String,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.lock_outline_rounded, size: 16, color: Color(0xFFD97706)),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // Gold CTA Callout Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
            ),
            child: Column(
              children: [
                const Icon(Icons.verified_rounded, size: 28, color: Color(0xFFD97706)),
                const SizedBox(height: 6),
                const Text(
                  'Unlock All High-Precision Gold Filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF78350F),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Get access to advanced horoscope matching, property filters, overseas PR status & top elite family matches.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF92400E), height: 1.3),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Redirecting to Tamil Alliance Premium Membership...'),
                        backgroundColor: Color(0xFF701A33),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF701A33),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFF3D27C)),
                        SizedBox(width: 6),
                        Text(
                          '⚡ Activate Gold Filter Access',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Starting at ₹999/month • Cancel Anytime',
                  style: TextStyle(fontSize: 9.5, color: Color(0xFFB45309), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Bottom Sticky Action Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomActionBar(int activeCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$activeCount Filters Applied',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Found 148 Matches',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context, {
                    'activeCount': activeCount,
                    'ageRange': _ageRange,
                    'subCastes': _selectedSubCastes,
                  });
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: const Color(0xFF701A33),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF701A33).withAlpha(50),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Apply Filters (148)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
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
  // Shared Helper Widgets & Styles
  // ─────────────────────────────────────────────────────────────
  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPillChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF701A33) : const Color(0xFFF3EFEA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF5C5854),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFB4C4), style: BorderStyle.solid),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF701A33),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Custom Hollow Ring Range Slider Thumb Shape
// ─────────────────────────────────────────────────────────────
class HollowRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double borderWidth;
  final Color borderColor;
  final Color fillColor;

  const HollowRangeSliderThumbShape({
    this.enabledThumbRadius = 8.5,
    this.borderWidth = 2.5,
    this.borderColor = const Color(0xFF701A33),
    this.fillColor = Colors.white,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    // Outer circle (Maroon Border)
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);

    // Inner circle (White fill)
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius - borderWidth, fillPaint);
  }
}
