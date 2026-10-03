import 'package:flutter/material.dart';

class EditBasicDetailsScreen extends StatefulWidget {
  final String? initialFullName;
  final String? initialDob;
  final String? initialMaritalStatus;
  final String? initialHeightWeight;
  final String? initialMotherTongue;
  final String? initialDietLifestyle;

  const EditBasicDetailsScreen({
    super.key,
    this.initialFullName,
    this.initialDob,
    this.initialMaritalStatus,
    this.initialHeightWeight,
    this.initialMotherTongue,
    this.initialDietLifestyle,
  });

  @override
  State<EditBasicDetailsScreen> createState() => _EditBasicDetailsScreenState();
}

class _EditBasicDetailsScreenState extends State<EditBasicDetailsScreen> {
  // Theme Colors
  static const Color primaryMaroon = Color(0xFF701A31);
  static const Color darkSlate = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color lavenderBg = Color(0xFFF1F4FD);
  static const Color peachBg = Color(0xFFFFEDD5);
  static const Color peachBorder = Color(0xFFFED7AA);
  static const Color brownText = Color(0xFF7C2D12);

  // Controllers & Form State
  late TextEditingController _nameController;
  late TextEditingController _placeController;

  // DOB State
  late DateTime _selectedDob;
  late int _age;

  // Time & Meridian
  String _birthTime = '06:45';
  String _meridian = 'AM';

  // Height State (in cm)
  double _heightCm = 170.0;

  // Gender State
  String _gender = 'Male';

  // Mother Tongue & Languages
  String _motherTongue = 'Tamil (தமிழ்)';
  final List<String> _languagesKnown = ['Tamil', 'English', 'Telugu'];

  // Marital Status & Children (Step 1 Model)
  String? _maritalStatus = 'Divorced';
  String? _childrenStatus = 'Living with Children';

  bool get _requiresChildrenSelection =>
      _maritalStatus == 'Awaiting Divorce' ||
      _maritalStatus == 'Widowed' ||
      _maritalStatus == 'Divorced';

  // Lifestyle & Habits
  String _dietaryPreference = 'Non-Vegetarian';
  String _smokingHabit = 'Non-Smoker';
  String _drinkingHabit = 'Non-Drinker';

  @override
  void initState() {
    super.initState();
    // Pre-populate name
    _nameController = TextEditingController(
      text: widget.initialFullName ?? 'Karthikeyan Soundararaj',
    );
    _placeController = TextEditingController(
      text: 'Madurai, Tamil Nadu, India',
    );

    // Default DOB: 14 Aug 1996 (matches 08 / 14 / 1996 in screenshot)
    _selectedDob = DateTime(1996, 8, 14);
    _calculateAge();

    // Check if initial values passed
    if (widget.initialMaritalStatus != null && widget.initialMaritalStatus!.isNotEmpty) {
      _maritalStatus = widget.initialMaritalStatus!;
      if (_requiresChildrenSelection) {
        _childrenStatus = 'Living with Children';
      }
    }
    if (widget.initialMotherTongue != null && widget.initialMotherTongue!.isNotEmpty) {
      _motherTongue = widget.initialMotherTongue!;
    }

    if (widget.initialHeightWeight != null) {
      _parseHeight(widget.initialHeightWeight!);
    }

    if (widget.initialDietLifestyle != null) {
      _parseDietLifestyle(widget.initialDietLifestyle!);
    }
  }

  void _calculateAge() {
    final now = DateTime.now();
    int age = now.year - _selectedDob.year;
    if (now.month < _selectedDob.month || (now.month == _selectedDob.month && now.day < _selectedDob.day)) {
      age--;
    }
    _age = age;
  }

  void _parseHeight(String hw) {
    if (hw.contains('170 cm')) {
      _heightCm = 170.0;
    } else if (hw.contains('180 cm')) {
      _heightCm = 180.0;
    } else {
      final match = RegExp(r'(\d+)\s*cm').firstMatch(hw);
      if (match != null) {
        _heightCm = double.tryParse(match.group(1) ?? '170') ?? 170.0;
      }
    }
  }

