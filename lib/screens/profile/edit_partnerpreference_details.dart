import 'package:flutter/material.dart';

class EditPartnerPreferenceDetailsScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? profileFor;

  const EditPartnerPreferenceDetailsScreen({
    super.key,
    this.mobileNumber,
    this.profileFor,
  });

  @override
  State<EditPartnerPreferenceDetailsScreen> createState() => _EditPartnerPreferenceDetailsScreenState();
}

class _EditPartnerPreferenceDetailsScreenState extends State<EditPartnerPreferenceDetailsScreen> {
  // 1. Basic & Physical Criteria
  RangeValues _ageRange = const RangeValues(23, 28);
  RangeValues _heightRange = const RangeValues(152, 170); // in cm: 152 = 5'0", 170 = 5'7"

  String? _maritalStatus;
  String? _childrenStatus;

  bool get _requiresChildrenSelection =>
      _maritalStatus == 'Divorced' ||
      _maritalStatus == 'Awaiting Divorce' ||
      _maritalStatus == 'Widowed' ||
      _maritalStatus == 'Annulled';

  String? _selectedMotherTongue;
  final List<String> _motherTongues = [
    'Tamil (தமிழ்)',
    'Telugu (తెలుగు)',
    'Malayalam (മലയാളം)',
    'Kannada (ಕನ್ನಡ)',
    'Hindi (हिंदी)',
    'Any / Doesn\'t Matter',
  ];

  // 2. Religion & Community
  String? _selectedReligion;
  final List<String> _religionOptions = ['Hindu', 'Christian', 'Muslim', 'Any / Doesn\'t Matter'];

  final List<String> _casteOptions = [
    'Vanniyar',
    'Brahmin',
    'Mudaliar',
    'Pillai',
    'Kongu Vellalar',
    'Nadar',
    'Chettiar',
    'Naidu',
  ];
  final Set<String> _customCastes = {};
  final Set<String> _selectedCastes = {};

  String? _selectedDoshamType;
  bool _isSpecificDoshamsExpanded = true;
  final List<String> _doshamTypeOptions = ['Dosham Only', 'No Dosham', 'Doesn\'t Matter'];

  final List<String> _employmentSectorOptions = [
    'Private / MNC',
    'Govt / Public Sector',
    'Business / Entrepreneur',
    'Civil Services',
    'Self Employed',
    'Defense',
    'Not Working',
  ];
  final Set<String> _selectedEmploymentSectors = {};

  final List<String> _specificDoshams = [
    'Chevvai / Manglik (செவ்வாய் தோஷம்)',
    'Rahu-Ketu Dosham (ராகu-கேது தோஷம்)',
    'Kalathra Dosham (களத்திர தோஷம்)',
    'Sarpa Dosham (சர்ப்ப தோஷம்)',
  ];
  final Set<String> _selectedSpecificDoshams = {};

  final Set<String> _selectedLocations = {};
  final TextEditingController _locationSearchController = TextEditingController();

  // 3. Education, Career & Income
  final List<String> _educationOptions = [
    'B.Tech / B.E',
    'M.S / M.Tech',
    'MBA / PG',
    'MBBS / MD',
    'CA / CS',
    'Any Graduate',
  ];
  final Set<String> _customEducations = {};
  final Set<String> _selectedEducation = {};

  String? _minIncome;
  String? _maxIncome;
  final List<String> _incomeList = [
    '₹5 Lakhs / yr',
    '₹10 Lakhs / yr',
    '₹15 Lakhs / yr',
    '₹25 Lakhs / yr',
    '₹40 Lakhs / yr',
    '₹60 Lakhs+ / yr',
  ];

  // 4. Dietary Habits
  final Set<String> _selectedDiet = {};

  // 5. Physical Status
  String? _selectedPhysicalStatus;

  @override
  void dispose() {
    _locationSearchController.dispose();
    super.dispose();
  }

  String _formatHeight(double cm) {
    int totalInches = (cm / 2.54).round();
    int feet = totalInches ~/ 12;
    int inches = totalInches % 12;
    return '$feet\'$inches" (${cm.round()}cm)';
  }

