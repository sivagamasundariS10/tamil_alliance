import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'family_details_screen.dart';

class BasicInfoScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;
  final String? email;

  const BasicInfoScreen({
    super.key,
    this.mobileNumber,
    this.countryCode,
    this.email,
  });

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final ScrollController _scrollController = ScrollController();

  // Form controllers (Empty by default)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _birthTimeController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _kootamController = TextEditingController();
  final TextEditingController _gothramController = TextEditingController();

  // Form values (None pre-selected by default)
  String? _profileFor;
  DateTime? _selectedDob;
  int? _calculatedAge;
  String _meridiem = 'AM';
  double _heightCm = 170.0;
  String? _gender;
  String? _motherTongue;
  final Set<String> _selectedLanguages = {};
  String? _selectedCaste;
  String? _maritalStatus;
  String? _childrenStatus; // 'Living with Children', 'No Children', 'Living without Children'

  // Options
  final List<Map<String, dynamic>> _profileForOptions = [
    {'title': 'Self', 'icon': Icons.person},
    {'title': 'Son', 'icon': Icons.person},
    {'title': 'Daughter', 'icon': Icons.person_outline},
    {'title': 'Brother', 'icon': Icons.person},
    {'title': 'Sister', 'icon': Icons.person_outline},
    {'title': 'Relative', 'icon': Icons.groups_outlined},
  ];

  final List<String> _motherTongueList = [
    'Tamil (தமிழ்)',
    'Telugu (తెలుగు)',
    'Malayalam (മലയാളം)',
    'Kannada (ಕನ್ನಡ)',
    'Hindi (हिन्दी)',
    'Sourashtra (சௌராஷ்ட்ரா)',
    'English',
    'Marathi (मराठी)',
    'Gujarati (ગુજરાતી)',
    'Bengali (বাংলা)',
    'Other Language (மற்றவை)',
  ];

  final List<String> _casteList = [
    'Kongu Vellalar (கொங்கு வேளாளர்)',
    'Vanniyar (வன்னியர்)',
    'Nadar (நாடார்)',
    'Chettiar (செட்டியார்)',
    'Mudaliar (முதலியார்)',
    'Pillai (பிள்ளை)',
    'Brahmin - Iyer (ஐயர்)',
    'Brahmin - Iyengar (ஐயங்கார்)',
    'Devendra Kula Vellalar (தேவேந்திர குல வேளாளர்)',
    'Thevar / Mukkulathor (தேவர் / முக்குலத்தோர்)',
    'Naidu (நாயுடு)',
    'Reddiar (ரெட்டியார்)',
    'Viswakarma (விஸ்வகர்மா)',
    'Yadava (யாதவர்)',
    'Other Community (மற்றவை)',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _birthPlaceController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _birthTimeController.dispose();
    _birthPlaceController.dispose();
    _religionController.dispose();
    _kootamController.dispose();
    _gothramController.dispose();
    super.dispose();
  }

  // Step-by-step progressive reveal conditions
  bool get _showName => _profileFor != null;
  bool get _showDob => _showName && _nameController.text.trim().isNotEmpty;
  bool get _showBirthPlace => _showDob && _selectedDob != null;
  bool get _showHeight => _showBirthPlace;
  bool get _showGender => _showBirthPlace;
  bool get _showMotherTongue => _showGender && _gender != null;
  bool get _showCommunityAndMarital => _showMotherTongue && _motherTongue != null;
  bool get _showCommunity => _showCommunityAndMarital;
  bool get _showMaritalStatus => _showCommunityAndMarital;
  bool get _showSubmit => _showMaritalStatus && _maritalStatus != null &&
      (!_requiresChildrenSelection || _childrenStatus != null);

  bool get _requiresChildrenSelection =>
      _maritalStatus == 'Awaiting Divorce' ||
      _maritalStatus == 'Widowed' ||
      _maritalStatus == 'Divorced';


  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25, 1, 1),
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 18),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF701A33),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final age = now.year - picked.year - ((now.month > picked.month || (now.month == picked.month && now.day >= picked.day)) ? 0 : 1);
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');
      final yyyy = picked.year.toString();

      setState(() {
        _selectedDob = picked;
        _calculatedAge = age;
        _dobController.text = '$mm / $dd / $yyyy';
      });
      _scrollToBottom();
    }
  }

  Future<void> _pickBirthTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 45),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF701A33),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      setState(() {
        _birthTimeController.text = '$hour:$minute';
        _meridiem = picked.period == DayPeriod.am ? 'AM' : 'PM';
      });
    }
  }

  void _showAddLanguageBottomSheet() {
    final List<String> availableLanguages = [
      'Tamil (தமிழ்)',
      'English',
      'Telugu (తెలుగు)',
      'Malayalam (മലയാളം)',
      'Kannada (ಕನ್ನಡ)',
      'Hindi (हिन्दी)',
      'Sourashtra (சௌராஷ்ட்ரா)',
      'French',
      'German',
      'Arabic',
      'Spanish',
      'Marathi (मराठी)',
      'Gujarati (ગુજરાતી)',
      'Bengali (বাংলা)',
      'Sanskrit (संस्कृतम्)',
    ];

    final TextEditingController customLangController = TextEditingController();

    FocusNode inputFocusNode = FocusNode();
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
                            'Languages Known Fluently',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
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
                      const SizedBox(height: 4),
                      const Text(
                        'Select or add languages you can speak fluently.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Premium Modern Custom Language Input Bar
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
                                  ? const Color(0xFF701A33).withValues(alpha: 0.08)
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
                                  fontWeight: FontWeight.w600,
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
                                      if (!_selectedLanguages.contains(text)) {
                                        _selectedLanguages.add(text);
                                      }
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
                                      if (!_selectedLanguages.contains(text)) {
                                        _selectedLanguages.add(text);
                                      }
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
                                        color: const Color(0xFF701A33).withValues(alpha: 0.25),
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
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.5,
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
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 10),

                      // Language Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: availableLanguages.map((lang) {
                          final isSelected = _selectedLanguages.contains(lang);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedLanguages.remove(lang);
                                } else {
                                  _selectedLanguages.add(lang);
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
                                      fontSize: 11.5,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                          child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
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

  String get _heightFormatted {
    final totalInches = (_heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet' $inches\" / ${_heightCm.round()} cm";
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    debugPrint('====================================================');
    debugPrint('[STEP 1: BASIC INFO SUBMITTED]');
    debugPrint('  Profile Created For : $_profileFor');
    debugPrint('  Legal Full Name     : ${_nameController.text}');
    debugPrint('  Date of Birth       : ${_dobController.text}');
    debugPrint('  Time of Birth       : ${_birthTimeController.text}');
    debugPrint('  Place of Birth      : ${_birthPlaceController.text}');
    debugPrint('  Height              : $_heightFormatted');
    debugPrint('  Gender              : $_gender');
    debugPrint('  Mother Tongue       : $_motherTongue');
    debugPrint('  Secondary Languages : $_selectedLanguages');
    debugPrint('  Religion            : ${_religionController.text}');
    debugPrint('  Community / Caste   : $_selectedCaste');
    debugPrint('  Kula Deivam/Kootam  : ${_kootamController.text}');
    debugPrint('  Gothram             : ${_gothramController.text}');
    debugPrint('  Marital Status      : $_maritalStatus');
    if (_requiresChildrenSelection) {
      debugPrint('  Children Status     : $_childrenStatus');
    }
    debugPrint('====================================================');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FamilyDetailsScreen(
          mobileNumber: widget.mobileNumber,
          countryCode: widget.countryCode,
          email: widget.email,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Custom App Bar
            _buildCustomAppBar(context),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A) Step 1 Header Card (Always Visible)
                    _buildStepHeaderCard(),
                    const SizedBox(height: 16),

                    // B) Profile Created For (Always Visible)
                    _buildProfileCreatedForCard(),

                    // C) Full Legal Name (Reveals after Profile Created For is selected)
                    _buildAnimatedSection(
                      visible: _showName,
                      child: _buildFullLegalNameCard(),
                    ),

                    // D) Date of Birth (Reveals after Name is entered)
                    _buildAnimatedSection(
                      visible: _showDob,
                      child: _buildDateOfBirthCard(),
                    ),

                    // E) Time & Place of Birth (Reveals after DOB is picked)
                    _buildAnimatedSection(
                      visible: _showBirthPlace,
                      child: _buildTimeAndPlaceOfBirthCard(),
                    ),

                    // F) Height Card (Reveals after Place of Birth)
                    _buildAnimatedSection(
                      visible: _showHeight,
                      child: _buildHeightCard(),
                    ),

                    // G) Gender Card (Reveals after Height)
                    _buildAnimatedSection(
                      visible: _showGender,
                      child: _buildGenderCard(),
                    ),

                    // H) Mother Tongue & Languages (Reveals after Gender)
                    _buildAnimatedSection(
                      visible: _showMotherTongue,
                      child: _buildMotherTongueCard(),
                    ),

                    // I) Community & Lineage (Reveals after Mother Tongue)
                    _buildAnimatedSection(
                      visible: _showCommunity,
                      child: _buildCommunityLineageCard(),
                    ),

                    // J) Marital Status (Reveals after Community)
                    _buildAnimatedSection(
                      visible: _showMaritalStatus,
                      child: _buildMaritalStatusCard(),
                    ),

                    // K) Sacred Trust + CTA (Reveals after Marital Status is selected)
                    _buildAnimatedSection(
                      visible: _showSubmit,
                      child: Column(
                        children: [
                          _buildSacredTrustCard(),
                          const SizedBox(height: 18),
                          _buildContinueButton(),
                          const SizedBox(height: 14),
                          _buildSaveAsDraftLink(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Clean Section Wrapper
  Widget _buildAnimatedSection({required bool visible, required Widget child}) {
    if (!visible) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: child,
    );
  }

  // 1. Top Custom App Bar
  Widget _buildCustomAppBar(BuildContext context) {
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
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'STEP 1 OF 6',
                  style: TextStyle(
                    color: Color(0xFFE5A93C),
                    fontSize: 10,
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
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Color(0xFFE5A93C),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  // A) Step 1 of 5 Header Card
  Widget _buildStepHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STEP 1 OF 6 • Vital Details',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF701A33),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.stars_rounded, size: 12, color: Color(0xFF9A3412)),
                    SizedBox(width: 4),
                    Text(
                      'Auspicious Beginning',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              fontFamily: 'serif',
              color: Color(0xFF5B1124),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Enter the bride or groom's verified legal biodata to initiate sacred matrimonial alliances with dignity and astrological precision.",
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // B) Profile Created For Card
  Widget _buildProfileCreatedForCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  size: 16,
                  color: Color(0xFF701A33),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Profile Created For',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Tailors communications whether managed by elders or self.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _profileForOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.18,
            ),
            itemBuilder: (context, index) {
              final item = _profileForOptions[index];
              final isSelected = _profileFor == item['title'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _profileFor = item['title'] as String;
                  });
                  _scrollToBottom();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF701A33) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 20,
                        color: isSelected ? Colors.white : const Color(0xFF701A33),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // C) Full Legal Name Card
  Widget _buildFullLegalNameCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            children: const [
              Text(
                'Full Legal Name',
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
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.badge_outlined,
                  color: Color(0xFF64748B),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onSubmitted: (_) => _scrollToBottom(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter full legal name',
                      hintStyle: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
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

  // D) Date of Birth Card
  Widget _buildDateOfBirthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Text(
                    'Date of Birth',
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
              Text(
                'Gregorian Calendar',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickDateOfBirth,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _dobController.text.isEmpty ? 'MM / DD / YYYY' : _dobController.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: _dobController.text.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
          if (_calculatedAge != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDD5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cake_outlined,
                    size: 16,
                    color: Color(0xFF9A3412),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_calculatedAge Years Old',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF9A3412),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.verified_outlined,
                    size: 15,
                    color: Color(0xFF9A3412),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // E) Time & Place of Birth Card
  Widget _buildTimeAndPlaceOfBirthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.explore_outlined,
                  size: 16,
                  color: Color(0xFF701A33),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Time & Place of Birth',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      'Vedic coordinates for precise Lagna and Rasi computation.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Time of Birth + Meridiem
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time of Birth',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickBirthTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
                            const SizedBox(width: 6),
                            Text(
                              _birthTimeController.text.isEmpty ? 'HH:MM' : _birthTimeController.text,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: _birthTimeController.text.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meridiem',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _meridiem = 'AM'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _meridiem == 'AM' ? const Color(0xFF701A33) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'AM',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: _meridiem == 'AM' ? Colors.white : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _meridiem = 'PM'),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _meridiem == 'PM' ? const Color(0xFF701A33) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'PM',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: _meridiem == 'PM' ? Colors.white : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Place of Birth
          const Text(
            'Place of Birth (City / Town)',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF701A33)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _birthPlaceController,
                    onSubmitted: (_) => _scrollToBottom(),
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'e.g. Madurai, Tamil Nadu, India',
                      hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  ),
                ),
                const Icon(Icons.my_location, size: 16, color: Color(0xFF701A33)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Blue Coordinate Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.satellite_alt_rounded, size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Astro GPS Coordinates • Lagna Synced',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E40AF),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '9.9252° N, 78.1198° E (Madurai Thiruparankundram Meridian)',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
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

  // F) Height Card
  Widget _buildHeightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Height',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Dual scale for global Tamil matches',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Text(
                  _heightFormatted,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4338CA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF701A33),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF701A33),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: _heightCm,
              min: 140.0,
              max: 210.0,
              onChanged: (val) {
                setState(() {
                  _heightCm = val;
                });
              },
              onChangeEnd: (_) => _scrollToBottom(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("4' 7\" (140 cm)", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              Text("Average: 5' 5\"", style: TextStyle(fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.w700)),
              Text("6' 11\" (210 cm)", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  // G) Gender Card
  Widget _buildGenderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            children: const [
              Text(
                'Gender',
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _gender = 'Male');
                    _scrollToBottom();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _gender == 'Male' ? const Color(0xFF701A33) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '♂',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _gender == 'Male' ? Colors.white : const Color(0xFF701A33),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: _gender == 'Male' ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              '(ஆண்)',
                              style: TextStyle(
                                fontSize: 10,
                                color: _gender == 'Male' ? const Color(0xFFFCE7F3) : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _gender = 'Female');
                    _scrollToBottom();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _gender == 'Female' ? const Color(0xFF701A33) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '♀',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _gender == 'Female' ? Colors.white : const Color(0xFF701A33),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: _gender == 'Female' ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              '(பெண்)',
                              style: TextStyle(
                                fontSize: 10,
                                color: _gender == 'Female' ? const Color(0xFFFCE7F3) : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  // H) Mother Tongue & Languages Known (Working Dropdown + Interactive Chips + Working Add More)
  Widget _buildMotherTongueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Text(
                    'Mother Tongue',
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
              Text(
                'தாய்மொழி',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF701A33),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Working Mother Tongue Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.translate, size: 18, color: Color(0xFF701A33)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _motherTongue,
                      hint: const Text(
                        'Select Mother Tongue / தாய்மொழி',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                      items: _motherTongueList.map((String lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(
                            lang,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _motherTongue = val;
                            _selectedLanguages.add(val); // automatically ensure mother tongue is in languages known
                          });
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Languages Known Fluently
          const Text(
            'Languages Known Fluently',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),

          // Working Interactive Select/Deselect Chips & Add More
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._selectedLanguages.map((lang) {
                return GestureDetector(
                  onTap: () {
                    // Allow deselecting / removing language
                    setState(() {
                      _selectedLanguages.remove(lang);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF701A33),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF701A33).withValues(alpha: 0.2),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.close, size: 10, color: Color(0xFFFCE7F3)),
                      ],
                    ),
                  ),
                );
              }),
              // Working + Add More Button
              GestureDetector(
                onTap: _showAddLanguageBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add, size: 13, color: Color(0xFF2563EB)),
                      SizedBox(width: 4),
                      Text(
                        'Add More',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
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

  // I) Community & Lineage Card
  Widget _buildCommunityLineageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            children: const [
              Icon(
                Icons.diversity_3_rounded,
                size: 18,
                color: Color(0xFF701A33),
              ),
              SizedBox(width: 8),
              Text(
                'Community & Lineage (சாதி விவரம்)',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Religion
          const Text(
            'Religion',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _religionController,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'e.g. Hindu',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Community / Caste
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Community / Caste',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
              ),
              Text(
                '🔍 Searchable',
                style: TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCaste,
                hint: const Text(
                  'Select Community / Caste',
                  style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                ),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                items: _casteList.map((String caste) {
                  return DropdownMenuItem<String>(
                    value: caste,
                    child: Text(
                      caste,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCaste = val);
                    _scrollToBottom();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Kulam / Kootam + Gothram
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kulam / Kootam',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _kootamController,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g. Cheran Kulam',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
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
                    const Text(
                      'Gothram',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _gothramController,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g. Shiva Gothram',
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
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

  // J) Marital Status Card
  Widget _buildMaritalStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // If Awaiting Divorce, Widowed, or Divorced is selected -> hide the other options and only show selected one!
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
            // All 5 Marital options visible when not locked to a divorce/widowed/awaiting divorce selection
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
        _scrollToBottom();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF701A33) : const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  // Beautiful Custom Radio Button Chip with Distinct Radio Outer Ring + Inner Dot
  Widget _buildCustomRadioButton(String label, {bool isFullWidth = false}) {
    final isSelected = _childrenStatus == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _childrenStatus = label;
        });
        _scrollToBottom();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFCE7F3) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Radio Button Icon
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF701A33) : const Color(0xFF94A3B8),
                  width: 1.8,
                ),
                color: Colors.white,
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
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF701A33) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // K) Sacred Trust 256-Bit Protection Card
  Widget _buildSacredTrustCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFDBEAFE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              size: 18,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Sacred Trust & 256–Bit Protection',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Profile data is cryptographically protected. Astrological birth charts are generated server-side without publicly exposing your precise birth time or street address.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF3B82F6),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // L) Continue CTA Button
  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF701A33),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59701A33),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _onContinue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // M) Save as Draft Link
  Widget _buildSaveAsDraftLink() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FamilyDetailsScreen(
                mobileNumber: widget.mobileNumber,
                countryCode: widget.countryCode,
                email: widget.email,
              ),
            ),
          );
        },
        child: const Text(
          'Save as Draft & Continue Later',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E40AF),
          ),
        ),
      ),
    );
  }
}
