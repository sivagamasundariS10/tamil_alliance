import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'registration_success_screen.dart';
import 'basic_info_screen.dart';

class PartnerPreferencesScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? profileFor;
  final String? gender;

  const PartnerPreferencesScreen({
    Key? key,
    this.mobileNumber,
    this.profileFor,
    this.gender,
  }) : super(key: key);

  @override
  State<PartnerPreferencesScreen> createState() => _PartnerPreferencesScreenState();
}

class _PartnerPreferencesScreenState extends State<PartnerPreferencesScreen> {
  // 1. Basic & Physical Criteria
  late String _currentGender;
  late double _minAge;
  late double _maxAge;
  late String _minAgeLabel;
  late String _maxAgeLabel;
  RangeValues _ageRange = const RangeValues(23, 28);
  RangeValues _heightRange = const RangeValues(152, 170); // in cm: 152 = 5'0", 170 = 5'7"

  @override
  void initState() {
    super.initState();
    _currentGender = _resolveInitialGender();
    _configureAgeSpanForGender(_currentGender, isInit: true);
  }

  String _resolveInitialGender() {
    if (widget.gender != null && widget.gender!.isNotEmpty) {
      return widget.gender!;
    }
    if (BasicInfoScreen.selectedGender != null && BasicInfoScreen.selectedGender!.isNotEmpty) {
      return BasicInfoScreen.selectedGender!;
    }
    if (widget.profileFor != null) {
      final pf = widget.profileFor!.toLowerCase();
      if (pf.contains('daughter') || pf.contains('sister') || pf.contains('female')) {
        return 'Female';
      }
      if (pf.contains('son') || pf.contains('brother') || pf.contains('male')) {
        return 'Male';
      }
    }
    return 'Female';
  }

  void _configureAgeSpanForGender(String gender, {bool isInit = false}) {
    final isFemale = gender.toLowerCase() == 'female';
    _minAge = isFemale ? 21.0 : 18.0;
    _maxAge = 60.0;
    _minAgeLabel = isFemale ? '21 yrs' : '18 yrs+';
    _maxAgeLabel = '60 yrs';

    if (isInit) {
      _ageRange = isFemale ? const RangeValues(24, 30) : const RangeValues(21, 28);
    } else {
      double start = _ageRange.start;
      double end = _ageRange.end;
      if (start < _minAge) start = _minAge;
      if (end > _maxAge) end = _maxAge;
      if (start > end) start = _minAge;
      _ageRange = RangeValues(start, end);
    }
  }

  String? _maritalStatus;
  String? _childrenStatus;

  bool get _requiresChildrenSelection =>
      _maritalStatus == 'Divorced' ||
      _maritalStatus == 'Awaiting Divorce' ||
      _maritalStatus == 'Widowed';

  String? _selectedPrimaryMotherTongue;
  final List<String> _motherTongues = [
    'Any / Doesn\'t Matter',
    'Tamil (தமிழ்)',
    'Telugu (తెలుగు)',
    'Malayalam (മലയാളം)',
    'Kannada (ಕನ್ನಡ)',
    'Hindi (हिंदी)',
    'English',
  ];
  final Set<String> _customMotherTongues = {};
  final Set<String> _selectedMotherTongues = {};

  // 2. Religion & Community
  String? _selectedReligion;
  final List<String> _religionOptions = ['Any / Doesn\'t Matter', 'Hindu', 'Christian', 'Muslim', 'Jain'];

