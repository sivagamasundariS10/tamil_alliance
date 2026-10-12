import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    'Doesn\'t Matter',
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
  final List<String> _religionOptions = ['Doesn\'t Matter', 'Hindu', 'Christian', 'Muslim', 'Jain'];

  final List<String> _casteOptions = [
    'Doesn\'t Matter',
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
  final Set<String> _selectedCountries = {};
  final TextEditingController _prefStateController = TextEditingController();
  final TextEditingController _prefCountryController = TextEditingController();
  final TextEditingController _prefCityController = TextEditingController();
  final TextEditingController _locationSearchController = TextEditingController();

  // 3. Education, Career & Income
  final List<String> _educationOptions = [
    'Doesn\'t Matter',
    'Any Graduate',
    'B.Tech / B.E',
    'M.S / M.Tech',
    'MBA / PG',
    'MBBS / MD',
    'CA / CS',
  ];
  final Set<String> _customEducations = {};
  final Set<String> _selectedEducation = {};
  final TextEditingController _highestQualificationController = TextEditingController();
  final TextEditingController _degreeSpecializationController = TextEditingController();
  String? _highestEducation;
  List<String> get _educationLevels => const [
    "PhD",
    "Master's Degree",
    "Bachelor's Degree",
    "Diploma",
    "High School",
    "Professional Certification (CA / CS / CFA)",
  ];

  String? _minIncome;
  String? _maxIncome;
  final TextEditingController _minIncomeController = TextEditingController();
  final TextEditingController _maxIncomeController = TextEditingController();

  String _currencyCode = 'INR';
  String _currencySymbol = '₹';

  String get _currencyDisplay {
    if (_currencySymbol.trim().toUpperCase() == _currencyCode.trim().toUpperCase()) {
      return _currencyCode;
    }
    return '$_currencySymbol $_currencyCode';
  }

  List<String> get _currentIncomeList {
    if (_currencyCode == 'INR') {
      return [
        '₹1 Lakhs / yr',
        '₹5 Lakhs / yr',
        '₹10 Lakhs / yr',
        '₹15 Lakhs / yr',
        '₹20 Lakhs / yr',
        '₹30 Lakhs / yr',
        '₹50 Lakhs / yr',
      ];
    } else {
      return [
        '$_currencySymbol 20,000 / yr',
        '$_currencySymbol 35,000 / yr',
        '$_currencySymbol 50,000 / yr',
        '$_currencySymbol 75,000 / yr',
        '$_currencySymbol 100,000 / yr',
        '$_currencySymbol 150,000 / yr',
      ];
    }
  }

  List<String> get _currentIncomeListMax {
    if (_currencyCode == 'INR') {
      return [
        '₹1 Lakhs / yr',
        '₹5 Lakhs / yr',
        '₹10 Lakhs / yr',
        '₹15 Lakhs / yr',
        '₹20 Lakhs / yr',
        '₹30 Lakhs / yr',
        '₹50 Lakhs / yr',
        'Below 1 Cr',
        'Upto 1 Cr - 5 Cr',
        'Upto 5 Cr - 25 Cr',
        'Upto 25 Cr+',
      ];
    } else {
      return [
        '$_currencySymbol 35,000 / yr',
        '$_currencySymbol 50,000 / yr',
        '$_currencySymbol 75,000 / yr',
        '$_currencySymbol 100,000 / yr',
        '$_currencySymbol 150,000 / yr',
        '$_currencySymbol 200,000+ / yr',
        '$_currencySymbol 300,000+ / yr',
        '$_currencySymbol 500,000+ / yr',
      ];
    }
  }

  Map<String, String> _getCurrencyForCountry(String location) {
    final lower = location.toLowerCase().trim();
    if (lower.isEmpty || lower.contains('india') || lower.startsWith('ind')) {
      return {'code': 'INR', 'symbol': '₹'};
    } else if (lower.contains('usa') || lower.contains('united states') || lower == 'us' || lower.contains('america')) {
      return {'code': 'USD', 'symbol': r'$'};
    } else if (lower.contains('uk') || lower.contains('united kingdom') || lower.contains('london') || lower.contains('england') || lower.contains('britain')) {
      return {'code': 'GBP', 'symbol': '£'};
    } else if (lower.contains('singapore') || lower == 'sg') {
      return {'code': 'SGD', 'symbol': r'S$'};
    } else if (lower.contains('uae') || lower.contains('dubai') || lower.contains('emirates') || lower.contains('abu dhabi')) {
      return {'code': 'AED', 'symbol': 'AED'};
    } else if (lower.contains('europe') || lower.contains('germany') || lower.contains('france') || lower.contains('italy') || lower.contains('netherlands') || lower.contains('spain') || lower.contains('ireland')) {
      return {'code': 'EUR', 'symbol': '€'};
    } else if (lower.contains('canada') || lower.contains('toronto') || lower.contains('vancouver')) {
      return {'code': 'CAD', 'symbol': r'C$'};
    } else if (lower.contains('australia') || lower.contains('sydney') || lower.contains('melbourne')) {
      return {'code': 'AUD', 'symbol': r'A$'};
    } else if (lower.contains('malaysia') || lower.contains('kuala lumpur')) {
      return {'code': 'MYR', 'symbol': 'RM'};
    } else if (lower.contains('saudi') || lower.contains('riyadh') || lower.contains('ksa') || lower.contains('jeddah')) {
      return {'code': 'SAR', 'symbol': 'SAR'};
    } else if (lower.contains('qatar') || lower.contains('doha')) {
      return {'code': 'QAR', 'symbol': 'QAR'};
    } else if (lower.contains('kuwait')) {
      return {'code': 'KWD', 'symbol': 'KWD'};
    } else if (lower.contains('oman') || lower.contains('muscat')) {
      return {'code': 'OMR', 'symbol': 'OMR'};
    } else if (lower.contains('bahrain') || lower.contains('manama')) {
      return {'code': 'BHD', 'symbol': 'BHD'};
    } else if (lower.contains('switzerland') || lower.contains('swiss') || lower.contains('zurich')) {
      return {'code': 'CHF', 'symbol': 'CHF'};
    } else if (lower.contains('japan') || lower.contains('tokyo')) {
      return {'code': 'JPY', 'symbol': '¥'};
    } else if (lower.contains('new zealand') || lower == 'nz' || lower.contains('auckland')) {
      return {'code': 'NZD', 'symbol': r'NZ$'};
    } else if (lower.contains('sri lanka') || lower.contains('colombo') || lower.contains('jaffna')) {
      return {'code': 'LKR', 'symbol': 'Rs'};
    } else if (lower.contains('south africa') || lower.contains('johannesburg')) {
      return {'code': 'ZAR', 'symbol': 'R'};
    } else {
      return {'code': 'USD', 'symbol': r'$'};
    }
  }

  void _updateCurrencyFromSelectedCountries() {
    final List<String> countries = [];
    if (_selectedCountries.isNotEmpty) {
      countries.addAll(_selectedCountries);
    } else if (_prefCountryController.text.trim().isNotEmpty) {
      final parts = _prefCountryController.text
          .split(RegExp(r'[,;]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty);
      countries.addAll(parts);
    }

    String newCode = 'INR';
    String newSymbol = '₹';

    if (countries.isEmpty) {
      newCode = 'INR';
      newSymbol = '₹';
    } else if (countries.length == 1) {
      // Single country selected -> strictly map that country's currency
      final mapped = _getCurrencyForCountry(countries.first);
      newCode = mapped['code']!;
      newSymbol = mapped['symbol']!;
    } else {
      // Multiple countries selected:
      // If India is among the selected countries -> INR
      // If India is NOT included (foreign countries only) -> USD
      final bool hasIndia = countries.any((c) {
        final cl = c.toLowerCase().trim();
        return cl.contains('india') || cl.startsWith('ind');
      });

      if (hasIndia) {
        newCode = 'INR';
        newSymbol = '₹';
      } else {
        newCode = 'USD';
        newSymbol = r'$';
      }
    }

    if (_currencyCode != newCode || _currencySymbol != newSymbol) {
      _currencyCode = newCode;
      _currencySymbol = newSymbol;
      if (_minIncome != null && _minIncome != 'Doesn\'t Matter' && !_currentIncomeList.contains(_minIncome)) {
        _minIncome = null;
      }
      if (_maxIncome != null && _maxIncome != 'Doesn\'t Matter' && !_currentIncomeListMax.contains(_maxIncome)) {
        _maxIncome = null;
      }
    }
  }

  void _updateCurrencyFromPreferredCountry(String location) {
    _updateCurrencyFromSelectedCountries();
  }

  bool _isSameCountry(String a, String b) {
    final aL = a.toLowerCase().trim();
    final bL = b.toLowerCase().trim();
    if (aL == bL) return true;
    if (aL == 'india' && (bL.contains('india') || bL.startsWith('ind'))) return true;
    if (bL == 'india' && (aL.contains('india') || aL.startsWith('ind'))) return true;
    if (aL == 'usa' && (bL.contains('usa') || bL.contains('united states') || bL == 'us')) return true;
    if (bL == 'usa' && (aL.contains('usa') || aL.contains('united states') || aL == 'us')) return true;
    if (aL.contains('dubai') && (bL.contains('uae') || bL.contains('dubai') || bL.contains('emirates'))) return true;
    if (bL.contains('dubai') && (aL.contains('uae') || aL.contains('dubai') || aL.contains('emirates'))) return true;
    if (aL.contains('united kingdom') && (bL.contains('uk') || bL.contains('united kingdom') || bL.contains('london') || bL.contains('england'))) return true;
    if (bL.contains('united kingdom') && (aL.contains('uk') || aL.contains('united kingdom') || aL.contains('london') || aL.contains('england'))) return true;
    if (aL == 'singapore' && (bL.contains('singapore') || bL == 'sg')) return true;
    if (bL == 'singapore' && (aL.contains('singapore') || aL == 'sg')) return true;
    if (aL == 'canada' && bL.contains('canada')) return true;
    if (bL == 'canada' && aL.contains('canada')) return true;
    if (aL == 'australia' && bL.contains('australia')) return true;
    if (bL == 'australia' && aL.contains('australia')) return true;
    if (aL == 'malaysia' && bL.contains('malaysia')) return true;
    if (bL == 'malaysia' && aL.contains('malaysia')) return true;
    return false;
  }

  bool _isCountrySelected(String country) {
    final cLower = country.toLowerCase().trim();
    for (final sc in _selectedCountries) {
      if (_isSameCountry(sc, country)) return true;
    }
    // Also check if typed in input controller
    final input = _prefCountryController.text.trim();
    if (input.isNotEmpty && _selectedCountries.isEmpty) {
      final parts = input.split(RegExp(r'[,;]')).map((e) => e.trim());
      for (final p in parts) {
        if (_isSameCountry(p, country)) return true;
      }
    }
    return false;
  }

  void _toggleCountry(String country) {
    _selectedLocations.remove("Doesn't Matter");
    final bool alreadySelected = _isCountrySelected(country);

    if (alreadySelected) {
      _selectedCountries.removeWhere((sc) => _isSameCountry(sc, country));
    } else {
      final chosen = country.contains('Dubai') ? 'UAE / Dubai' : country;
      _selectedCountries.add(chosen);
    }

    _prefCountryController.text = _selectedCountries.join(', ');
    _updateCurrencyFromSelectedCountries();
    setState(() {});
  }

  void _addCountryFromInput([String? text]) {
    final input = (text ?? _prefCountryController.text).trim();
    if (input.isEmpty) return;

    final parts = input
        .split(RegExp(r'[,;]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    _selectedLocations.remove("Doesn't Matter");
    for (final p in parts) {
      if (!_selectedCountries.any((c) => _isSameCountry(c, p))) {
        _selectedCountries.add(p);
      }
    }
    _prefCountryController.text = _selectedCountries.join(', ');
    _updateCurrencyFromSelectedCountries();
    setState(() {});
  }

  void _onCountryInputChanged(String val) {
    if (val.trim().isNotEmpty) {
      _selectedLocations.remove("Doesn't Matter");
    }
    final text = val.trim();
    if (text.isEmpty) {
      _selectedCountries.clear();
    } else {
      final parts = text
          .split(RegExp(r'[,;]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _selectedCountries.clear();
      _selectedCountries.addAll(parts);
    }
    _updateCurrencyFromSelectedCountries();
    setState(() {});
  }

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
    _minIncomeController.dispose();
    _maxIncomeController.dispose();
    _highestQualificationController.dispose();
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
      _selectedCountries.clear();
      _currencyCode = 'INR';
      _currencySymbol = '₹';
      _selectedEducation.clear();
      _selectedEmploymentSectors.clear();
      _minIncome = null;
      _maxIncome = null;
      _minIncomeController.clear();
      _maxIncomeController.clear();
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

  // Categorized Education Degrees (matching reference model)
  static const Map<String, List<String>> _educationDegreeCategories = {
    "--Bachelor's - Engineering / Computer Science--": [
      'Aeronautical Engineering',
      'B.Arch. - Bachelor of Architecture',
      'BCA - Bachelor of Computer Applications',
      'B.E. - Bachelor of Engineering',
      'B.Plan - Bachelor of Planning',
      'B.Sc. IT/CS - Bachelor of Science in IT/Computer Science',
      'B.S. Eng. - Bachelor of Science in Engineering',
      'B.Tech. - Bachelor of Technology',
      'Other Bachelor\'s Degree in Engineering / Computers',
    ],
    "--Master's - Engineering / Computer Science--": [
      'M.Arch. - Master of Architecture',
      'MCA - Master of Computer Applications',
      'M.E. - Master of Engineering',
      'M.Sc. IT/CS - Master of Science in IT/Computer Science',
      'M.S. Eng. - Master of Science in Engineering',
      'M.Tech. - Master of Technology',
      'Other Master\'s Degree in Engineering / Computers',
    ],
    "--Management / Finance / Commerce--": [
      'BBA - Bachelor of Business Administration',
      'B.Com. - Bachelor of Commerce',
      'MBA - Master of Business Administration',
      'M.Com. - Master of Commerce',
      'CA - Chartered Accountant',
      'CS - Company Secretary',
      'ICWA / CMA',
      'CFA',
      'Other Degree in Management / Commerce',
    ],
    "--Medicine & Healthcare--": [
      'MBBS - Bachelor of Medicine & Surgery',
      'MD / MS - Doctor of Medicine',
      'BDS - Bachelor of Dental Surgery',
      'MDS - Master of Dental Surgery',
      'B.Pharm - Bachelor of Pharmacy',
      'M.Pharm - Master of Pharmacy',
      'BAMS / BHMS / BUMS',
      'B.Sc. Nursing',
      'Physiotherapy / Paramedical',
      'Other Degree in Medicine',
    ],
    "--Arts / Science / Law--": [
      'B.A. - Bachelor of Arts',
      'M.A. - Master of Arts',
      'B.Sc. - Bachelor of Science',
      'M.Sc. - Master of Science',
      'B.Ed. / M.Ed.',
      'BL / LLB - Bachelor of Law',
      'ML / LLM - Master of Law',
      'Ph.D. / Doctorate',
      'Other Degree in Arts / Science',
    ],
    "--General / Others--": [
      "Doesn't Matter",
      'Any Graduate',
      'Any Post Graduate',
      'Diploma / Polytechnic',
      'Higher Secondary (12th Std)',
    ],
  };

  void _showEducationPickerModal() {
    if (_highestQualificationController.text.trim().isNotEmpty) {
      final parts = _highestQualificationController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      for (final p in parts) {
        if (!_selectedEducation.contains(p)) {
          _selectedEducation.add(p);
        }
      }
    }

    final searchController = TextEditingController();
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (sheetCtx, scrollController) {
            return StatefulBuilder(
              builder: (ctx, setModalState) {
                final Map<String, List<String>> filteredCategories = {};
                if (searchQuery.trim().isEmpty) {
                  filteredCategories.addAll(_educationDegreeCategories);
                } else {
                  final query = searchQuery.trim().toLowerCase();
                  for (final entry in _educationDegreeCategories.entries) {
                    final matching = entry.value.where((deg) => deg.toLowerCase().contains(query)).toList();
                    if (matching.isNotEmpty) {
                      filteredCategories[entry.key] = matching;
                    }
                  }
                }

                final totalResults = filteredCategories.values.fold<int>(0, (sum, list) => sum + list.length);
                final entriesList = filteredCategories.entries.toList();

                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Header with Close Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.school_rounded, color: Color(0xFF701A33), size: 22),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Select education details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 22),
                              onPressed: () {
                                Navigator.pop(modalCtx);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (val) {
                              setModalState(() {
                                searchQuery = val;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search education details',
                              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18, color: Color(0xFF64748B)),
                                      onPressed: () {
                                        setModalState(() {
                                          searchController.clear();
                                          searchQuery = '';
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),

                      // Scrollable Categorized List
                      Expanded(
                        child: totalResults == 0
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No education details found for "$searchQuery"',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.only(bottom: 16),
                                itemCount: entriesList.length,
                                itemBuilder: (listCtx, catIndex) {
                                  final entry = entriesList[catIndex];
                                  final categoryName = entry.key;
                                  final degrees = entry.value;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category Header (Dashed style from reference)
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        color: const Color(0xFFF8FAFC),
                                        child: Text(
                                          categoryName,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF64748B),
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),

                                      // Degree Items
                                      ...degrees.map((deg) {
                                        final isSelected = _selectedEducation.contains(deg);
                                        return InkWell(
                                          onTap: () {
                                            setModalState(() {
                                              if (deg == "Doesn't Matter") {
                                                if (isSelected) {
                                                  _selectedEducation.remove(deg);
                                                } else {
                                                  _selectedEducation.clear();
                                                  _selectedEducation.add(deg);
                                                }
                                              } else {
                                                _selectedEducation.remove("Doesn't Matter");
                                                if (isSelected) {
                                                  _selectedEducation.remove(deg);
                                                } else {
                                                  _selectedEducation.add(deg);
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
                                              border: const Border(
                                                bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    deg,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                      color: isSelected ? const Color(0xFF701A33) : const Color(0xFF1E293B),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                if (isSelected)
                                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF701A33), size: 20)
                                                else
                                                  const Icon(Icons.circle_outlined, color: Color(0xFFCBD5E1), size: 20),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                      ),

                      // Bottom Action Bar inside Bottom Sheet
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        child: Row(
                          children: [
                            if (_selectedEducation.isNotEmpty) ...[
                              TextButton(
                                onPressed: () {
                                  setModalState(() {
                                    _selectedEducation.clear();
                                  });
                                },
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Spacer(),
                            ] else ...[
                              const Spacer(),
                            ],
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF701A33),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.pop(modalCtx);
                              },
                              child: Text(
                                _selectedEducation.isEmpty
                                    ? 'Done'
                                    : 'Done (${_selectedEducation.length})',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          final nonDoesntMatter = _selectedEducation.where((e) => e != "Doesn't Matter").toList();
          if (nonDoesntMatter.isNotEmpty) {
            _highestQualificationController.text = nonDoesntMatter.join(', ');
          } else if (_selectedEducation.contains("Doesn't Matter")) {
            _highestQualificationController.clear();
          } else {
            _highestQualificationController.clear();
          }
        });
      }
    });
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
    print('   Preferred Country : ${_selectedCountries.isNotEmpty ? _selectedCountries.join(", ") : _prefCountryController.text.trim()}');
    print('   Preferred City    : ${_prefCityController.text.trim()}');
    print('   Preferred Places  : $_selectedLocations');
    print('   Education       : $_selectedEducation');
    print('   Degree/Spec     : ${_degreeSpecializationController.text.trim()}');
    print('   Employment      : $_selectedEmploymentSectors');
    final String minDisplay = _minIncome == 'Doesn\'t Matter'
        ? "Doesn't Matter"
        : (_minIncomeController.text.trim().isNotEmpty ? _minIncomeController.text.trim() : (_minIncome ?? 'Not Specified'));
    final String maxDisplay = _maxIncome == 'Doesn\'t Matter'
        ? "Doesn't Matter"
        : (_maxIncomeController.text.trim().isNotEmpty ? _maxIncomeController.text.trim() : (_maxIncome ?? 'Not Specified'));
    print('   Income Range    : $minDisplay to $maxDisplay ($_currencySymbol $_currencyCode)');
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
    return Scaffold(
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
                // Text(
                //   'Profile Registration',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 15,
                //     fontWeight: FontWeight.w800,
                //     letterSpacing: 0.4,
                //   ),
                // ),
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
                Expanded(child: _buildMaritalChip('Doesn\'t Matter')),
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
                            if (val == 'Doesn\'t Matter') {
                              _selectedMotherTongues.clear();
                              _selectedMotherTongues.add(val);
                            } else {
                              _selectedMotherTongues.remove('Doesn\'t Matter');
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
          // Add Language section (Hidden if Mother Tongue is Doesn't Matter!)
          if (_selectedPrimaryMotherTongue != 'Doesn\'t Matter') ...[
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
                    .where((lang) => lang != _selectedPrimaryMotherTongue && lang != 'Doesn\'t Matter' && lang != 'Any / Doesn\'t Matter')
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
                                      _selectedMotherTongues.remove('Doesn\'t Matter');
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
                                      _selectedMotherTongues.remove('Doesn\'t Matter');
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
                                  _selectedMotherTongues.remove('Doesn\'t Matter');
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
    final bool isReligionDoesntMatter =
        _selectedReligion != null && _selectedReligion!.trim() == "Doesn't Matter";

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
            children: _religionOptions
                .where((rel) {
                  // If "Doesn't Matter" is selected, hide other religions!
                  if (isReligionDoesntMatter) {
                    return rel.trim() == "Doesn't Matter";
                  }
                  return true;
                })
                .map((rel) {
              final isSelected = _selectedReligion?.trim() == rel.trim();
              return _buildSelectableChip(
                label: rel.trim(),
                isSelected: isSelected,
                showCheck: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedReligion = null;
                    } else {
                      _selectedReligion = rel.trim();
                      if (rel.trim() == "Doesn't Matter") {
                        _selectedCastes.clear();
                        _selectedCastes.add("Doesn't Matter");
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),

          // Community & Sub-Caste (Hidden if Religion is Doesn't Matter!)
          if (!isReligionDoesntMatter) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Community',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
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
                ..._casteOptions
                    .where((caste) {
                      // If caste "Doesn't Matter" is selected, hide other communities!
                      if (_selectedCastes.contains("Doesn't Matter")) {
                        return caste == "Doesn't Matter";
                      }
                      return true;
                    })
                    .map((caste) {
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
                        if (caste == 'Doesn\'t Matter') {
                          if (isSelected) {
                            _selectedCastes.remove(caste);
                          } else {
                            _selectedCastes.clear();
                            _selectedCastes.add(caste);
                          }
                        } else {
                          _selectedCastes.remove('Doesn\'t Matter');
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
                if (!_selectedCastes.contains("Doesn't Matter"))
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
    final bool isDoesntMatter = _selectedLocations.contains("Doesn't Matter");

    final bool isIndia = _selectedCountries.any((c) {
          final cl = c.toLowerCase().trim();
          return cl.contains('india') || cl.startsWith('ind');
        }) ||
        _prefCountryController.text.toLowerCase().contains('india') ||
        _prefCountryController.text.toLowerCase().startsWith('ind');

    final bool hasSelectedCountry =
        _selectedCountries.isNotEmpty || _prefCountryController.text.trim().isNotEmpty;
    final bool isOtherCountry = hasSelectedCountry && !isIndia;

    final int totalCount = isDoesntMatter
        ? 1
        : {
            ..._selectedCountries,
            ..._selectedLocations.where((e) => e != "Doesn't Matter"),
            if (isIndia && _prefStateController.text.trim().isNotEmpty) _prefStateController.text.trim(),
            if (_prefCityController.text.trim().isNotEmpty) _prefCityController.text.trim(),
          }.length;

    final addedPlaces =
        _selectedLocations.where((loc) => loc != "Doesn't Matter").toList();

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
              const Text(
                'Preferred Locations',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              Text(
                '$totalCount Selected',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Doesn't Matter Checkbox (Clicking hides/shows everything below)
          _buildDoesntMatterCheckbox(
            label: "Doesn't Matter",
            isChecked: isDoesntMatter,
            onChanged: (val) {
              setState(() {
                if (!val) {
                  _selectedLocations.remove("Doesn't Matter");
                } else {
                  _selectedLocations.clear();
                  _selectedCountries.clear();
                  _prefCountryController.clear();
                  _prefStateController.clear();
                  _prefCityController.clear();
                  _selectedLocations.add("Doesn't Matter");
                  _updateCurrencyFromSelectedCountries();
                }
              });
            },
          ),

          // Hidden when "Doesn't Matter" is clicked!
          if (!isDoesntMatter) ...[
            const SizedBox(height: 14),

            // 1. Country Input Box (Always shown when Doesn't Matter is off)
            _buildLocationInputField(
              label: 'Country',
              hintText: 'e.g. India, Singapore',
              controller: _prefCountryController,
              textInputAction: isIndia ? TextInputAction.next : TextInputAction.done,
              onChanged: _onCountryInputChanged,
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  _addCountryFromInput(val);
                }
              },
            ),
            const SizedBox(height: 8),

            // Quick country suggestion chips (Multi-select enabled!)
            Builder(
              builder: (context) {
                const popularList = [
                  'India',
                  'USA',
                  'Singapore',
                  'UAE / Dubai',
                  'United Kingdom',
                  'Canada',
                  'Australia',
                  'Malaysia',
                ];

                final allChips = [
                  ...popularList,
                  ..._selectedCountries.where((sc) => !popularList.any((p) => _isSameCountry(p, sc))),
                ];

                return Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: allChips.map((c) {
                    final bool isSelected = _isCountrySelected(c);

                    return ChoiceChip(
                      label: Text(c),
                      selected: isSelected,
                      selectedColor: const Color(0xFF701A33),
                      backgroundColor: const Color(0xFFF8FAFC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 11.5,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                      onSelected: (selected) {
                        _toggleCountry(c);
                      },
                    );
                  }).toList(),
                );
              },
            ),

            // 2. When country is India -> Show State AND City
            if (isIndia) ...[
              const SizedBox(height: 12),
              // State Input Box
              _buildLocationInputField(
                label: 'State',
                hintText: 'e.g. Tamil Nadu, Karnataka',
                controller: _prefStateController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              // City / District Input Box
              _buildLocationInputField(
                label: 'City / District',
                hintText: 'e.g. Chennai, Coimbatore',
                controller: _prefCityController,
                textInputAction: TextInputAction.done,
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    setState(() {
                      _selectedLocations.remove("Doesn't Matter");
                      _selectedLocations.add(val.trim());
                    });
                  }
                },
                onAddPressed: () {
                  final val = _prefCityController.text.trim();
                  if (val.isNotEmpty) {
                    setState(() {
                      _selectedLocations.remove("Doesn't Matter");
                      _selectedLocations.add(val);
                    });
                  }
                },
              ),
            ]
            // 3. When country is Other Countries -> Show City ONLY (State hidden)
            else if (isOtherCountry) ...[
              const SizedBox(height: 12),
              _buildLocationInputField(
                label: 'City',
                hintText: 'e.g. New York, Singapore, London',
                controller: _prefCityController,
                textInputAction: TextInputAction.done,
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    setState(() {
                      _selectedLocations.remove("Doesn't Matter");
                      _selectedLocations.add(val.trim());
                    });
                  }
                },
                onAddPressed: () {
                  final val = _prefCityController.text.trim();
                  if (val.isNotEmpty) {
                    setState(() {
                      _selectedLocations.remove("Doesn't Matter");
                      _selectedLocations.add(val);
                    });
                  }
                },
              ),
            ]
            // If Country is empty -> Show a prompt note
            else ...[
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.touch_app_outlined, size: 14, color: Color(0xFF64748B)),
                  SizedBox(width: 6),
                  Text(
                    'Select or type a country above to view state & city',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ],

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
                          _selectedCountries.removeWhere((c) => _isSameCountry(c, loc));
                          _prefCountryController.text = _selectedCountries.join(', ');
                          _updateCurrencyFromSelectedCountries();
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
    void Function(String)? onChanged,
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
                            if (onChanged != null) {
                              onChanged('');
                            }
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
              }
              if (onChanged != null) {
                onChanged(val);
              }
              setState(() {});
            },
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }

  void _showHighestEducationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int selectedCount =
                _selectedEducation.where((e) => e != "Doesn't Matter").length;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Education Level',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (selectedCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF2F4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFF1D5DC)),
                            ),
                            child: Text(
                              '$selectedCount Selected',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF881337),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'You can select multiple qualifications',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.52,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _educationLevels.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 12, thickness: 1, color: Color(0xFFF1F5F9)),
                        itemBuilder: (c, idx) {
                          final level = _educationLevels[idx];
                          final bool isSelected = _selectedEducation.contains(level);

                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            title: Text(
                              level,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFF881337)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF881337), size: 22)
                                : const Icon(Icons.radio_button_unchecked_rounded,
                                    color: Color(0xFFCBD5E1), size: 22),
                            onTap: () {
                              setModalState(() {
                                setState(() {
                                  if (_selectedEducation.contains(level)) {
                                    _selectedEducation.remove(level);
                                  } else {
                                    _selectedEducation.remove("Doesn't Matter");
                                    _selectedEducation.add(level);
                                  }
                                  final activeEdu = _selectedEducation
                                      .where((e) => e != "Doesn't Matter")
                                      .toList();
                                  _highestQualificationController.text =
                                      activeEdu.join(', ');
                                  _highestEducation =
                                      activeEdu.isNotEmpty ? activeEdu.join(', ') : null;
                                });
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF701A33),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          selectedCount > 0
                              ? 'Done ($selectedCount Selected)'
                              : 'Done',
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Card 7: Education
  // ─────────────────────────────────────────────────────────────
  Widget _buildEducationCareerIncomeCard() {
    final bool isDoesntMatterEdu = _selectedEducation.contains("Doesn't Matter");
    final activeEduList =
        _selectedEducation.where((e) => e != "Doesn't Matter").toList();
    final int eduCount = isDoesntMatterEdu ? 1 : activeEduList.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF2F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.circle, size: 6, color: Color(0xFF881337)),
                  SizedBox(width: 6),
                  Text(
                    'Education Details',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Text(
                '$eduCount Selected',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Doesn't Matter Checkbox
          const SizedBox(height: 14),
          _buildDoesntMatterCheckbox(
            label: "Doesn't Matter",
            isChecked: isDoesntMatterEdu,
            onChanged: (selected) {
              setState(() {
                if (selected) {
                  _selectedEducation.clear();
                  _selectedEducation.add("Doesn't Matter");
                  _highestEducation = null;
                  _highestQualificationController.clear();
                  _degreeSpecializationController.clear();
                } else {
                  _selectedEducation.remove("Doesn't Matter");
                }
              });
            },
          ),

          if (!isDoesntMatterEdu) ...[
            const SizedBox(height: 14),

            // 1. Highest Qualification Label
            const Text(
              'Highest Qualification',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 6),

            // Unified Highest Qualification Input Field (Direct Typing + Multi-select Bottom Sheet)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _highestQualificationController,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF1E293B),
                ),
                onChanged: (val) {
                  setState(() {
                    final text = val.trim();
                    if (text.isNotEmpty) {
                      _selectedEducation.remove("Doesn't Matter");
                      final parts = text
                          .split(RegExp(r'[,;]'))
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();
                      _selectedEducation.clear();
                      _selectedEducation.addAll(parts);
                      _highestEducation = parts.join(', ');
                    } else {
                      _selectedEducation.clear();
                      _highestEducation = null;
                    }
                  });
                },
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
                  hintText: 'e.g. Master\'s Degree, Bachelor\'s Degree',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _highestQualificationController,
                        builder: (context, value, _) {
                          if (value.text.isNotEmpty) {
                            return IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  size: 16, color: Color(0xFF94A3B8)),
                              onPressed: () {
                                _highestQualificationController.clear();
                                setState(() {
                                  _selectedEducation.clear();
                                  _highestEducation = null;
                                });
                              },
                              splashRadius: 16,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 22, color: Color(0xFF64748B)),
                        tooltip: 'Select Education Levels',
                        onPressed: _showHighestEducationPicker,
                        splashRadius: 16,
                      ),
                    ],
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
            ),

            // Removable tags for selected qualifications
            if (activeEduList.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: activeEduList.map((edu) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        setState(() {
                          _selectedEducation.remove(edu);
                          final remaining = _selectedEducation
                              .where((e) => e != "Doesn't Matter")
                              .toList();
                          _highestQualificationController.text = remaining.join(', ');
                          _highestEducation =
                              remaining.isNotEmpty ? remaining.join(', ') : null;
                        });
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF701A33),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              edu,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.close_rounded, size: 13, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 16),

            // 2. Degree & Specialization Label
            const Text(
              'Degree & Specialization',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 6),

            // Degree & Specialization Input Box (Exact replica of Image 2)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: _degreeSpecializationController,
                textInputAction: TextInputAction.done,
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
                  hintText: 'e.g. Chartered Accountant (CA) / CS / CFA',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _degreeSpecializationController,
                    builder: (context, value, _) {
                      if (value.text.isNotEmpty) {
                        return IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              size: 16, color: Color(0xFF94A3B8)),
                          onPressed: () {
                            _degreeSpecializationController.clear();
                            setState(() {});
                          },
                          splashRadius: 16,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                onChanged: (val) {
                  setState(() {});
                },
              ),
            ),
          ],
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
    final bool isDoesntMatterIncome = _minIncome == 'Doesn\'t Matter';
    final String prefLocationDisplay;
    if (_selectedLocations.contains("Doesn't Matter")) {
      prefLocationDisplay = "Doesn't Matter";
    } else if (_selectedCountries.isEmpty && _prefCountryController.text.trim().isEmpty) {
      prefLocationDisplay = "India";
    } else if (_selectedCountries.length == 1) {
      prefLocationDisplay = _selectedCountries.first;
    } else if (_selectedCountries.length > 1) {
      final bool hasIndia = _selectedCountries.any((c) {
        final cl = c.toLowerCase().trim();
        return cl.contains('india') || cl.startsWith('ind');
      });
      if (hasIndia) {
        prefLocationDisplay = "${_selectedCountries.join(', ')} (incl. India)";
      } else {
        prefLocationDisplay = "${_selectedCountries.join(', ')} (Foreign)";
      }
    } else {
      prefLocationDisplay = _prefCountryController.text.trim();
    }

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
          // Annual Income Range Header with Currency Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Annual Income Range',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFEFF6FF),
              //     borderRadius: BorderRadius.circular(20),
              //     border: Border.all(color: const Color(0xFFDBEAFE)),
              //   ),
                // child: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     const Icon(Icons.currency_exchange_rounded, size: 12, color: Color(0xFF1D4ED8)),
                //     const SizedBox(width: 4),
                //     Text(
                //       '$_currencySymbol $_currencyCode',
                //       style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
                //     ),
                //   ],
                // ),
              // ),
            ],
          ),
          const SizedBox(height: 8),

          // Currency Mapped to Preferred Location Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), height: 1.3),
                      children: [
                        const TextSpan(text: 'Currency mapped to Preferred Location: '),
                        TextSpan(
                          text: '$prefLocationDisplay → $_currencyDisplay',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1D4ED8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Doesn't Matter Checkbox (Clicking toggles hide/show of min & max income)
          _buildDoesntMatterCheckbox(
            label: "Doesn't Matter",
            isChecked: isDoesntMatterIncome,
            onChanged: (val) {
              setState(() {
                if (!val) {
                  _minIncome = null;
                  _maxIncome = null;
                } else {
                  _minIncome = 'Doesn\'t Matter';
                  _maxIncome = 'Doesn\'t Matter';
                  _minIncomeController.clear();
                  _maxIncomeController.clear();
                }
              });
            },
          ),

          // When Doesn't Matter is active, Minimum and Maximum Income are HIDDEN!
          if (!isDoesntMatterIncome) ...[
            const SizedBox(height: 16),

            // 1. Minimum Income Box Model (First!)
            _buildIncomeInputBox(
              label: 'Minimum Income',
              hintText: _currencyCode == 'INR' ? 'e.g. 5,00,000' : 'e.g. 35,000',
              controller: _minIncomeController,
              textInputAction: TextInputAction.next,
              isMinimum: true,
              suggestions: _currentIncomeList,
              onOpenPicker: () => _showIncomeBottomSheet(isMinimum: true),
              onChanged: (val) {
                _minIncome = val;
              },
            ),
            const SizedBox(height: 14),

            // 2. Maximum Income Box Model (Below Minimum Income!)
            _buildIncomeInputBox(
              label: 'Maximum Income',
              hintText: _currencyCode == 'INR' ? 'e.g. 20,00,000' : 'e.g. 100,000',
              controller: _maxIncomeController,
              textInputAction: TextInputAction.done,
              isMinimum: false,
              suggestions: _currentIncomeListMax,
              onOpenPicker: () => _showIncomeBottomSheet(isMinimum: false),
              onChanged: (val) {
                _maxIncome = val;
              },
            ),
          ],
        ],
      ),
    );
  }

  void _showIncomeBottomSheet({required bool isMinimum}) {
    final title = isMinimum ? 'Select Minimum Income' : 'Select Maximum Income';
    final options = isMinimum ? _currentIncomeList : _currentIncomeListMax;
    final controller = isMinimum ? _minIncomeController : _maxIncomeController;
    final String? currentSelected = isMinimum ? _minIncome : _maxIncome;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: Text(
                        _currencyDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Select an income range or type directly in the box',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.52,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(height: 12, thickness: 1, color: Color(0xFFF1F5F9)),
                    itemBuilder: (c, idx) {
                      final opt = options[idx];
                      final bool isSelected = currentSelected == opt ||
                          controller.text.trim() == opt;

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        title: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF881337), size: 20)
                            : null,
                        onTap: () {
                          setState(() {
                            if (isMinimum) {
                              _minIncome = opt;
                              _minIncomeController.text = opt;
                            } else {
                              _maxIncome = opt;
                              _maxIncomeController.text = opt;
                            }
                          });
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncomeInputBox({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required TextInputAction textInputAction,
    required void Function(String) onChanged,
    required VoidCallback onOpenPicker,
    required List<String> suggestions,
    required bool isMinimum,
  }) {
    final query = controller.text.trim().toLowerCase();
    final matching = query.isEmpty
        ? <String>[]
        : suggestions.where((opt) {
            final cleanOpt = opt.toLowerCase();
            return cleanOpt.contains(query) ||
                cleanOpt.replaceAll(',', '').contains(query);
          }).take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            InkWell(
              onTap: onOpenPicker,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Choose from list',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF701A33), fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.arrow_drop_down_rounded, size: 16, color: Color(0xFF701A33)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Text(
                _currencySymbol,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller,
                          builder: (context, value, _) {
                            if (value.text.isNotEmpty) {
                              return IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                                onPressed: () {
                                  controller.clear();
                                  onChanged('');
                                  setState(() {});
                                },
                                splashRadius: 16,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: Color(0xFF64748B)),
                          tooltip: 'Choose options',
                          onPressed: onOpenPicker,
                          splashRadius: 16,
                        ),
                      ],
                    ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  onChanged: (val) {
                    onChanged(val);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        if (matching.isNotEmpty) ...[
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: matching.map((m) {
              return ActionChip(
                label: Text(m),
                backgroundColor: const Color(0xFFF8FAFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                ),
                labelStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF701A33), fontWeight: FontWeight.w600),
                onPressed: () {
                  setState(() {
                    controller.text = m;
                    if (isMinimum) {
                      _minIncome = m;
                    } else {
                      _maxIncome = m;
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildDoesntMatterCheckbox({
    required String label,
    required bool isChecked,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: isChecked,
                onChanged: (val) => onChanged(val ?? false),
                activeColor: const Color(0xFF701A33),
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(
                  color: Color(0xFF94A3B8),
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
                color: isChecked ? const Color(0xFF701A33) : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Card 8: Dietary Habits
  // ─────────────────────────────────────────────────────────────
  void _onDietaryHabitsTapped(String diet) {
    setState(() {
      if (diet == 'Doesn\'t Matter') {
        if (_selectedDiet.contains('Doesn\'t Matter')) {
          _selectedDiet.remove('Doesn\'t Matter');
        } else {
          _selectedDiet.clear();
          _selectedDiet.add('Doesn\'t Matter');
        }
        return;
      }

      // If choosing any specific diet, clear "Any / Doesn't Matter"
      _selectedDiet.remove('Doesn\'t Matter');

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
                  label: 'Doesn\'t Matter',
                  icon: Icons.all_inclusive_rounded,
                  isSelected: _selectedDiet.contains('Doesn\'t Matter'),
                  onTap: () => _onDietaryHabitsTapped('Doesn\'t Matter'),
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