  void _onResetAll() {
    setState(() {
      _ageRange = const RangeValues(20, 35);
      _heightRange = const RangeValues(137, 193);
      _maritalStatus = null;
      _childrenStatus = null;
      _selectedMotherTongue = null;
      _selectedReligion = null;
      _selectedCastes.clear();
      _selectedDoshamType = null;
      _isSpecificDoshamsExpanded = true;
      _selectedSpecificDoshams.clear();
      _selectedLocations.clear();
      _selectedEducation.clear();
      _selectedEmploymentSectors.clear();
      _minIncome = null;
      _maxIncome = null;
      _selectedDiet.clear();
      _selectedPhysicalStatus = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences reset'),
        backgroundColor: Color(0xFF64748B),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  void _editCaste(String oldName) {
    _showEditCustomItemDialog(
      title: 'Edit Community / Caste',
      currentName: oldName,
      onEdited: (newName) {
        setState(() {
          final index = _casteOptions.indexOf(oldName);
          if (index != -1) {
            _casteOptions[index] = newName;
          }
          _customCastes.remove(oldName);
          _customCastes.add(newName);
          if (_selectedCastes.contains(oldName)) {
            _selectedCastes.remove(oldName);
            _selectedCastes.add(newName);
          }
        });
      },
      onDeleted: () => _deleteCaste(oldName),
    );
  }

  void _deleteCaste(String name) {
    setState(() {
      _casteOptions.remove(name);
      _customCastes.remove(name);
      _selectedCastes.remove(name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name removed'),
        backgroundColor: const Color(0xFF881337),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  void _editEducation(String oldName) {
    _showEditCustomItemDialog(
      title: 'Edit Education Degree',
      currentName: oldName,
      onEdited: (newName) {
        setState(() {
          final index = _educationOptions.indexOf(oldName);
          if (index != -1) {
            _educationOptions[index] = newName;
          }
          _customEducations.remove(oldName);
          _customEducations.add(newName);
          if (_selectedEducation.contains(oldName)) {
            _selectedEducation.remove(oldName);
            _selectedEducation.add(newName);
          }
        });
      },
      onDeleted: () => _deleteEducation(oldName),
    );
  }

  void _deleteEducation(String name) {
    setState(() {
      _educationOptions.remove(name);
      _customEducations.remove(name);
      _selectedEducation.remove(name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name removed'),
        backgroundColor: const Color(0xFF881337),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  void _onApplyPreferences() {
    print('====================================================');
    print('💖 [USER INPUT: EDIT PARTNER PREFERENCES]');
    print('   Age Range       : ${_ageRange.start.round()} - ${_ageRange.end.round()} yrs');
    print('   Height Range    : ${_formatHeight(_heightRange.start)} to ${_formatHeight(_heightRange.end)}');
    print('   Marital Status  : $_maritalStatus ($_childrenStatus)');
    print('   Mother Tongue   : $_selectedMotherTongue');
    print('   Religion        : $_selectedReligion');
    print('   Castes          : $_selectedCastes');
    print('   Dosham Type     : $_selectedDoshamType');
    print('   Specific Dosham : $_selectedSpecificDoshams');
    print('   Preferred Places: $_selectedLocations');
    print('   Education       : $_selectedEducation');
    print('   Employment      : $_selectedEmploymentSectors');
    print('   Income Range    : $_minIncome to $_maxIncome');
    print('   Diet Preference : $_selectedDiet');
    print('   Physical Status : $_selectedPhysicalStatus');
    print('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Partner preferences updated successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeader(),
            const SizedBox(height: 12),
            _buildBasicPhysicalCard(),
            const SizedBox(height: 12),
            _buildMaritalStatusCard(),
            const SizedBox(height: 12),
            _buildMotherTongueCard(),
            const SizedBox(height: 12),
            _buildReligionCommunityCard(),
            const SizedBox(height: 12),
            _buildDoshamCard(),
            const SizedBox(height: 12),
            _buildPreferredLocationsCard(),
            const SizedBox(height: 12),
            _buildEducationCareerIncomeCard(),
            const SizedBox(height: 12),
            _buildCareerProfessionCard(),
            const SizedBox(height: 12),
            _buildAnnualIncomeCard(),
            const SizedBox(height: 12),
            _buildDietaryHabitsCard(),
            const SizedBox(height: 12),
            _buildPhysicalStatusCard(),
            const SizedBox(height: 12),
            _buildPlatformOverviewBanner(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top Custom App Bar
  // ─────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: const Color(0xFF701A31),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Partner Preferences',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _onResetAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
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
  // 1. Top Sub-Header Tracker
  // ─────────────────────────────────────────────────────────────
  Widget _buildSubHeader() {
    return const Row(
      children: [
        Icon(Icons.circle, size: 6, color: Color(0xFF881337)),
        SizedBox(width: 6),
        Text(
          'PARTNER PREFERENCES',
          style: TextStyle(
            color: Color(0xFF881337),
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Card 1: Basic & Physical Criteria
  // ─────────────────────────────────────────────────────────────
  Widget _buildBasicPhysicalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon & Tamil Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.person_outline_rounded, size: 18, color: Color(0xFF7C3AED)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Basic & Physical Criteria',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'அடிப்படை & உடல் தகுதி',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Age Span
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Age Span',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_ageRange.start.round()} yrs — ${_ageRange.end.round()} yrs',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF881337)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF881337),
              inactiveTrackColor: const Color(0xFFDBEAFE),
              trackHeight: 4.5,
              thumbColor: const Color(0xFF881337),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 7,
                elevation: 2,
              ),
              overlayColor: const Color(0xFF881337).withOpacity(0.15),
            ),
            child: RangeSlider(
              values: _ageRange,
              min: 20,
              max: 35,
              onChanged: (values) {
                setState(() {
                  _ageRange = values;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('20 yrs', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                Text('35 yrs', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Height Span
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Height Span',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_formatHeight(_heightRange.start)} — ${_formatHeight(_heightRange.end)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF881337)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF881337),
              inactiveTrackColor: const Color(0xFFDBEAFE),
              trackHeight: 4.5,
              thumbColor: const Color(0xFF881337),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 7,
                elevation: 2,
              ),
              overlayColor: const Color(0xFF881337).withOpacity(0.15),
            ),
            child: RangeSlider(
              values: _heightRange,
              min: 137,
              max: 193,
              onChanged: (values) {
                setState(() {
                  _heightRange = values;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('4\'6" (137cm)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                Text('6\'4" (193cm)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Card 2: Marital Status (Exact Step 1 Model)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMaritalStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Marital Status',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '*',
                    style: TextStyle(
                      color: Color(0xFFE11D48),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (_maritalStatus != null && _requiresChildrenSelection)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _maritalStatus = null;
                      _childrenStatus = null;
                    });
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // If Awaiting Divorce, Widowed, Annulled, or Divorced is selected -> show selected bar & 3 radio buttons for children
          if (_requiresChildrenSelection) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF701A33),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF701A33).withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _maritalStatus!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3 Custom Radio Buttons for Children
            Row(
              children: [
                Expanded(
                  child: _buildCustomRadioButton('Living with Children'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCustomRadioButton('No Children'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCustomRadioButton('Living without Children', isFullWidth: true),
          ] else ...[
            // All 5 base options visible
            Row(
              children: [
                Expanded(child: _buildMaritalChip('Never Married')),
                const SizedBox(width: 8),
                Expanded(child: _buildMaritalChip('Awaiting Divorce')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildMaritalChip('Annulled')),
                const SizedBox(width: 8),
                Expanded(child: _buildMaritalChip('Widowed')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildMaritalChip('Divorced')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMaritalChip(String status) {
    final isSelected = _maritalStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _maritalStatus = status;
          if (!_requiresChildrenSelection) {
            _childrenStatus = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF701A33) : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE0E7FF),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRadioButton(String label, {bool isFullWidth = false}) {
    final isSelected = _childrenStatus == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _childrenStatus = label;
        });
      },
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCE7F3) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFF94A3B8),
                  width: isSelected ? 4 : 1.5,
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFFBE123C) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Card 3: Mother Tongue
  // ─────────────────────────────────────────────────────────────
  Widget _buildMotherTongueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Mother Tongue',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFBE123C)),
                  ),
                ],
              ),
              const Text(
                'தாய்மொழி',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF881337)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMotherTongue,
                hint: const Row(
                  children: [
                    Icon(Icons.translate_rounded, size: 16, color: Color(0xFF475569)),
                    SizedBox(width: 8),
                    Text(
                      'Select Mother Tongue',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF475569)),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
                items: _motherTongues.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Row(
                      children: [
                        const Icon(Icons.translate_rounded, size: 16, color: Color(0xFF475569)),
                        const SizedBox(width: 8),
                        Text(lang),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedMotherTongue = val;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Card 4: Religion & Community
  // ─────────────────────────────────────────────────────────────
  Widget _buildReligionCommunityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Temple Icon & Tamil Subtitle
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_rounded, size: 18, color: Color(0xFF881337)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Religion & Community',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'மதம் & சமூகம்',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Religion
          const Text(
            'Religion',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _religionOptions.map((rel) {
              final isSelected = _selectedReligion == rel;
              return _buildSelectableChip(
                label: rel,
                isSelected: isSelected,
                showCheck: isSelected,
                onTap: () {
                  setState(() {
                    _selectedReligion = rel;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Community & Sub-Caste
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Community & Sub-Caste',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(Tamil Nadu)',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Text(
                '${_selectedCastes.length} of 12 Selected',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._casteOptions.map((caste) {
                final isSelected = _selectedCastes.contains(caste);
                final isCustom = _customCastes.contains(caste);
                return _buildSelectableChip(
                  label: caste,
                  isSelected: isSelected,
                  showCheck: isSelected,
                  isCustom: isCustom,
                  onEdit: isCustom ? () => _editCaste(caste) : null,
                  onDelete: isCustom ? () => _deleteCaste(caste) : null,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedCastes.remove(caste);
                      } else {
                        _selectedCastes.add(caste);
                      }
                    });
                  },
                );
              }),
              _buildAddButton('+ Add More Community / Caste', () {
                _showAddCustomItemDialog('Add Community / Caste', (val) {
                  setState(() {
                    _casteOptions.add(val);
                    _customCastes.add(val);
                    _selectedCastes.add(val);
                  });
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Card 5: Dosham
  // ─────────────────────────────────────────────────────────────
  Widget _buildDoshamCard() {
    final int selectedCount = _selectedDoshamType == 'Dosham Only'
        ? _selectedSpecificDoshams.length
        : (_selectedDoshamType != null ? 1 : 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dosham (தோஷம்)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$selectedCount Selected',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF881337)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3 Main Dosham Options
          Row(
            children: _doshamTypeOptions.map((type) {
              final isSelected = _selectedDoshamType == type;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildSelectableChip(
                    label: type,
                    isSelected: isSelected,
                    showCheck: isSelected,
                    isCenter: true,
                    onTap: () {
                      setState(() {
                        _selectedDoshamType = type;
                        if (type == 'Dosham Only') {
                          _isSpecificDoshamsExpanded = true;
                        }
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          ),

          // Specific Doshams Accordion Card - ONLY visible when "Dosham Only" is selected
          if (_selectedDoshamType == 'Dosham Only') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isSpecificDoshamsExpanded = !_isSpecificDoshamsExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome_rounded, size: 14, color: Color(0xFF881337)),
                              const SizedBox(width: 6),
                              const Text(
                                'Specific Doshams',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4E6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${_selectedSpecificDoshams.length} Doshams',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF881337)),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            _isSpecificDoshamsExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: const Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isSpecificDoshamsExpanded) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'Select applicable dosham filters',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _specificDoshams.map((d) {
                        final isSelected = _selectedSpecificDoshams.contains(d);
                        return _buildSelectableChip(
                          label: d,
                          isSelected: isSelected,
                          showCheck: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedSpecificDoshams.remove(d);
                              } else {
                                _selectedSpecificDoshams.add(d);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Card 6: Preferred Locations
  // ─────────────────────────────────────────────────────────────
  Widget _buildPreferredLocationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Preferred Locations',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(விருப்பமான இடங்கள்)',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Text(
                '${_selectedLocations.length} Selected',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _locationSearchController,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Search Country, State, City... (e.g. Chennai, Coim',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: Icon(Icons.search_rounded, size: 16, color: Color(0xFF64748B)),
                prefixIconConstraints: BoxConstraints(minWidth: 28, minHeight: 28),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 11),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  setState(() {
                    _selectedLocations.add(val.trim());
                    _locationSearchController.clear();
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Selected places',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _selectedLocations.map((loc) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _selectedLocations.remove(loc);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF701A33),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          loc,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.close_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Card 7: Education
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCareerIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Cap Icon & Tamil Subtitle
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.school_outlined, size: 18, color: Color(0xFF1D4ED8)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Education, Career & Income',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'கல்வி & வருமானம்',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Highest Qualification
          const Text(
            'Highest Qualification',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._educationOptions.map((edu) {
                final isSelected = _selectedEducation.contains(edu);
                final isCustom = _customEducations.contains(edu);
                return _buildSelectableChip(
                  label: edu,
                  isSelected: isSelected,
                  showCheck: isSelected,
                  isCustom: isCustom,
                  onEdit: isCustom ? () => _editEducation(edu) : null,
                  onDelete: isCustom ? () => _deleteEducation(edu) : null,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedEducation.remove(edu);
                      } else {
                        _selectedEducation.add(edu);
                      }
                    });
                  },
                );
              }),
              _buildAddButton('+ Add More Education', () {
                _showAddCustomItemDialog('Add Education Degree', (val) {
                  setState(() {
                    _educationOptions.add(val);
                    _customEducations.add(val);
                    _selectedEducation.add(val);
                  });
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Card 7b: Career & Profession
  // ─────────────────────────────────────────────────────────────
  Widget _buildCareerProfessionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.circle, size: 6, color: Color(0xFF881337)),
              SizedBox(width: 6),
              Text(
                'Career & Profession',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Employment Sector',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _employmentSectorOptions.map((sec) {
              final isSelected = _selectedEmploymentSectors.contains(sec);
              return _buildSelectableChip(
                label: sec,
                isSelected: isSelected,
                showCheck: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedEmploymentSectors.remove(sec);
                    } else {
                      _selectedEmploymentSectors.add(sec);
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
  // 8. Card 7c: Annual Income Range
  // ─────────────────────────────────────────────────────────────
  Widget _buildAnnualIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Annual Income Range Header with Tamil Subtitle & Pink Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Annual Income Range',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  SizedBox(height: 1),
                  Text(
                    '(ஆண்டு வருமான வரம்பு)',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (_minIncome != null && _maxIncome != null)
                      ? '$_minIncome – $_maxIncome'
                      : (_minIncome != null ? 'From $_minIncome' : (_maxIncome != null ? 'Up to $_maxIncome' : '₹15L – ₹40L')),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF881337)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Minimum Income', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _minIncome,
                          hint: const Text('Select Min', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF475569)),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                          items: _incomeList.map((inc) => DropdownMenuItem(value: inc, child: Text(inc))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _minIncome = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Maximum Income', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _maxIncome,
                          hint: const Text('Select Max', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF475569)),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                          items: _incomeList.map((inc) => DropdownMenuItem(value: inc, child: Text(inc))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _maxIncome = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            (_minIncome != null && _maxIncome != null)
                ? 'Filtering matches earning $_minIncome – $_maxIncome per annum.'
                : 'Filtering matches earning ₹15L – ₹40L per annum.',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Card 8: Dietary Habits
  // ─────────────────────────────────────────────────────────────
  Widget _buildDietaryHabitsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dietary Habits',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDietPill(
                  label: 'Pure Veg',
                  icon: Icons.eco_outlined,
                  isSelected: _selectedDiet.contains('Pure Veg'),
                  onTap: () {
                    setState(() {
                      if (_selectedDiet.contains('Pure Veg')) {
                        _selectedDiet.remove('Pure Veg');
                      } else {
                        _selectedDiet.add('Pure Veg');
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDietPill(
                  label: 'Non-Veg',
                  icon: Icons.restaurant_outlined,
                  isSelected: _selectedDiet.contains('Non-Veg'),
                  onTap: () {
                    setState(() {
                      if (_selectedDiet.contains('Non-Veg')) {
                        _selectedDiet.remove('Non-Veg');
                      } else {
                        _selectedDiet.add('Non-Veg');
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDietPill(
                  label: 'Eggetarian',
                  icon: Icons.egg_outlined,
                  isSelected: _selectedDiet.contains('Eggetarian'),
                  onTap: () {
                    setState(() {
                      if (_selectedDiet.contains('Eggetarian')) {
                        _selectedDiet.remove('Eggetarian');
                      } else {
                        _selectedDiet.add('Eggetarian');
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDietPill(
                  label: 'Vegan',
                  icon: Icons.grass_outlined,
                  isSelected: _selectedDiet.contains('Vegan'),
                  onTap: () {
                    setState(() {
                      if (_selectedDiet.contains('Vegan')) {
                        _selectedDiet.remove('Vegan');
                      } else {
                        _selectedDiet.add('Vegan');
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDietPill({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? const Color(0xFFFFD1D8) : const Color(0xFFEFF4FF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFFDA4AF) : const Color(0xFFDBEAFE),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 10. Card 9: Physical Status
  // ─────────────────────────────────────────────────────────────
  Widget _buildPhysicalStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Physical Status',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Normal
              Expanded(
                child: _buildPhysicalStatusPill(
                  label: 'Normal',
                  icon: Icons.check_circle_outline_rounded,
                  statusKey: 'Normal',
                ),
              ),
              const SizedBox(width: 8),
              // Challenged
              Expanded(
                child: _buildPhysicalStatusPill(
                  label: 'Challenged',
                  icon: Icons.accessible_forward_rounded,
                  statusKey: 'Challenged',
                ),
              ),
              const SizedBox(width: 8),
              // Doesn't Matter
              Expanded(
                child: _buildPhysicalStatusPill(
                  label: 'Doesn\'t Matter',
                  icon: Icons.all_inclusive_rounded,
                  statusKey: 'Doesn\'t Matter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalStatusPill({
    required String label,
    required IconData icon,
    required String statusKey,
  }) {
    final isSelected = _selectedPhysicalStatus == statusKey;
    return Material(
      color: isSelected ? const Color(0xFFFFD1D8) : const Color(0xFFEFF4FF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPhysicalStatus = statusKey;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFFDA4AF) : const Color(0xFFDBEAFE),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 11. Platform Overview Banner
  // ─────────────────────────────────────────────────────────────
  Widget _buildPlatformOverviewBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFEF3C7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Partner Overview',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF92400E),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'The above partner preferences are saved as soft parameters and our matchmaking algorithm prioritizes profiles matching your sacred criteria & family traditions.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF78350F),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Helper Chip Builders
  // ─────────────────────────────────────────────────────────────
  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    bool showCheck = false,
    bool isCenter = false,
    bool isCustom = false,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? const Color(0xFF701A33) : const Color(0xFFEEF2FF),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        onLongPress: isCustom && onEdit != null ? onEdit : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCenter ? 6 : (isCustom ? 8 : 12),
            vertical: 7,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE0E7FF),
            ),
          ),
          child: Row(
            mainAxisSize: isCenter ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showCheck && isSelected) ...[
                const Icon(Icons.check, size: 12, color: Colors.white),
                const SizedBox(width: 3),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              if (isCustom) ...[
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.25) : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 11,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.25) : const Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 11,
                      color: isSelected ? Colors.white : const Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDA4AF), style: BorderStyle.solid),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF881337),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCustomItemDialog(String title, Function(String) onAdded) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF881337),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onAdded(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showEditCustomItemDialog({
    required String title,
    required String currentName,
    required Function(String newName) onEdited,
    required VoidCallback onDeleted,
  }) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48), size: 20),
              tooltip: 'Delete',
              onPressed: () {
                Navigator.pop(ctx);
                onDeleted();
              },
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF881337),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                onEdited(newName);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 11. Bottom Sticky Action Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomActionBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Reset Button
              InkWell(
                onTap: _onResetAll,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: const Icon(Icons.refresh_rounded, color: Color(0xFF1E293B), size: 20),
                ),
              ),
              const SizedBox(width: 12),

              // Apply Button
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF701A33),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _onApplyPreferences,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
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
}