  final List<String> _casteOptions = [
    'Any / Doesn\'t Matter',
    'Vanniyar',
    'Vanniyar - All',
    'Brahmin',
    'Brahmin - All',
    'Mudaliar',
    'Mudaliar - All',
    'Kongu Vellalar',
    'Kongu Vellalar - All',
    'Nadar',
    'Nadar - All',
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
  final Set<String> _customDoshams = {};
  final Set<String> _selectedSpecificDoshams = {};

  final Set<String> _selectedLocations = {};
  final TextEditingController _prefStateController = TextEditingController();
  final TextEditingController _prefCountryController = TextEditingController();
  final TextEditingController _prefCityController = TextEditingController();
  final TextEditingController _locationSearchController = TextEditingController();

  // 3. Education, Career & Income
  final List<String> _educationOptions = [
    'Any / Doesn\'t Matter',
    'Any Graduate',
    'B.Tech / B.E',
    'M.S / M.Tech',
    'MBA / PG',
    'MBBS / MD',
    'CA / CS',
  ];
  final Set<String> _customEducations = {};
  final Set<String> _selectedEducation = {};

  String? _minIncome;

  final List<String> _incomeList = [
    'Any / Doesn\'t Matter',
    '₹1 Lakhs / yr',
    '₹5 Lakhs / yr',
    '₹10 Lakhs / yr',
    '₹15 Lakhs / yr',
    '₹20 Lakhs / yr',
  ];
  String? _maxIncome;
    final List<String> _incomeListMax = [
    'Any / Doesn\'t Matter',
    'Below 1Cr',
    'Upto  1Cr - 5Cr',
    'Upto ₹5Cr - 25Cr',
    'Upto  ₹25Cr+',
  ];
  // 4. Dietary Habits
  final Set<String> _selectedDiet = {};

  // 5. Physical Status
  String? _selectedPhysicalStatus;

  final TextEditingController _aboutMeController = TextEditingController(
    text: "Looking for an understanding, caring, and compatible partner to walk together through life's journey.",
  );

  @override
  void dispose() {
    _prefStateController.dispose();
    _prefCountryController.dispose();
    _prefCityController.dispose();
    _locationSearchController.dispose();
    _aboutMeController.dispose();
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
      _selectedPrimaryMotherTongue = null;
      _selectedMotherTongues.clear();
      _selectedReligion = null;
      _selectedCastes.clear();
      _selectedDoshamType = null;
      _isSpecificDoshamsExpanded = true;
      _selectedSpecificDoshams.clear();
      _prefStateController.clear();
      _prefCountryController.clear();
      _prefCityController.clear();
      _selectedLocations.clear();
      _selectedEducation.clear();
      _selectedEmploymentSectors.clear();
      _minIncome = null;
      _maxIncome = null;
      _selectedDiet.clear();
      _selectedPhysicalStatus = null;
      _aboutMeController.text =
          "Looking for an understanding, caring, and compatible partner to walk together through life's journey.";
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

  void _editDosham(String oldName) {
    _showEditCustomItemDialog(
      title: 'Edit Specific Dosham',
      currentName: oldName,
      onEdited: (newName) {
        setState(() {
          final index = _specificDoshams.indexOf(oldName);
          if (index != -1) {
            _specificDoshams[index] = newName;
          }
          _customDoshams.remove(oldName);
          _customDoshams.add(newName);
          if (_selectedSpecificDoshams.contains(oldName)) {
            _selectedSpecificDoshams.remove(oldName);
            _selectedSpecificDoshams.add(newName);
          }
        });
      },
      onDeleted: () => _deleteDosham(oldName),
    );
  }

  void _deleteDosham(String name) {
    setState(() {
      _specificDoshams.remove(name);
      _customDoshams.remove(name);
      _selectedSpecificDoshams.remove(name);
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
    print(' [USER INPUT: STEP 6 - PARTNER PREFERENCES]');
    print('   Age Range       : ${_ageRange.start.round()} - ${_ageRange.end.round()} yrs');
    print('   Height Range    : ${_formatHeight(_heightRange.start)} to ${_formatHeight(_heightRange.end)}');
    print('   Marital Status  : $_maritalStatus ($_childrenStatus)');
    print('   Mother Tongue   : ${_selectedMotherTongues.join(", ")}');
    print('   Religion        : $_selectedReligion');
    print('   Castes          : $_selectedCastes');
    print('   Dosham Type     : $_selectedDoshamType');
    print('   Specific Dosham : $_selectedSpecificDoshams');
    print('   Preferred State   : ${_prefStateController.text.trim()}');
    print('   Preferred Country : ${_prefCountryController.text.trim()}');
    print('   Preferred City    : ${_prefCityController.text.trim()}');
    print('   Preferred Places  : $_selectedLocations');
    print('   Education       : $_selectedEducation');
    print('   Employment      : $_selectedEmploymentSectors');
    print('   Income Range    : $_minIncome to $_maxIncome');
    print('   Diet Preference : $_selectedDiet');
    print('   Physical Status : $_selectedPhysicalStatus');
    print('   About Partner/Me: ${_aboutMeController.text.trim()}');
    print('====================================================');

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegistrationSuccessScreen(
          mobileNumber: widget.mobileNumber,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(theme.textTheme),
        primaryTextTheme: GoogleFonts.plusJakartaSansTextTheme(theme.primaryTextTheme),
      ),
      child: DefaultTextStyle.merge(
        style: GoogleFonts.plusJakartaSans(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        _buildAboutMeCard(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomActionBar(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top Custom App Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 22,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'Profile Registration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'PARTNER PREFERENCES',
                  style: TextStyle(
                    color: Color(0xFFE5A93C),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5A93C), width: 1.5),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFE5A93C),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top Sub-Header Tracker
  // ─────────────────────────────────────────────────────────────
  // Widget _buildSubHeader() {
  //   return const Row(
  //     children: [
  //       Icon(Icons.circle, size: 6, color: Color(0xFF881337)),
  //       SizedBox(width: 6),
  //        Text(
  //          'PARTNER PREFERENCES',
  //         style: TextStyle(
  //           color: Color(0xFF881337),
  //           fontSize: 13,
  //           fontWeight: FontWeight.w800,
  //           letterSpacing: 0.8,
  //         ),
  //        ),
  //     ],
  //    );
  // }

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
          // Header with Icon
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
              const Expanded(
                child: Text(
                  'Basic & Physical Criteria',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
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
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_ageRange.start.round()} yrs — ${_ageRange.end.round()} yrs',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF881337)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF881337),
              inactiveTrackColor: const Color(0xFFDBEAFE),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
                tickMarkRadius: 0,
              ),
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
              min: _minAge,
              max: _maxAge,
              divisions: (_maxAge - _minAge).round(),
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
              children: [
                Text(_minAgeLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                Text(_maxAgeLabel, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
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
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_formatHeight(_heightRange.start)} — ${_formatHeight(_heightRange.end)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF881337)),
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
                Text('4\'5" (137cm)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                Text('6\'11" (210cm)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
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
                      fontSize: 15.5,
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
                      fontSize: 15.5,
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
                      fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w500,
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
                const SizedBox(width: 8),
                Expanded(child: _buildMaritalChip('Any / Doesn\'t Matter')),
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
            fontWeight: FontWeight.w500,
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFF94A3B8),
                  width: isSelected ? 4 : 1.5,
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFF475569),
                ),
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
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFFBE123C)),
                  ),
                ],
              ),
              const Text(
                'தாய்மொழி',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF881337)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Working Mother Tongue Dropdown Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.translate_rounded, size: 20, color: Color(0xFF881337)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPrimaryMotherTongue,
                      hint: const Text(
                        'Select Mother Tongue / தாய்மொழி',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                      items: _motherTongues.map((String lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(
                            lang,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPrimaryMotherTongue = val;
                            if (val == 'Any / Doesn\'t Matter') {
                              _selectedMotherTongues.clear();
                              _selectedMotherTongues.add(val);
                            } else {
                              _selectedMotherTongues.remove('Any / Doesn\'t Matter');
                              _selectedMotherTongues.add(val);
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Add Language label
          const Text(
            'Add Language',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 10),

          // Selected Language Chips + Add More Button
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ..._selectedMotherTongues
                  .where((lang) => lang != _selectedPrimaryMotherTongue && lang != 'Any / Doesn\'t Matter')
                  .map((lang) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF881337),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF881337).withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 12, color: Colors.white),
                      const SizedBox(width: 5),
                      Text(
                        lang,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMotherTongues.remove(lang);
                          });
                        },
                        child: const Icon(Icons.close, size: 12, color: Color(0xFFFCE7F3)),
                      ),
                    ],
                  ),
                );
              }),
              // + Add More Button
              GestureDetector(
                onTap: _showAddMotherTongueDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF93C5FD)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add_rounded, size: 15, color: Color(0xFF2563EB)),
                      SizedBox(width: 4),
                      Text(
                        'Add More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2563EB),
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
    );
  }

  void _showAddMotherTongueDialog() {
    final List<String> availableLanguages = [
      'Tamil (தமிழ்)',
      'English',
      'Telugu (తెలుగు)',
      'Malayalam (മലയാളம்)',
      'Kannada (ಕನ್ನಡ)',
      'Hindi (हिन्दी)',
      'Sourashtra (சௌராஷ்ட்ரா)',
      'French',
      'German',
      'Arabic',
      'Spanish',
      'Marathi (मராठी)',
      'Gujarati (ગુજરાતી)',
      'Bengali (বাংলা)',
      'Sanskrit (संस्कृतम्)',
    ];

    for (final custom in _customMotherTongues) {
      if (!availableLanguages.contains(custom)) {
        availableLanguages.insert(0, custom);
      }
    }

    final TextEditingController customLangController = TextEditingController();
    final FocusNode inputFocusNode = FocusNode();
    bool isInputFocused = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            inputFocusNode.addListener(() {
              if (modalContext.mounted) {
                setModalState(() {
                  isInputFocused = inputFocusNode.hasFocus;
                });
              }
            });

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select or add languages',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 22, color: Color(0xFF64748B)),
                            onPressed: () => Navigator.pop(ctx),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Custom Language Input Bar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isInputFocused ? Colors.white : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isInputFocused ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
                            width: isInputFocused ? 1.6 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isInputFocused
                                  ? const Color(0xFF701A33).withOpacity(0.08)
                                  : const Color(0x06000000),
                              blurRadius: isInputFocused ? 10 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isInputFocused
                                    ? const Color(0xFFFDF2F4)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.language_rounded,
                                size: 18,
                                color: isInputFocused
                                    ? const Color(0xFF701A33)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: customLangController,
                                focusNode: inputFocusNode,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF1E293B),
                                ),
                                cursorColor: const Color(0xFF701A33),
                                decoration: const InputDecoration(
                                  hintText: 'Type other language...',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF94A3B8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  filled: false,
                                  fillColor: Colors.transparent,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                                onSubmitted: (val) {
                                  final text = val.trim();
                                  if (text.isNotEmpty) {
                                    if (!availableLanguages.contains(text)) {
                                      availableLanguages.insert(0, text);
                                    }
                                    setState(() {
                                      if (!_motherTongues.contains(text)) {
                                        _motherTongues.add(text);
                                      }
                                      _customMotherTongues.add(text);
                                      _selectedMotherTongues.remove('Any / Doesn\'t Matter');
                                      _selectedMotherTongues.add(text);
                                      _selectedPrimaryMotherTongue ??= text;
                                    });
                                    setModalState(() {});
                                    customLangController.clear();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  final text = customLangController.text.trim();
                                  if (text.isNotEmpty) {
                                    if (!availableLanguages.contains(text)) {
                                      availableLanguages.insert(0, text);
                                    }
                                    setState(() {
                                      if (!_motherTongues.contains(text)) {
                                        _motherTongues.add(text);
                                      }
                                      _customMotherTongues.add(text);
                                      _selectedMotherTongues.remove('Any / Doesn\'t Matter');
                                      _selectedMotherTongues.add(text);
                                      _selectedPrimaryMotherTongue ??= text;
                                    });
                                    setModalState(() {});
                                    customLangController.clear();
                                  }
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF8B213E), Color(0xFF701A33)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF701A33).withOpacity(0.25),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.add_rounded, size: 16, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        'Add',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
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
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Popular Languages:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 10),

                      // Language Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableLanguages.map((lang) {
                          final isSelected = _selectedMotherTongues.contains(lang);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedMotherTongues.remove(lang);
                                  if (_selectedPrimaryMotherTongue == lang) {
                                    _selectedPrimaryMotherTongue = _selectedMotherTongues.isNotEmpty
                                        ? _selectedMotherTongues.first
                                        : null;
                                  }
                                } else {
                                  _selectedMotherTongues.remove('Any / Doesn\'t Matter');
                                  _selectedMotherTongues.add(lang);
                                  _selectedPrimaryMotherTongue ??= lang;
                                  if (!_motherTongues.contains(lang)) {
                                    _motherTongues.add(lang);
                                  }
                                }
                              });
                              setModalState(() {});
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF701A33) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Icon(Icons.check, size: 12, color: Colors.white),
                                    ),
                                  Text(
                                    lang,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected ? Colors.white : const Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Done Button
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF701A33),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
                      fontSize: 15.5,
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
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
                    'Community',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                  ),
                  // SizedBox(width: 4),
                  // Text(
                  //   '(Tamil Nadu)',
                  //   style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  // ),
                ],
              ),
              Text(
                '${_selectedCastes.length} Selected',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
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
                      if (caste == 'Any / Doesn\'t Matter') {
                        if (isSelected) {
                          _selectedCastes.remove(caste);
                        } else {
                          _selectedCastes.clear();
                          _selectedCastes.add(caste);
                        }
                      } else {
                        _selectedCastes.remove('Any / Doesn\'t Matter');
                        if (isSelected) {
                          _selectedCastes.remove(caste);
                        } else {
                          _selectedCastes.add(caste);
                        }
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
              const Expanded(
                child: Text(
                  'Dosham (தோஷம்)',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$selectedCount Selected',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF881337)),
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
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
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
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF881337)),
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
                      children: [
                        ..._specificDoshams.map((d) {
                          final isSelected = _selectedSpecificDoshams.contains(d);
                          final isCustom = _customDoshams.contains(d);
                          return _buildSelectableChip(
                            label: d,
                            isSelected: isSelected,
                            showCheck: isSelected,
                            isCustom: isCustom,
                            onEdit: isCustom ? () => _editDosham(d) : null,
                            onDelete: isCustom ? () => _deleteDosham(d) : null,
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
                        }),
                        _buildAddButton('+ Add More Dosham', () {
                          _showAddCustomItemDialog('Add Specific Dosham', (val) {
                            setState(() {
                              _specificDoshams.add(val);
                              _customDoshams.add(val);
                              _selectedSpecificDoshams.add(val);
                            });
                          });
                        }),
                      ],
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
    final bool isDoesntMatter =
        _selectedLocations.contains("Doesn't Matter") || _selectedLocations.contains("Any / Doesn't Matter");

    final int totalCount = isDoesntMatter
        ? 1
        : {
            ..._selectedLocations.where((e) => e != "Doesn't Matter" && e != "Any / Doesn't Matter"),
            if (_prefCountryController.text.trim().isNotEmpty) _prefCountryController.text.trim(),
            if (_prefStateController.text.trim().isNotEmpty) _prefStateController.text.trim(),
            if (_prefCityController.text.trim().isNotEmpty) _prefCityController.text.trim(),
          }.length;

    final addedPlaces =
        _selectedLocations.where((loc) => loc != "Doesn't Matter" && loc != "Any / Doesn't Matter").toList();

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Preferred Locations',
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  SizedBox(width: 4),
                  // Text(
                  //   '(விருப்பமான இடங்கள்)',
                  //   style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                  // ),
                ],
              ),
              Text(
                '$totalCount Selected',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Doesn't Matter Button (Only!)
          ActionChip(
            label: const Text("Doesn't Matter"),
            avatar: Icon(
              Icons.all_inclusive_rounded,
              size: 14,
              color: isDoesntMatter ? Colors.white : const Color(0xFF701A33),
            ),
            backgroundColor: isDoesntMatter ? const Color(0xFF701A33) : const Color(0xFFF1F3FB),
            side: BorderSide(
              color: isDoesntMatter ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDoesntMatter ? Colors.white : const Color(0xFF334155),
            ),
            onPressed: () {
              setState(() {
                if (isDoesntMatter) {
                  _selectedLocations.remove("Doesn't Matter");
                  _selectedLocations.remove("Any / Doesn't Matter");
                } else {
                  _selectedLocations.clear();
                  _prefCountryController.clear();
                  _prefStateController.clear();
                  _prefCityController.clear();
                  _selectedLocations.add("Doesn't Matter");
                }
              });
            },
          ),

          // 1. Country Input Box (First!)
          _buildLocationInputField(
            label: 'Country',
            hintText: 'e.g. India, Singapore',
            controller: _prefCountryController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),

          // 2. State Input Box
          _buildLocationInputField(
            label: 'State',
            hintText: 'e.g. Tamil Nadu',
            controller: _prefStateController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),

          // 3. City Input Box
          _buildLocationInputField(
            label: 'City / District',
            hintText: 'e.g. Chennai, Coimbatore',
            controller: _prefCityController,
            textInputAction: TextInputAction.done,
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                setState(() {
                  _selectedLocations.remove("Doesn't Matter");
                  _selectedLocations.remove("Any / Doesn't Matter");
                  _selectedLocations.add(val.trim());
                });
              }
            },
            onAddPressed: () {
              final val = _prefCityController.text.trim();
              if (val.isNotEmpty) {
                setState(() {
                  _selectedLocations.remove("Doesn't Matter");
                  _selectedLocations.remove("Any / Doesn't Matter");
                  _selectedLocations.add(val);
                });
              }
            },
          ),
          const SizedBox(height: 14),

          // Doesn't Matter Button (Only!)
          // ActionChip(
          //   label: const Text("Doesn't Matter"),
          //   avatar: Icon(
          //     Icons.all_inclusive_rounded,
          //     size: 14,
          //     color: isDoesntMatter ? Colors.white : const Color(0xFF701A33),
          //   ),
          //   backgroundColor: isDoesntMatter ? const Color(0xFF701A33) : const Color(0xFFF1F3FB),
          //   side: BorderSide(
          //     color: isDoesntMatter ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
          //   ),
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          //   labelStyle: TextStyle(
          //     fontSize: 12,
            //   fontWeight: isDoesntMatter ? FontWeight.w700 : FontWeight.w600,
            //   color: isDoesntMatter ? Colors.white : const Color(0xFF334155),
            // ),
            // onPressed: () {
            //   setState(() {
            //     if (isDoesntMatter) {
            //       _selectedLocations.remove("Doesn't Matter");
            //       _selectedLocations.remove("Any / Doesn't Matter");
            //     } else {
            //       _selectedLocations.clear();
            //       _prefCountryController.clear();
            //       _prefStateController.clear();
            //       _prefCityController.clear();
            //       _selectedLocations.add("Doesn't Matter");
            //     }
            //   });
          //   },
          // ),

          // Selected Places Tags (if any specific places added)
          if (addedPlaces.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Text(
                  'Selected places',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${addedPlaces.length})',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF701A33), fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: addedPlaces.map((loc) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _selectedLocations.remove(loc);
                        if (loc == _prefCountryController.text) _prefCountryController.clear();
                        if (loc == _prefStateController.text) _prefStateController.clear();
                        if (loc == _prefCityController.text) _prefCityController.clear();
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
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          const SizedBox(width: 5),
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
        ],
      ),
    );
  }

  Widget _buildLocationInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onSubmitted,
    VoidCallback? onAddPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            textInputAction: textInputAction,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.normal,
              color: Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              filled: false,
              fillColor: Colors.transparent,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 13),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  if (value.text.isNotEmpty) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (onAddPressed != null)
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18, color: Color(0xFF701A33)),
                            tooltip: 'Add to places',
                            onPressed: onAddPressed,
                            splashRadius: 16,
                          ),
                        IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                          onPressed: () {
                            controller.clear();
                            setState(() {});
                          },
                          splashRadius: 16,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            onChanged: (val) {
              if (val.trim().isNotEmpty) {
                _selectedLocations.remove("Doesn't Matter");
                _selectedLocations.remove("Any / Doesn't Matter");
              }
              setState(() {});
            },
            onSubmitted: onSubmitted,
          ),
        ),
      ],
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
                      fontSize: 15.5,
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
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
                      if (edu == 'Any / Doesn\'t Matter') {
                        if (isSelected) {
                          _selectedEducation.remove(edu);
                        } else {
                          _selectedEducation.clear();
                          _selectedEducation.add(edu);
                        }
                      } else {
                        _selectedEducation.remove('Any / Doesn\'t Matter');
                        if (isSelected) {
                          _selectedEducation.remove(edu);
                        } else {
                          _selectedEducation.add(edu);
                        }
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
                  fontSize: 15.5,
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
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
          // Annual Income Range Header
          const Text(
            'Annual Income Range',
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 10),
          _buildSelectableChip(
            label: 'Any / Doesn\'t Matter',
            isSelected: _minIncome == 'Any / Doesn\'t Matter',
            showCheck: _minIncome == 'Any / Doesn\'t Matter',
            onTap: () {
              setState(() {
                if (_minIncome == 'Any / Doesn\'t Matter') {
                  _minIncome = null;
                  _maxIncome = null;
                } else {
                  _minIncome = 'Any / Doesn\'t Matter';
                  _maxIncome = 'Any / Doesn\'t Matter';
                }
              });
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Minimum Income', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
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
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
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
                    const Text('Maximum Income', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569))),
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
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                          items: _incomeListMax.map((inc) => DropdownMenuItem(value: inc, child: Text(inc))).toList(),
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
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Card 8: Dietary Habits
  // ─────────────────────────────────────────────────────────────
  void _onDietaryHabitsTapped(String diet) {
    setState(() {
      if (diet == 'Any / Doesn\'t Matter') {
        if (_selectedDiet.contains('Any / Doesn\'t Matter')) {
          _selectedDiet.remove('Any / Doesn\'t Matter');
        } else {
          _selectedDiet.clear();
          _selectedDiet.add('Any / Doesn\'t Matter');
        }
        return;
      }

      // If choosing any specific diet, clear "Any / Doesn't Matter"
      _selectedDiet.remove('Any / Doesn\'t Matter');

      if (_selectedDiet.contains(diet)) {
        _selectedDiet.remove(diet);
      } else {
        if (_selectedDiet.isEmpty) {
          _selectedDiet.add(diet);
        } else if (_selectedDiet.length == 1) {
          final current = _selectedDiet.first;
          // Only permitted 2-item pairs: {Veg, Non-Veg} or {Veg, Eggetarian}
          final isAllowedPair = (current == 'Veg' && (diet == 'Non-Veg' || diet == 'Eggetarian')) ||
              ((current == 'Non-Veg' || current == 'Eggetarian') && diet == 'Veg');
          if (isAllowedPair) {
            _selectedDiet.add(diet);
          } else {
            // Not an allowed combination (e.g. Non-Veg + Eggetarian, Vegan + anything)
            // Replace with newly tapped selection
            _selectedDiet.clear();
            _selectedDiet.add(diet);
          }
        } else {
          // Already 2 selected: {Veg, Non-Veg} or {Veg, Eggetarian}
          if (diet == 'Eggetarian' && _selectedDiet.contains('Veg')) {
            _selectedDiet.clear();
            _selectedDiet.addAll(['Veg', 'Eggetarian']);
          } else if (diet == 'Non-Veg' && _selectedDiet.contains('Veg')) {
            _selectedDiet.clear();
            _selectedDiet.addAll(['Veg', 'Non-Veg']);
          } else {
            // Switched to another single option (e.g. Vegan or Veg)
            _selectedDiet.clear();
            _selectedDiet.add(diet);
          }
        }
      }
    });
  }

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
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDietPill(
                  label: 'Veg',
                  icon: Icons.eco_outlined,
                  isSelected: _selectedDiet.contains('Veg'),
                  onTap: () => _onDietaryHabitsTapped('Veg'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDietPill(
                  label: 'Non-Veg',
                  icon: Icons.restaurant_outlined,
                  isSelected: _selectedDiet.contains('Non-Veg'),
                  onTap: () => _onDietaryHabitsTapped('Non-Veg'),
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
                  onTap: () => _onDietaryHabitsTapped('Eggetarian'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDietPill(
                  label: 'Vegan',
                  icon: Icons.grass_outlined,
                  isSelected: _selectedDiet.contains('Vegan'),
                  onTap: () => _onDietaryHabitsTapped('Vegan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDietPill(
                  label: 'Any / Doesn\'t Matter',
                  icon: Icons.all_inclusive_rounded,
                  isSelected: _selectedDiet.contains('Any / Doesn\'t Matter'),
                  onTap: () => _onDietaryHabitsTapped('Any / Doesn\'t Matter'),
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
                  fontWeight: FontWeight.w500,
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
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
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
                  fontWeight: FontWeight.w500,
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
  // 11. Few Words About Me Card (Replaces Partner Overview)
  // ─────────────────────────────────────────────────────────────
  Widget _buildAboutMeCard() {
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
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF701A33).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.format_quote_rounded,
                  size: 16,
                  color: Color(0xFF701A33),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Few Words About Partner Preferences',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Express your aspirations',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _aboutMeController,
            maxLines: 4,
            maxLength: 500,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF334155),
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
              ),
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              counterStyle: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
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
            horizontal: isCenter ? 3 : (isCustom ? 8 : 12),
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
                const Icon(Icons.check, size: 11, color: Colors.white),
                const SizedBox(width: 2),
              ],
              Flexible(
                fit: isCenter ? FlexFit.tight : FlexFit.loose,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isCenter ? 12 : 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
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
                      color: isSelected ? Colors.white.withOpacity(0.25) : const Color(0xFFFEE2E8),
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
              fontWeight: FontWeight.w500,
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
