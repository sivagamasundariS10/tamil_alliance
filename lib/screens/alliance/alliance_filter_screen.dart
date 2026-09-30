import 'package:flutter/material.dart';
import '../premium/premium_screen.dart';

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

  // 2. Marital Status (Step 1 Model)
  String? _maritalStatus = 'Never Married';
  String? _childrenStatus;

  bool get _requiresChildrenSelection =>
      _maritalStatus == 'Awaiting Divorce' ||
      _maritalStatus == 'Widowed' ||
      _maritalStatus == 'Divorced' ||
      _maritalStatus == 'Annulled';

  // 3. Mother Tongue
  final Set<String> _selectedMotherTongue = {'Tamil'};

  // 4. Religion, Caste & Gothram
  final List<String> _selectedSubCastes = [
    'Brahmin - Vadama',
    'Brahmin - Brahacharanam',
  ];
  bool _sagothramRestriction = true;
  final Set<String> _selectedGotras = {'Bharadwaja', 'Srivatsa', 'Haritha'};
  final List<String> _additionalGotras = ['Viswamitra', 'Kashyapa'];

  // 5. Dosham / Manglik Alignment
  final Set<String> _selectedDoshams = {'Chevvai: No Dosham'};

  // 6. Location & Regional Heritage
  final Set<String> _selectedCountries = {'India'};
  final Set<String> _selectedStates = {'Tamil Nadu'};
  final List<String> _selectedCities = ['Chennai', 'Coimbatore'];
  final List<String> _availableDistrictSuggestions = ['Madurai'];

  // 7. Education & Profession
  final Set<String> _selectedEducations = {'Bachelors', 'Masters'};
  final Set<String> _selectedProfessions = {'Software / IT'};
  final Set<String> _selectedIncomeSteps = {'₹10L – ₹25L', '₹25L – ₹50L', '₹50L+'};

  // 8. Diet & Physical
  final Set<String> _selectedDiets = {'Pure Vegetarian'};
  String _selectedPhysicalStatus = 'Normal';

  // 9. Hobbies & Cultural Interests
  final Set<String> _selectedHobbies = {'Carnatic Music', 'Temple Tours'};

  // 10. Lifestyle & Habits (Single-select)
  String _selectedSmoking = 'Never';
  String _selectedDrinking = 'Never';

  // 11. Profile Created By (Single-select)
  String _selectedCreatedBy = 'Self';

  // 12. Citizenship Type (Single-select)
  String _selectedCitizenship = 'Citizen';

  // 13. Family Type & Values
  String _selectedFamilyType = 'Both';
  String _selectedFamilyValue = 'Traditional';

  // 14. Profile Badges
  final Set<String> _selectedBadges = {'100% ID Verified', 'Horoscope Available', 'Photo Only'};

  // ─── Data Lists ───
  final List<String> _smokingOptions = ['Never', 'Occasionally'];
  final List<String> _drinkingOptions = ['Never', 'Socially'];
  final List<String> _createdByOptions = ['Parents', 'Self', 'Siblings', 'Relatives'];
  final List<String> _citizenshipOptions = [
    'Citizen',
    'PR',
    'Work Permit (H1B/Tier-2)',
    'Student Visa',
    'Temporary Visa',
  ];
  final List<String> _familyTypeOptions = ['Nuclear', 'Joint', 'Both'];
  final List<String> _familyValueOptions = ['Orthodox', 'Traditional', 'Moderate', 'Liberal'];
  final List<String> _motherTongueOptions = ['Tamil', 'Telugu', 'Malayalam', 'Kannada', 'Hindi'];
  
  final List<String> _doshamOptions = [
    'Chevvai: No Dosham',
    'Chevvai Dosham Accepted',
    'Raghu-Kethu Dosham',
    'Doesn\'t Matter',
  ];

  final List<String> _countryOptions = ['India', 'USA', 'United Kingdom'];
  final List<String> _stateOptions = ['Tamil Nadu', 'Karnataka', 'Other States'];

  final List<String> _educationOptions = [
    'Bachelors',
    'Masters',
    'Doctorate',
    'CA / CS',
    'Medical',
  ];

  final List<String> _professionOptions = [
    'Software / IT',
    'Doctor',
    'Civil Services',
    'Banking',
  ];

  final List<String> _incomeOptions = [
    'Any',
    '₹10L – ₹25L',
    '₹25L – ₹50L',
    '₹50L+',
  ];

  final List<String> _dietOptions = ['Pure Vegetarian', 'Eggetarian', 'Non-Vegetarian', 'Vegan'];
  final List<String> _physicalOptions = ['Normal', 'Specially Abled', 'Doesn\'t Matter'];
  final List<Map<String, dynamic>> _hobbyOptions = [
    {'name': 'Carnatic Music', 'icon': Icons.music_note_rounded},
    {'name': 'Temple Tours', 'icon': Icons.temple_hindu_rounded},
    {'name': 'Yoga & Meditation', 'icon': null},
    {'name': 'Classical Literature', 'icon': null},
  ];

  void _onResetAll() {
    setState(() {
      _ageRange = const RangeValues(21, 32);
      _heightRange = const RangeValues(152, 183);
      _maritalStatus = 'Never Married';
      _childrenStatus = null;
      _selectedMotherTongue.clear();
      _selectedMotherTongue.add('Tamil');
      _selectedSubCastes.clear();
      _selectedSubCastes.addAll(['Brahmin - Vadama', 'Brahmin - Brahacharanam']);
      _sagothramRestriction = true;
      _selectedGotras.clear();
      _selectedGotras.addAll(['Bharadwaja', 'Srivatsa', 'Haritha']);
      _selectedDoshams.clear();
      _selectedDoshams.add('Chevvai: No Dosham');
      _selectedCountries.clear();
      _selectedCountries.add('India');
      _selectedStates.clear();
      _selectedStates.add('Tamil Nadu');
      _selectedCities.clear();
      _selectedCities.addAll(['Chennai', 'Coimbatore']);
      _selectedEducations.clear();
      _selectedEducations.addAll(['Bachelors', 'Masters']);
      _selectedProfessions.clear();
      _selectedProfessions.add('Software / IT');
      _selectedIncomeSteps.clear();
      _selectedIncomeSteps.addAll(['₹10L – ₹25L', '₹25L – ₹50L', '₹50L+']);
      _selectedDiets.clear();
      _selectedDiets.add('Pure Vegetarian');
      _selectedPhysicalStatus = 'Normal';
      _selectedHobbies.clear();
      _selectedHobbies.addAll(['Carnatic Music', 'Temple Tours']);
      _selectedSmoking = 'Never';
      _selectedDrinking = 'Never';
      _selectedCreatedBy = 'Self';
      _selectedCitizenship = 'Citizen';
      _selectedFamilyType = 'Both';
      _selectedFamilyValue = 'Traditional';
      _selectedBadges.clear();
      _selectedBadges.addAll(['100% ID Verified', 'Horoscope Available', 'Photo Only']);
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
    count += _maritalStatus != null ? 1 : 0;
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
    count += 1; // smoking
    count += 1; // drinking
    count += 1; // created by
    count += 1; // citizenship
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: Center(
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5B84B), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/bride_portrait.jpg',
                    width: 34,
                    height: 34,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFF881337),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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

            // Card 8: 8. Education
            _buildEducationCard(),
            const SizedBox(height: 12),

            // Card 9: 9. Profession & Annual Income
            _buildProfessionIncomeCard(),
            const SizedBox(height: 12),

            // Card 10: 10. Diet
            _buildDietCard(),
            const SizedBox(height: 12),

            // Card 11: 11. Physical Status
            _buildPhysicalStatusCard(),
            const SizedBox(height: 12),

            // Card 12: 12. Hobbies & Cultural Interests
            _buildHobbiesCard(),
            const SizedBox(height: 12),

            // Card 13: 13. Lifestyle & Habits
            _buildLifestyleHabitsCard(),
            const SizedBox(height: 12),

            // Card 14: 14. Profile Created By
            _buildProfileCreatedByCard(),
            const SizedBox(height: 12),

            // Card 15: 15. Citizenship Type
            _buildCitizenshipTypeCard(),
            const SizedBox(height: 12),

            // Card 16 & 17: 16. Family Type & 17. Family Values
            _buildFamilyTypeAndValuesCard(),
            const SizedBox(height: 16),

            // Advanced VIP Filters (Gold Box Exact Reference)
            _buildAdvancedVIPFiltersCard(),
            const SizedBox(height: 16),
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
                    fontSize: 13,
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
                const Text('18 Yrs', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                Text(
                  'Selected: ${_ageRange.start.round()}–${_ageRange.end.round()} Yrs',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                const Text('45+ Yrs', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
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
                    fontSize: 13,
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
                Text('4\'6" (137cm)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                Text('6\'6"+ (198cm)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 3: 3. Marital Status (Exact Step 1 Model)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMaritalStatusCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    '3. Marital Status',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
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
                    color: const Color(0xFF701A33).withValues(alpha: 0.2),
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
            // All 5 Marital options visible when not locked
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF701A33) : const Color(0xFFF3EFEA),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF5C5854),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCE7F3) : const Color(0xFFF3EFEA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE7E1D8),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF701A33) : const Color(0xFF94A3B8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF701A33),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF701A33) : const Color(0xFF5C5854),
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
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
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
                                  fontSize: 13,
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
                                fontSize: 13,
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
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Auto-exclude own gotra (Kaundinya) per Vedic shastras',
                        style: TextStyle(fontSize: 13, color: Color(0xFF78716C)),
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
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
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
  // Card 6: Dosham / Manglik Alignment (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildDoshamCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '6. Dosham / Manglik Alignment',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
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
  // Card 7: Location & Regional Heritage (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildLocationCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7. Location & Regional Heritage',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          const Text('Country', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          const Text('State', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          const Text('Native District Tags', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8F4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF2EDE6)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._selectedCities.map((city) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCities.remove(city);
                        if (!_availableDistrictSuggestions.contains(city)) {
                          _availableDistrictSuggestions.add(city);
                        }
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
                            city,
                            style: const TextStyle(
                              fontSize: 13,
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
                ..._availableDistrictSuggestions.map((dist) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _availableDistrictSuggestions.remove(dist);
                        _selectedCities.add(dist);
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E0D8)),
                      ),
                      child: Text(
                        dist,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  );
                }),
                InkWell(
                  onTap: () {
                    _showAddCustomDialog(
                      title: 'Add District / Native Tag',
                      onAdd: (name) {
                        setState(() {
                          if (!_selectedCities.contains(name)) _selectedCities.add(name);
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
                          '+ Add District',
                          style: TextStyle(
                            fontSize: 13,
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
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 8: Education (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '8. Education',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _educationOptions.map((edu) {
              final isSel = _selectedEducations.contains(edu);
              return _buildPillChip(
                label: edu,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (isSel) {
                      if (_selectedEducations.length > 1) _selectedEducations.remove(edu);
                    } else {
                      _selectedEducations.add(edu);
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
  // Card 9: Profession & Annual Income (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfessionIncomeCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '9. Profession & Annual Income',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFCE7F3)),
                ),
                child: const Text(
                  '₹10L – ₹50L+ p.a.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF881337),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Profession Sector', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
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
                      if (_selectedProfessions.length > 1) _selectedProfessions.remove(prof);
                    } else {
                      _selectedProfessions.add(prof);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Income Stepping', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _incomeOptions.map((inc) {
              final isSel = _selectedIncomeSteps.contains(inc);
              return _buildPillChip(
                label: inc,
                isSelected: isSel,
                onTap: () {
                  setState(() {
                    if (inc == 'Any') {
                      _selectedIncomeSteps.clear();
                      _selectedIncomeSteps.add('Any');
                    } else {
                      _selectedIncomeSteps.remove('Any');
                      if (isSel) {
                        if (_selectedIncomeSteps.length > 1) _selectedIncomeSteps.remove(inc);
                      } else {
                        _selectedIncomeSteps.add(inc);
                      }
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
  // Card 10: Diet (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildDietCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '10. Diet',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
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
  // Card 11: Physical Status (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildPhysicalStatusCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '11. Physical Status',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
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
  // Card 12: Hobbies & Cultural Interests (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildHobbiesCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '12. Hobbies & Cultural Interests',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _hobbyOptions.map((hobby) {
              final String name = hobby['name'] as String;
              final IconData? icon = hobby['icon'] as IconData?;
              final bool isSel = _selectedHobbies.contains(name);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSel) {
                      _selectedHobbies.remove(name);
                    } else {
                      _selectedHobbies.add(name);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFFFCEEEF) : const Color(0xFFF3EFEA),
                    borderRadius: BorderRadius.circular(20),
                    border: isSel ? Border.all(color: const Color(0xFFF8D7DA)) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 14, color: isSel ? const Color(0xFF701A33) : const Color(0xFF5C5854)),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                          color: isSel ? const Color(0xFF701A33) : const Color(0xFF5C5854),
                        ),
                      ),
                    ],
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
  // Card 13: Lifestyle & Habits (Single-select Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildLifestyleHabitsCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '13. Lifestyle & Habits',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smoking Habits
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Smoking Habits', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    ..._smokingOptions.map((opt) {
                      final isSel = _selectedSmoking == opt;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildBlockChip(
                          label: opt,
                          isSelected: isSel,
                          onTap: () => setState(() => _selectedSmoking = opt),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Drinking Habits
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Drinking Habits', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    ..._drinkingOptions.map((opt) {
                      final isSel = _selectedDrinking == opt;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildBlockChip(
                          label: opt,
                          isSelected: isSel,
                          onTap: () => setState(() => _selectedDrinking = opt),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 14: Profile Created By (Single-select Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildProfileCreatedByCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '14. Profile Created By',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _createdByOptions.map((opt) {
              final isSel = _selectedCreatedBy == opt;
              return _buildPillChip(
                label: opt,
                isSelected: isSel,
                onTap: () => setState(() => _selectedCreatedBy = opt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 15: Citizenship Type (Single-select Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildCitizenshipTypeCard() {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '15. Citizenship Type',
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _citizenshipOptions.map((opt) {
              final isSel = _selectedCitizenship == opt;
              return _buildPillChip(
                label: opt,
                isSelected: isSel,
                onTap: () => setState(() => _selectedCitizenship = opt),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 16 & 17: Family Type & Family Values (Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyTypeAndValuesCard() {
    return _buildCardWrapper(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 16. Family Type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '16. Family Type',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 12),
                ..._familyTypeOptions.map((opt) {
                  final isSel = _selectedFamilyType == opt;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildBlockChip(
                      label: opt,
                      isSelected: isSel,
                      onTap: () => setState(() => _selectedFamilyType = opt),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // 17. Family Values
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '17. Family Values',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 12),
                ..._familyValueOptions.map((val) {
                  final isSel = _selectedFamilyValue == val;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildBlockChip(
                      label: val,
                      isSelected: isSel,
                      onTap: () => setState(() => _selectedFamilyValue = val),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }



  // ─────────────────────────────────────────────────────────────
  // Advanced VIP Filters (Kalyanam Gold VIP Box - Exact Reference)
  // ─────────────────────────────────────────────────────────────
  Widget _buildAdvancedVIPFiltersCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4A338), width: 1.2),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.star_border_rounded, color: Color(0xFF701A33), size: 18),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Advanced VIP Filters 🔒',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF701A33),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD48806),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'KALYANAM GOLD VIP',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Precision astrological, affluence, and international filters curated for Tier-1 alliances.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8C7355),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // 1. Nakshatra / 27 Vedic Stars Matching
          _buildVipItemCard(
            icon: Icons.brightness_7_rounded,
            title: '1. Nakshatra / 27 Vedic Stars Matching',
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildVipSmallChip('Ashwini', isPink: true),
                _buildVipSmallChip('Rohini', isPink: false),
                _buildVipSmallChip('Swati', isPink: false),
                _buildVipSmallChip('Revathi', isPink: true),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 2. Working Company Name
          _buildVipItemCard(
            icon: Icons.domain_rounded,
            title: '2. Working Company Name',
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildVipSmallChip('Google'),
                _buildVipSmallChip('Microsoft'),
                _buildVipSmallChip('Govt / IAS'),
                _buildVipSmallChip('Fortune 500 MNC'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 3. Family Affluence Level
          _buildVipItemCard(
            icon: Icons.account_balance_rounded,
            title: '3. Family Affluence Level',
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildVipSmallChip('High Net Worth (₹15Cr+)'),
                _buildVipSmallChip('Upper Middle (₹35L– ₹1Cr)'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 4. Birth Window & Astrological Timeline
          _buildVipItemCard(
            icon: Icons.calendar_month_rounded,
            title: '4. Birth Window & Astrological Timeline',
            child: const Text(
              'Hour of birth precision & Rasi–Navamsha synastry check',
              style: TextStyle(fontSize: 13, color: Color(0xFF78716C)),
            ),
          ),
          const SizedBox(height: 10),

          // 5. 100% Aadhaar & Passport Verified Only
          _buildVipItemCard(
            icon: Icons.verified_user_outlined,
            iconColor: const Color(0xFF059669),
            title: '5. 100% Aadhaar & Passport Verified Only',
            child: const Text(
              'Strictly exclude unverified or self-declared credentials',
              style: TextStyle(fontSize: 13, color: Color(0xFF78716C)),
            ),
          ),
          const SizedBox(height: 10),

          // 6. Born Country & Diaspora Heritage
          _buildVipItemCard(
            icon: Icons.public_rounded,
            title: '6. Born Country & Diaspora Heritage',
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildVipSmallChip('Born in India'),
                _buildVipSmallChip('USA / Canada Born'),
                _buildVipSmallChip('UK Born'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // 7. NRI Matches Only
          _buildVipItemCard(
            icon: Icons.flight_takeoff_rounded,
            title: '7. NRI Matches Only',
            child: const Text(
              'Filtered to global professionals with green card / valid PR',
              style: TextStyle(fontSize: 13, color: Color(0xFF78716C)),
            ),
          ),
          const SizedBox(height: 10),

          // 8. Asset Type & Residential Stature
          _buildVipItemCard(
            icon: Icons.home_work_outlined,
            title: '8. Asset Type & Residential Stature',
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildVipSmallChip('Own Villa / Bungalow'),
                _buildVipSmallChip('Luxury Highrise Flat'),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Bottom CTA Callout Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4A338), width: 1.2),
            ),
            child: Column(
              children: [
                // Center Star Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCE7A6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF701A33),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFCE7A6),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Unlock 8 High-Precision VIP Filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                    children: [
                      TextSpan(text: 'Find elite verified matches '),
                      TextSpan(
                        text: '4.8x faster ',
                        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF701A33)),
                      ),
                      TextSpan(text: 'with Vedic Porutham star compatibility, HNI wealth tiers, and global NRI filters.'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PremiumScreen(),
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
                        Text(
                          '👑 Upgrade to VIP to Unlock →',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Starting at ₹999/month • Instant activation with Razorpay',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipItemCard({
    required IconData icon,
    Color iconColor = const Color(0xFFC88A2C),
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDE9E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ),
              const Icon(Icons.lock_outline_rounded, size: 15, color: Color(0xFFC88A2C)),
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _buildVipSmallChip(String label, {bool isPink = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isPink ? const Color(0xFFFCEEF0) : const Color(0xFFF3EFEA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: isPink ? const Color(0xFF701A33) : const Color(0xFF64748B),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Bottom Sticky Action Bar (Exact Reference)
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
                      const Text(
                        'Standard Matches',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF701A33),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Active filters applied',
                    style: TextStyle(
                      fontSize: 13,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
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
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF5C5854),
          ),
        ),
      ),
    );
  }

  Widget _buildBlockChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF701A33) : const Color(0xFFF3EFEA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF5C5854),
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