  void _parseDietLifestyle(String dl) {
    final parts = dl.split('•').map((s) => s.trim()).toList();
    if (parts.isNotEmpty) {
      final diet = parts[0];
      if (diet.contains('Non–Vegetarian') || diet.contains('Non-Vegetarian')) {
        _dietaryPreference = 'Non-Vegetarian';
      } else if (diet.contains('Pure Vegetarian') || diet.contains('Vegetarian')) {
        _dietaryPreference = 'Vegetarian';
      } else if (diet.contains('Vegan')) {
        _dietaryPreference = 'Vegan';
      } else if (diet.contains('Eggetarian')) {
        _dietaryPreference = 'Eggetarian';
      }
    }
    if (parts.length > 1) {
      final smoke = parts[1];
      if (smoke.contains('Non–Smoker') || smoke.contains('Non-Smoker') || smoke.contains('Never Smokes')) {
        _smokingHabit = 'Non-Smoker';
      } else if (smoke.contains('Occasionally')) {
        _smokingHabit = 'Occasionally';
      } else if (smoke.contains('Smoker') || smoke.contains('Yes')) {
        _smokingHabit = 'Yes';
      }
    }
  }

  String _formatDobMMDDYYYY(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$m / $d / $y';
  }

  String _formatDobForCard(DateTime dt, int age) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year} ($age Yrs)';
  }

  String _formatHeightFeetInches(double cm) {
    final totalInches = (cm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return '$feet\' $inches"';
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob,
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryMaroon,
              onPrimary: Colors.white,
              onSurface: darkSlate,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _calculateAge();
      });
    }
  }

  Future<void> _pickTimeOfBirth() async {
    final parts = _birthTime.split(':');
    int hour = int.tryParse(parts.first) ?? 6;
    int minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 45) : 45;
    if (_meridian == 'PM' && hour < 12) hour += 12;
    if (_meridian == 'AM' && hour == 12) hour = 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryMaroon,
              onPrimary: Colors.white,
              onSurface: darkSlate,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final h = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
        final m = picked.minute.toString().padLeft(2, '0');
        _birthTime = '${h.toString().padLeft(2, '0')}:$m';
        _meridian = picked.period == DayPeriod.am ? 'AM' : 'PM';
      });
    }
  }

  void _resetToDefault() {
    setState(() {
      _nameController.text = 'Karthikeyan Soundararaj';
      _placeController.text = 'Madurai, Tamil Nadu, India';
      _selectedDob = DateTime(1996, 8, 14);
      _calculateAge();
      _birthTime = '06:45';
      _meridian = 'AM';
      _heightCm = 170.0;
      _gender = 'Male';
      _motherTongue = 'Tamil (தமிழ்)';
      _maritalStatus = 'Divorced';
      _childrenStatus = 'Living with Children';
      _dietaryPreference = 'Non-Vegetarian';
      _smokingHabit = 'Non-Smoker';
      _drinkingHabit = 'Non-Drinker';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form values reset to default.'),
        backgroundColor: primaryMaroon,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _saveProfile() {
    final feetInches = _formatHeightFeetInches(_heightCm);
    final heightCmInt = _heightCm.round();
    final formattedDob = _formatDobForCard(_selectedDob, _age);

    final result = {
      'fullName': _nameController.text.trim().isEmpty
          ? 'Karthikeyan Soundararaj'
          : _nameController.text.trim(),
      'dob': formattedDob,
      'maritalStatus': _maritalStatus ?? 'Never Married',
      'childrenStatus': _childrenStatus,
      'heightWeight': '$feetInches ($heightCmInt cm) • 74 kg',
      'motherTongue': _motherTongue,
      'dietLifestyle': '$_dietaryPreference • $_smokingHabit',
      'gender': _gender,
      'placeOfBirth': _placeController.text.trim(),
      'timeOfBirth': '$_birthTime $_meridian',
      'drinkingHabit': _drinkingHabit,
    };

    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Full Legal Name
            _buildFieldLabel('Full Legal Name', isRequired: true),
            const SizedBox(height: 6),
            _buildNameInput(),
            const SizedBox(height: 18),

            // 2. Date of Birth
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFieldLabel('Date of Birth', isRequired: true),
                const Text(
                  'Gregorian Calendar',
                  style: TextStyle(
                    fontSize: 11,
                    color: textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _buildDobInput(),
            const SizedBox(height: 8),
            _buildAgeBanner(),
            const SizedBox(height: 18),

            // 3. Time & Place of Birth Card
            _buildTimeAndPlaceCard(),
            const SizedBox(height: 18),

            // 4. Height Selector
            _buildHeightSection(),
            const SizedBox(height: 18),

            // 5. Gender
            _buildFieldLabel('Gender', isRequired: true),
            const SizedBox(height: 8),
            _buildGenderRow(),
            const SizedBox(height: 18),

            // 6. Mother Tongue
            _buildFieldLabel('Mother Tongue', isRequired: true),
            const SizedBox(height: 6),
            _buildMotherTongueDropdown(),
            const SizedBox(height: 12),
            const Text(
              'Languages Known Fluently',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: darkSlate,
              ),
            ),
            const SizedBox(height: 8),
            _buildLanguagesChips(),
            const SizedBox(height: 18),

            // 7. Marital Status (Step 1 Model)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFieldLabel('Marital Status', isRequired: true),
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
            const SizedBox(height: 10),
            _buildMaritalStatusSection(),
            const SizedBox(height: 22),

            // 8. Lifestyle & Habits
            _buildLifestyleHabitsSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyFooter(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Custom App Bar
  // ─────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: primaryMaroon,
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
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _resetToDefault,
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
  // 1. Full Legal Name
  // ─────────────────────────────────────────────────────────────
  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: darkSlate,
        ),
        children: isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: darkSlate,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: lavenderBg,
        prefixIcon: const Icon(
          Icons.badge_outlined,
          color: textMuted,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryMaroon, width: 1.5),
        ),
        hintText: 'Enter Full Name',
        hintStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Date of Birth
  // ─────────────────────────────────────────────────────────────
  Widget _buildDobInput() {
    return InkWell(
      onTap: _pickDateOfBirth,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: lavenderBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: textMuted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              _formatDobMMDDYYYY(_selectedDob),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: darkSlate,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: peachBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: peachBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cake_outlined,
            color: Color(0xFF9A3412),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '$_age Years Old',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: brownText,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.verified_outlined,
            color: Color(0xFF9A3412),
            size: 18,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Time & Place of Birth Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildTimeAndPlaceCard() {
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.explore_outlined,
                  color: Color(0xFF7E22CE),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Time & Place of Birth',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: darkSlate,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Vedic coordinates for precise Lagna and Rasi computation',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Time of Birth & Meridian Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time input
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time of Birth',
                      style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickTimeOfBirth,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                        decoration: BoxDecoration(
                          color: lavenderBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: textMuted, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _birthTime,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: darkSlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Meridian AM/PM
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meridian',
                      style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _meridian = 'AM'),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _meridian == 'AM' ? primaryMaroon : lavenderBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _meridian == 'AM' ? primaryMaroon : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'AM',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: _meridian == 'AM' ? Colors.white : darkSlate,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _meridian = 'PM'),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _meridian == 'PM' ? primaryMaroon : lavenderBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _meridian == 'PM' ? primaryMaroon : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'PM',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: _meridian == 'PM' ? Colors.white : darkSlate,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
            style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: lavenderBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF881337),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _placeController,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkSlate,
                    ),
                    decoration: const InputDecoration(
                      filled: false,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 11),
                      hintText: 'City, State, Country',
                    ),
                  ),
                ),
                const Icon(
                  Icons.my_location_rounded,
                  color: Color(0xFF881337),
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Astro GPS coordinate container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.satellite_alt_outlined,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text(
                            'Astro GPS Coordinates',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          Text(
                            ' • Lagna Synced',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        '9.9252° N, 78.1198° E (Madurai Thiruparankundram Meridian)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF475569),
                          height: 1.25,
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

  // ─────────────────────────────────────────────────────────────
  // 4. Height Selector
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeightSection() {
    final feetInches = _formatHeightFeetInches(_heightCm);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Height',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: darkSlate,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Dual scale for global Tamil matches',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: lavenderBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Text(
                      feetInches,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: primaryMaroon,
                      ),
                    ),
                    Text(
                      ' / ${_heightCm.round()} cm',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primaryMaroon,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              trackHeight: 4,
              thumbColor: primaryMaroon,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
              overlayColor: primaryMaroon.withValues(alpha: 0.15),
            ),
            child: Slider(
              value: _heightCm,
              min: 140,
              max: 210,
              onChanged: (val) {
                setState(() => _heightCm = val);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '4\' 7" (140 cm)',
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
                Text(
                  'Average: 5\' 5"',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                Text(
                  '6\' 11" (210 cm)',
                  style: TextStyle(fontSize: 11, color: textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Gender
  // ─────────────────────────────────────────────────────────────
  Widget _buildGenderRow() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _gender = 'Male'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: _gender == 'Male' ? primaryMaroon : lavenderBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _gender == 'Male' ? primaryMaroon : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.male_rounded,
                    color: _gender == 'Male' ? Colors.white : darkSlate,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _gender == 'Male' ? Colors.white : darkSlate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => setState(() => _gender = 'Female'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: _gender == 'Female' ? primaryMaroon : lavenderBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _gender == 'Female' ? primaryMaroon : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.female_rounded,
                    color: _gender == 'Female' ? Colors.white : darkSlate,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _gender == 'Female' ? Colors.white : darkSlate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Mother Tongue
  // ─────────────────────────────────────────────────────────────
  Widget _buildMotherTongueDropdown() {
    final tongues = [
      'Tamil (தமிழ்)',
      'Telugu (తెలుగు)',
      'Malayalam (മലയാളം)',
      'Kannada (ಕನ್ನಡ)',
      'Hindi (हिंदी)',
      'English',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: lavenderBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: tongues.contains(_motherTongue) ? _motherTongue : tongues.first,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: textMuted),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: darkSlate,
          ),
          items: tongues.map((t) {
            return DropdownMenuItem<String>(
              value: t,
              child: Row(
                children: [
                  const Icon(Icons.translate_rounded, color: textMuted, size: 18),
                  const SizedBox(width: 10),
                  Text(t),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _motherTongue = val);
          },
        ),
      ),
    );
  }

  Widget _buildLanguagesChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._languagesKnown.map((lang) {
          return InkWell(
            onTap: () => _showEditLanguageDialog(lang),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: primaryMaroon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    lang,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _languagesKnown.remove(lang);
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        InkWell(
          onTap: _showAddLanguageDialog,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: lavenderBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_rounded, color: textMuted, size: 14),
                SizedBox(width: 4),
                Text(
                  'Add More',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditLanguageDialog(String oldLang) {
    final controller = TextEditingController(text: oldLang);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.edit_note_rounded, color: primaryMaroon, size: 22),
            SizedBox(width: 8),
            Text(
              'Edit Language',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkSlate,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update or delete this language from your fluent languages.',
              style: TextStyle(fontSize: 12, color: textMuted),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(fontWeight: FontWeight.w600, color: darkSlate),
              decoration: InputDecoration(
                filled: true,
                fillColor: lavenderBg,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: primaryMaroon, width: 1.5),
                ),
                hintText: 'Language name',
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  setState(() {
                    _languagesKnown.remove(oldLang);
                  });
                  Navigator.pop(ctx);
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: textMuted)),
              ),
              const SizedBox(width: 4),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryMaroon,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: () {
                  final newText = controller.text.trim();
                  if (newText.isNotEmpty) {
                    setState(() {
                      final index = _languagesKnown.indexOf(oldLang);
                      if (index != -1) {
                        _languagesKnown[index] = newText;
                      }
                    });
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddLanguageDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add Fluent Language',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: darkSlate),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(fontWeight: FontWeight.w600, color: darkSlate),
          decoration: InputDecoration(
            filled: true,
            fillColor: lavenderBg,
            hintText: 'e.g. Hindi, French, German',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryMaroon, width: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryMaroon,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty && !_languagesKnown.contains(text)) {
                setState(() => _languagesKnown.add(text));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Marital Status & Children (Step 1 Model)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMaritalStatusSection() {
    if (_requiresChildrenSelection) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: primaryMaroon,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: primaryMaroon.withValues(alpha: 0.2),
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
        ],
      );
    } else {
      return Column(
        children: [
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
      );
    }
  }

  Widget _buildMaritalChip(String status) {
    final isSelected = _maritalStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _maritalStatus = status;
          if (_requiresChildrenSelection) {
            _childrenStatus ??= 'Living with Children';
          } else {
            _childrenStatus = null;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? primaryMaroon : lavenderBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : darkSlate,
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
          color: isSelected ? const Color(0xFFFCE7F3) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
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
                  color: isSelected ? primaryMaroon : const Color(0xFF94A3B8),
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
                          color: primaryMaroon,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? primaryMaroon : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Lifestyle & Habits Section
  // ─────────────────────────────────────────────────────────────
  Widget _buildLifestyleHabitsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            children: const [
              Icon(Icons.circle, color: Color(0xFF991B1B), size: 10),
              SizedBox(width: 8),
              Text(
                'Lifestyle & Habits',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: darkSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Dietary Preference
          _buildFieldLabel('Dietary Preference', isRequired: true),
          const SizedBox(height: 8),
          _buildDietaryGrid(),
          const SizedBox(height: 16),

          // Smoking Habit
          _buildFieldLabel('Smoking Habit', isRequired: true),
          const SizedBox(height: 8),
          _buildSmokingPills(),
          const SizedBox(height: 16),

          // Drinking Habit
          _buildFieldLabel('Drinking Habit', isRequired: true),
          const SizedBox(height: 8),
          _buildDrinkingPills(),
        ],
      ),
    );
  }

  Widget _buildDietaryGrid() {
    final diets = [
      {'title': 'Vegetarian', 'icon': Icons.eco_outlined},
      {'title': 'Vegan', 'icon': Icons.grass_rounded},
      {'title': 'Eggetarian', 'icon': Icons.egg_alt_outlined},
      {'title': 'Non-Vegetarian', 'icon': Icons.restaurant_rounded},
    ];

    Widget buildItem(Map<String, dynamic> item) {
      final title = item['title'] as String;
      final icon = item['icon'] as IconData;
      final isSelected = _dietaryPreference == title;

      return InkWell(
        onTap: () => setState(() => _dietaryPreference = title),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryMaroon : lavenderBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : darkSlate,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : darkSlate,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buildItem(diets[0])),
            const SizedBox(width: 8),
            Expanded(child: buildItem(diets[1])),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: buildItem(diets[2])),
            const SizedBox(width: 8),
            Expanded(child: buildItem(diets[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildSmokingPills() {
    final options = ['Non-Smoker', 'Occasionally', 'Yes'];
    return Row(
      children: options.map((opt) {
        final isSelected = _smokingHabit == opt;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: opt != options.last ? 8.0 : 0),
            child: InkWell(
              onTap: () => setState(() => _smokingHabit = opt),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryMaroon : lavenderBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Center(
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : darkSlate,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDrinkingPills() {
    final options = ['Non-Drinker', 'Social', 'Occasional', 'Regular'];
    return Row(
      children: options.map((opt) {
        final isSelected = _drinkingHabit == opt;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: opt != options.last ? 6.0 : 0),
            child: InkWell(
              onTap: () => setState(() => _drinkingHabit = opt),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryMaroon : lavenderBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Center(
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : darkSlate,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Sticky Footer Save Button
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: const Color(0x33701A31),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
