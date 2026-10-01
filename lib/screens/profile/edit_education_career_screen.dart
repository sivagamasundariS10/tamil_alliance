import 'package:flutter/material.dart';

class EditEducationCareerScreen extends StatefulWidget {
  final String? initialHighestDegree;
  final String? initialCollege;
  final String? initialProfession;
  final String? initialEmployer;
  final String? initialAnnualIncome;
  final String? initialWorkLocation;

  const EditEducationCareerScreen({
    super.key,
    this.initialHighestDegree,
    this.initialCollege,
    this.initialProfession,
    this.initialEmployer,
    this.initialAnnualIncome,
    this.initialWorkLocation,
  });

  @override
  State<EditEducationCareerScreen> createState() => _EditEducationCareerScreenState();
}

class _EditEducationCareerScreenState extends State<EditEducationCareerScreen> {
  // Theme Colors
  static const Color primaryMaroon = Color(0xFF701A31);
  static const Color darkSlate = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color lavenderBg = Color(0xFFF1F4FD);

  // Education Controllers & State
  String _highestLevel = "Master's / Post Graduate";
  late TextEditingController _degreeController;
  late TextEditingController _collegeController;

  // Career Controllers & State
  String _employmentSector = 'Private / MNC';
  late TextEditingController _professionController;
  late TextEditingController _companyController;
  late TextEditingController _workLocationController;
  String _workArrangement = 'Hybrid';

  // Annual Income Controller & State
  late TextEditingController _incomeController;
  String _currency = '₹ INR';

  @override
  void initState() {
    super.initState();

    // Parse / populate degree
    String initialDeg = widget.initialHighestDegree ?? 'M.S. Software Systems';
    if (initialDeg.contains('+')) {
      _highestLevel = "Master's / Post Graduate";
      _degreeController = TextEditingController(text: initialDeg);
    } else {
      _degreeController = TextEditingController(text: 'M.S. Software Systems');
    }

    _collegeController = TextEditingController(
      text: widget.initialCollege ?? 'Anna University (CEG Guindy)',
    );

    _professionController = TextEditingController(
      text: widget.initialProfession ?? 'Staff Software Engineer',
    );

    _companyController = TextEditingController(
      text: widget.initialEmployer ?? 'Zoho Corporation',
    );

    _workLocationController = TextEditingController(
      text: 'Chennai, Tamil Nadu, India',
    );

    // Extract income number
    String inc = '25,00,000';
    if (widget.initialAnnualIncome != null) {
      final clean = widget.initialAnnualIncome!
          .replaceAll('₹', '')
          .replaceAll('/ Year', '')
          .replaceAll('/ Yr', '')
          .trim();
      if (clean.isNotEmpty) inc = clean;
    }
    _incomeController = TextEditingController(text: inc);

    // Parse work location / arrangement
    if (widget.initialWorkLocation != null) {
      final loc = widget.initialWorkLocation!;
      if (loc.toLowerCase().contains('hybrid')) {
        _workArrangement = 'Hybrid';
      } else if (loc.toLowerCase().contains('remote')) {
        _workArrangement = 'Remote';
      } else if (loc.toLowerCase().contains('onsite') || loc.toLowerCase().contains('office')) {
        _workArrangement = 'Office';
      }
    }
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _collegeController.dispose();
    _professionController.dispose();
    _companyController.dispose();
    _workLocationController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  void _resetToDefault() {
    setState(() {
      _highestLevel = "Master's / Post Graduate";
      _degreeController.text = 'M.S. Software Systems';
      _collegeController.text = 'Anna University (CEG Guindy)';
      _employmentSector = 'Private / MNC';
      _professionController.text = 'Staff Software Engineer';
      _companyController.text = 'Zoho Corporation';
      _workLocationController.text = 'Chennai, Tamil Nadu, India';
      _workArrangement = 'Hybrid';
      _incomeController.text = '25,00,000';
      _currency = '₹ INR';
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
    final deg = _degreeController.text.trim().isEmpty ? 'M.S. Software Systems' : _degreeController.text.trim();
    final col = _collegeController.text.trim().isEmpty ? 'Anna University (CEG Guindy)' : _collegeController.text.trim();
    final prof = _professionController.text.trim().isEmpty ? 'Staff Software Engineer' : _professionController.text.trim();
    final comp = _companyController.text.trim().isEmpty ? 'Zoho Corporation' : _companyController.text.trim();
    final loc = _workLocationController.text.trim().isEmpty ? 'Chennai, Tamil Nadu, India' : _workLocationController.text.trim();
    final inc = _incomeController.text.trim().isEmpty ? '25,00,000' : _incomeController.text.trim();

    // Extract short city name for card
    String shortCity = 'Chennai';
    if (loc.contains(',')) {
      shortCity = loc.split(',').first.trim();
    } else if (loc.isNotEmpty) {
      shortCity = loc;
    }

    final result = {
      'highestDegree': deg,
      'college': col,
      'profession': prof,
      'employer': comp,
      'annualIncome': '₹$inc / Year',
      'workLocation': '$shortCity ($_workArrangement)',
      'rawWorkLocation': loc,
      'employmentSector': _employmentSector,
      'workArrangement': _workArrangement,
      'highestLevel': _highestLevel,
    };

    Navigator.pop(context, result);
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
            // Top Section Tag
            Row(
              children: const [
                Icon(Icons.circle, color: Color(0xFF991B1B), size: 8),
                SizedBox(width: 8),
                Text(
                  'EDUCATION, CAREER & LIFESTYLE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF881337),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 1. Education Details Card
            _buildEducationDetailsCard(),
            const SizedBox(height: 16),

            // 2. Career & Profession Card
            _buildCareerProfessionCard(),
            const SizedBox(height: 16),

            // 3. Annual Income Card
            _buildAnnualIncomeCard(),
            const SizedBox(height: 24),

            // 4. Save Profile Button
            _buildSaveProfileButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF531124),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Helper Field Label
  // ─────────────────────────────────────────────────────────────
  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 13,
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

  // ─────────────────────────────────────────────────────────────
  // 1. Education Details Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationDetailsCard() {
    final degreeLevels = [
      "Master's / Post Graduate",
      "Bachelor's / Undergraduate",
      "Doctorate / Ph.D",
      "Diploma / Polytechnic",
      "Professional Degree (CA/CS)",
      "High School",
    ];

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
                'Education Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: darkSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Highest Level of Education
          _buildFieldLabel('Highest Level of Education', isRequired: true),
          const SizedBox(height: 2),
          const Text(
            'Select the highest formal degree completed',
            style: TextStyle(fontSize: 11, color: textMuted),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: lavenderBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: degreeLevels.contains(_highestLevel) ? _highestLevel : degreeLevels.first,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: textMuted),
                isExpanded: true,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkSlate,
                ),
                items: degreeLevels.map((lvl) {
                  return DropdownMenuItem<String>(
                    value: lvl,
                    child: Row(
                      children: [
                        const Icon(Icons.school_outlined, color: textMuted, size: 18),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            lvl,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _highestLevel = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Degree & Specialization
          _buildFieldLabel('Degree & Specialization', isRequired: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _degreeController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkSlate,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: lavenderBg,
              prefixIcon: const Icon(Icons.history_edu_outlined, color: textMuted, size: 20),
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
              hintText: 'e.g. M.S. Software Systems',
              hintStyle: const TextStyle(color: textMuted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),

          // College / University
          _buildFieldLabel('College / University'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _collegeController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkSlate,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: lavenderBg,
              prefixIcon: const Icon(Icons.account_balance_outlined, color: textMuted, size: 20),
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
              hintText: 'e.g. Anna University (CEG Guindy)',
              hintStyle: const TextStyle(color: textMuted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Career & Profession Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildCareerProfessionCard() {
    final sectors = [
      'Private / MNC',
      'Govt / Public Sector',
      'Business / Entrepreneur',
      'Civil Services',
      'Self Employed',
      'Defense',
      'Not Working',
    ];

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
                'Career & Profession',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: darkSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Employment Sector
          _buildFieldLabel('Employment Sector', isRequired: true),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sectors.map((sec) {
              final isSelected = _employmentSector == sec;
              return InkWell(
                onTap: () => setState(() => _employmentSector = sec),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryMaroon : lavenderBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    sec,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : darkSlate,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Profession / Designation
          _buildFieldLabel('Profession / Designation', isRequired: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _professionController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkSlate,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: lavenderBg,
              prefixIcon: const Icon(Icons.badge_outlined, color: textMuted, size: 20),
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
              hintText: 'e.g. Staff Software Engineer',
              hintStyle: const TextStyle(color: textMuted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),

          // Company / Organization
          _buildFieldLabel('Company / Organization'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _companyController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkSlate,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: lavenderBg,
              prefixIcon: const Icon(Icons.business_outlined, color: textMuted, size: 20),
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
              hintText: 'e.g. Zoho Corporation',
              hintStyle: const TextStyle(color: textMuted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),

          // Work Location
          _buildFieldLabel('Work Location (City, Country)', isRequired: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _workLocationController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkSlate,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: lavenderBg,
              prefixIcon: const Icon(Icons.location_on_outlined, color: textMuted, size: 20),
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
              hintText: 'e.g. Chennai, Tamil Nadu, India',
              hintStyle: const TextStyle(color: textMuted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),

          // Work Arrangement
          const Text(
            'Work Arrangement',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkSlate,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Office', 'Hybrid', 'Remote'].map((arr) {
              final isSelected = _workArrangement == arr;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: arr != 'Remote' ? 8.0 : 0),
                  child: InkWell(
                    onTap: () => setState(() => _workArrangement = arr),
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
                          arr,
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
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Annual Income Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildAnnualIncomeCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.circle, color: Color(0xFF991B1B), size: 10),
                  SizedBox(width: 8),
                  Text(
                    'Annual Income',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: darkSlate,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sync_alt_rounded, color: Color(0xFF1D4ED8), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$_currency (Auto-set)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Currency Mapped info container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFF991B1B),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Currency mapped to Work Location:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: darkSlate),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE7F3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Chennai, India → ₹ INR',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF881337)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Selecting a foreign work location (e.g. USA, UK, Singapore, UAE) automatically updates the currency to USD (\$), GBP (£), SGD, or AED.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF475569), height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Annual Gross Income
          _buildFieldLabel('Annual Gross Income', isRequired: true),
          const SizedBox(height: 6),
          TextFormField(
            controller: _incomeController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: darkSlate,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: lavenderBg,
              prefixIcon: const Icon(Icons.payments_outlined, color: textMuted, size: 20),
              suffixText: 'per annum',
              suffixStyle: const TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w600),
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
              hintText: 'e.g. 25,00,000',
              hintStyle: const TextStyle(color: textMuted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter your total annual gross income',
            style: TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Save Profile Button
  // ─────────────────────────────────────────────────────────────
  Widget _buildSaveProfileButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMaroon,
          foregroundColor: Colors.white,
          elevation: 2,
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
    );
  }
}
