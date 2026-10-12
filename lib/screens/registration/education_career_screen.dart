import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'photos_privacy_screen.dart';

class EducationCareerScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;
  final String? email;

  const EducationCareerScreen({
    super.key,
    this.mobileNumber,
    this.countryCode,
    this.email,
  });

  @override
  State<EducationCareerScreen> createState() => _EducationCareerScreenState();
}

class _EducationCareerScreenState extends State<EducationCareerScreen> {
  final ScrollController _scrollController = ScrollController();

  // 1. Education Details
  String? _highestEducation;
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();

  // 2. Career & Profession
  String? _employmentSector;
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _workLocationController = TextEditingController();
  String? _workArrangement;

  // 3. Annual Income
  final TextEditingController _incomeController = TextEditingController();
  String _currencyCode = 'INR';
  String _currencySymbol = '₹';

  String get _currencyDisplay {
    if (_currencySymbol.trim().toUpperCase() == _currencyCode.trim().toUpperCase()) {
      return _currencyCode;
    }
    return '$_currencySymbol $_currencyCode';
  }

  // 4. Citizenship & Residency
  String? _citizenshipCountry = 'India';
  final TextEditingController _citizenshipCountryController = TextEditingController(text: 'India');
  String? _residencyStatus;

  // 5. Lifestyle & Habits
  final Set<String> _selectedDietaryPreferences = {};
  String? _smokingHabit;
  String? _drinkingHabit;

  // 6. Interests & Cultural Outlook
  final List<String> _selectedHobbies = [];
  final TextEditingController _customHobbyController = TextEditingController();
  String? _culturalOutlook;

  // 7. Bio / About Me
  final TextEditingController _bioController = TextEditingController();
  bool _hasUserEditedBio = false;

  // Track previous visibility states to auto-scroll on new unlock
  bool _prevCareerVisible = false;
  bool _prevIncomeVisible = false;
  bool _prevCitizenshipVisible = false;
  bool _prevLifestyleVisible = false;
  bool _prevInterestsVisible = false;
  bool _prevBioVisible = false;

  bool get _isIndiaCitizenship {
    final country = (_citizenshipCountryController.text.isNotEmpty
            ? _citizenshipCountryController.text
            : (_citizenshipCountry ?? ''))
        .trim()
        .toLowerCase();
    return country == 'india' || country.startsWith('ind');
  }

  // Progressive Validation Getters
  bool get _isEducationComplete =>
      _highestEducation != null && _degreeController.text.trim().isNotEmpty;

  bool get _isCareerComplete =>
      _isEducationComplete &&
      _employmentSector != null &&
      _designationController.text.trim().isNotEmpty &&
      _workLocationController.text.trim().isNotEmpty;

  bool get _isIncomeComplete =>
      _isCareerComplete && _incomeController.text.trim().isNotEmpty;

  bool get _isCitizenshipComplete =>
      _isIncomeComplete &&
      _citizenshipCountryController.text.trim().isNotEmpty &&
      (_isIndiaCitizenship || (_residencyStatus != null && _residencyStatus!.trim().isNotEmpty));

  bool get _isLifestyleComplete =>
      _isCitizenshipComplete &&
      _selectedDietaryPreferences.isNotEmpty &&
      _smokingHabit != null &&
      _drinkingHabit != null;

  bool get _isInterestsComplete =>
      _isLifestyleComplete &&
      _culturalOutlook != null;

  List<String> get _educationLevels => const [
    "PhD",
    "Master's Degree",
    "Bachelor's Degree",
    "Diploma",
    "High School",
    "Professional Certification (CA / CS / CFA)",
  ];

  final List<String> _employmentSectors = [
    'Private / MNC',
    'Govt / Public Sector',
    'Business / Entrepreneur',
    'Civil Services',
    'Self Employed',
    'Defense',
    'Not Working',
  ];

  @override
  void initState() {
    super.initState();
    _degreeController.addListener(_onFieldChanged);
    _collegeController.addListener(_onFieldChanged);
    _designationController.addListener(_onFieldChanged);
    _companyController.addListener(_onFieldChanged);
    _workLocationController.addListener(() {
      _updateCurrencyFromLocation(_workLocationController.text);
      _onFieldChanged();
    });
    _incomeController.addListener(_onFieldChanged);
    _citizenshipCountryController.addListener(() {
      _citizenshipCountry = _citizenshipCountryController.text;
      if (_isIndiaCitizenship) {
        _residencyStatus = null;
      }
      _onFieldChanged();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasUserEditedBio && _bioController.text.trim().isEmpty) {
        _bioController.text = _generateDefaultBio();
        setState(() {});
      }
    });
  }

  void _onFieldChanged() {
    if (!mounted) return;
    if (!_hasUserEditedBio) {
      final updatedBio = _generateDefaultBio();
      if (updatedBio != _bioController.text) {
        _bioController.text = updatedBio;
      }
    }
    _checkAndTriggerAutoScroll();
    setState(() {});
  }

  void _checkAndTriggerAutoScroll() {
    if (!_hasUserEditedBio) {
      final updatedBio = _generateDefaultBio();
      if (updatedBio != _bioController.text) {
        _bioController.text = updatedBio;
      }
    }
    bool shouldScroll = false;

    if (_isEducationComplete && !_prevCareerVisible) {
      _prevCareerVisible = true;
      shouldScroll = true;
    } else if (!_isEducationComplete) {
      _prevCareerVisible = false;
    }

    if (_isCareerComplete && !_prevIncomeVisible) {
      _prevIncomeVisible = true;
      shouldScroll = true;
    } else if (!_isCareerComplete) {
      _prevIncomeVisible = false;
    }

    if (_isIncomeComplete && !_prevCitizenshipVisible) {
      _prevCitizenshipVisible = true;
      shouldScroll = true;
    } else if (!_isIncomeComplete) {
      _prevCitizenshipVisible = false;
    }

    if (_isCitizenshipComplete && !_prevLifestyleVisible) {
      _prevLifestyleVisible = true;
      shouldScroll = true;
    } else if (!_isCitizenshipComplete) {
      _prevLifestyleVisible = false;
    }

    if (_isLifestyleComplete && !_prevInterestsVisible) {
      _prevInterestsVisible = true;
      shouldScroll = true;
    } else if (!_isLifestyleComplete) {
      _prevInterestsVisible = false;
    }

    if (_isInterestsComplete && !_prevBioVisible) {
      _prevBioVisible = true;
      shouldScroll = true;
      if (!_hasUserEditedBio) {
        _bioController.text = _generateDefaultBio();
      }
    } else if (!_isInterestsComplete) {
      _prevBioVisible = false;
    }

    if (shouldScroll) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _degreeController.dispose();
    _collegeController.dispose();
    _designationController.dispose();
    _companyController.dispose();
    _workLocationController.dispose();
    _incomeController.dispose();
    _citizenshipCountryController.dispose();
    _customHobbyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _updateCurrencyFromLocation(String location) {
    final lower = location.toLowerCase();
    if (lower.contains('usa') || lower.contains('united states') || lower.contains('us') || lower.contains('america')) {
      _currencyCode = 'USD';
      _currencySymbol = r'$';
    } else if (lower.contains('uk') || lower.contains('united kingdom') || lower.contains('london') || lower.contains('england')) {
      _currencyCode = 'GBP';
      _currencySymbol = '£';
    } else if (lower.contains('singapore') || lower.contains('sg')) {
      _currencyCode = 'SGD';
      _currencySymbol = r'S$';
    } else if (lower.contains('uae') || lower.contains('dubai') || lower.contains('emirates') || lower.contains('abu dhabi')) {
      _currencyCode = 'AED';
      _currencySymbol = 'AED';
    } else if (lower.contains('europe') || lower.contains('germany') || lower.contains('france') || lower.contains('italy') || lower.contains('netherlands') || lower.contains('spain') || lower.contains('ireland')) {
      _currencyCode = 'EUR';
      _currencySymbol = '€';
    } else if (lower.contains('canada') || lower.contains('toronto') || lower.contains('vancouver')) {
      _currencyCode = 'CAD';
      _currencySymbol = r'C$';
    } else if (lower.contains('australia') || lower.contains('sydney') || lower.contains('melbourne')) {
      _currencyCode = 'AUD';
      _currencySymbol = r'A$';
    } else if (lower.contains('malaysia') || lower.contains('kuala lumpur')) {
      _currencyCode = 'MYR';
      _currencySymbol = 'RM';
    } else if (lower.contains('saudi') || lower.contains('riyadh') || lower.contains('ksa') || lower.contains('jeddah')) {
      _currencyCode = 'SAR';
      _currencySymbol = 'SAR';
    } else if (lower.contains('qatar') || lower.contains('doha')) {
      _currencyCode = 'QAR';
      _currencySymbol = 'QAR';
    } else if (lower.contains('kuwait')) {
      _currencyCode = 'KWD';
      _currencySymbol = 'KWD';
    } else if (lower.contains('oman') || lower.contains('muscat')) {
      _currencyCode = 'OMR';
      _currencySymbol = 'OMR';
    } else if (lower.contains('bahrain') || lower.contains('manama')) {
      _currencyCode = 'BHD';
      _currencySymbol = 'BHD';
    } else if (lower.contains('switzerland') || lower.contains('swiss') || lower.contains('zurich')) {
      _currencyCode = 'CHF';
      _currencySymbol = 'CHF';
    } else if (lower.contains('japan') || lower.contains('tokyo')) {
      _currencyCode = 'JPY';
      _currencySymbol = '¥';
    } else if (lower.contains('new zealand') || lower.contains('nz') || lower.contains('auckland')) {
      _currencyCode = 'NZD';
      _currencySymbol = r'NZ$';
    } else if (lower.contains('sri lanka') || lower.contains('colombo') || lower.contains('jaffna')) {
      _currencyCode = 'LKR';
      _currencySymbol = 'Rs';
    } else if (lower.contains('south africa') || lower.contains('johannesburg')) {
      _currencyCode = 'ZAR';
      _currencySymbol = 'R';
    } else {
      _currencyCode = 'INR';
      _currencySymbol = '₹';
    }
  }

  void _showCurrencyPicker() {
    final currencies = [
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee (India)'},
      {'code': 'USD', 'symbol': r'$', 'name': 'US Dollar (USA)'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound (United Kingdom / UK)'},
      {'code': 'SGD', 'symbol': r'S$', 'name': 'Singapore Dollar (Singapore)'},
      {'code': 'AED', 'symbol': 'AED', 'name': 'UAE Dirham (Dubai / UAE)'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro (Germany / France / Europe)'},
      {'code': 'CAD', 'symbol': r'C$', 'name': 'Canadian Dollar (Canada)'},
      {'code': 'AUD', 'symbol': r'A$', 'name': 'Australian Dollar (Australia)'},
      {'code': 'MYR', 'symbol': 'RM', 'name': 'Malaysian Ringgit (Malaysia)'},
      {'code': 'SAR', 'symbol': 'SAR', 'name': 'Saudi Riyal (Saudi Arabia)'},
      {'code': 'QAR', 'symbol': 'QAR', 'name': 'Qatari Riyal (Qatar)'},
      {'code': 'KWD', 'symbol': 'KWD', 'name': 'Kuwaiti Dinar (Kuwait)'},
      {'code': 'OMR', 'symbol': 'OMR', 'name': 'Omani Rial (Oman)'},
      {'code': 'BHD', 'symbol': 'BHD', 'name': 'Bahraini Dinar (Bahrain)'},
      {'code': 'CHF', 'symbol': 'CHF', 'name': 'Swiss Franc (Switzerland)'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen (Japan)'},
      {'code': 'NZD', 'symbol': r'NZ$', 'name': 'New Zealand Dollar (New Zealand)'},
      {'code': 'LKR', 'symbol': 'Rs', 'name': 'Sri Lankan Rupee (Sri Lanka)'},
      {'code': 'ZAR', 'symbol': 'R', 'name': 'South African Rand (South Africa)'},
      {'code': 'HKD', 'symbol': r'HK$', 'name': 'Hong Kong Dollar (Hong Kong)'},
      {'code': 'SEK', 'symbol': 'kr', 'name': 'Swedish Krona (Sweden)'},
      {'code': 'NOK', 'symbol': 'kr', 'name': 'Norwegian Krone (Norway)'},
      {'code': 'DKK', 'symbol': 'kr', 'name': 'Danish Krone (Denmark)'},
      {'code': 'PLN', 'symbol': 'zł', 'name': 'Polish Zloty (Poland)'},
      {'code': 'THB', 'symbol': '฿', 'name': 'Thai Baht (Thailand)'},
      {'code': 'KRW', 'symbol': '₩', 'name': 'South Korean Won (South Korea)'},
      {'code': 'IDR', 'symbol': 'Rp', 'name': 'Indonesian Rupiah (Indonesia)'},
      {'code': 'PHP', 'symbol': '₱', 'name': 'Philippine Peso (Philippines)'},
      {'code': 'BDT', 'symbol': '৳', 'name': 'Bangladeshi Taka (Bangladesh)'},
      {'code': 'RUB', 'symbol': '₽', 'name': 'Russian Ruble (Russia)'},
      {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan (China)'},
      {'code': 'BRL', 'symbol': r'R$', 'name': 'Brazilian Real (Brazil)'},
      {'code': 'MXN', 'symbol': r'Mex$', 'name': 'Mexican Peso (Mexico)'},
    ];

    String searchQuery = '';

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
            final filteredCurrencies = currencies.where((item) {
              final q = searchQuery.toLowerCase().trim();
              if (q.isEmpty) return true;
              return item['name']!.toLowerCase().contains(q) ||
                  item['code']!.toLowerCase().contains(q) ||
                  item['symbol']!.toLowerCase().contains(q);
            }).toList();

            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
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
                            'Select Income Currency',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${filteredCurrencies.length} Countries',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search Box
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setModalState(() {
                              searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search country or currency...',
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16, color: Color(0xFF64748B)),
                                    onPressed: () {
                                      setModalState(() {
                                        searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            filled: false,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: filteredCurrencies.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.shade400),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No country found for "$searchQuery"',
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredCurrencies.length,
                                separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                itemBuilder: (c, idx) {
                                  final item = filteredCurrencies[idx];
                                  final isSelected = _currencyCode == item['code'];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    leading: Container(
                                      width: 44,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF881337).withValues(alpha: 0.1)
                                            : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        item['symbol']!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      item['name']!,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF881337), size: 20)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _currencyCode = item['code']!;
                                        _currencySymbol = item['symbol']!;
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
              ),
            );
          },
        );
      },
    );
  }

  void _showEducationPicker() {
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
                const Text(
                  'Select Highest Level of Education',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _educationLevels.length,
                  separatorBuilder: (_, __) => const Divider(height: 12, thickness: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (c, idx) {
                    final level = _educationLevels[idx];
                    final isSelected = _highestEducation == level;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      title: Text(
                        level,
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
                        setState(() => _highestEducation = level);
                        Navigator.pop(ctx);
                        _checkAndTriggerAutoScroll();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<String> _citizenshipCountries = [
    'India',
    'United States (USA)',
    'United Kingdom (UK)',
    'Canada',
    'Australia',
    'Singapore',
    'United Arab Emirates (UAE)',
    'Malaysia',
    'Germany',
    'New Zealand',
    'Saudi Arabia',
    'Qatar',
    'Kuwait',
    'Oman',
    'Bahrain',
    'France',
    'Ireland',
    'Switzerland',
    'Netherlands',
    'Italy',
    'Sweden',
    'Norway',
    'Denmark',
    'South Africa',
    'Japan',
    'Sri Lanka',
  ];

  void _showCitizenshipCountryPicker() {
    String searchQuery = '';
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
            final filteredCountries = _citizenshipCountries.where((c) {
              final q = searchQuery.toLowerCase().trim();
              if (q.isEmpty) return true;
              return c.toLowerCase().contains(q);
            }).toList();

            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
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
                      const Text(
                        'Select Citizenship Country',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setModalState(() {
                              searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search country...',
                            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16, color: Color(0xFF64748B)),
                                    onPressed: () {
                                      setModalState(() {
                                        searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredCountries.isEmpty && searchQuery.trim().isNotEmpty
                            ? ListTile(
                                leading: const Icon(Icons.add_circle_outline, color: Color(0xFF881337)),
                                title: Text(
                                  'Use "${searchQuery.trim()}"',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF881337),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    final selected = searchQuery.trim();
                                    _citizenshipCountry = selected;
                                    _citizenshipCountryController.text = selected;
                                    if (_isIndiaCitizenship) {
                                      _residencyStatus = null;
                                    }
                                  });
                                  Navigator.pop(ctx);
                                  _checkAndTriggerAutoScroll();
                                },
                              )
                            : ListView.separated(
                                itemCount: filteredCountries.length,
                                separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                itemBuilder: (c, idx) {
                                  final country = filteredCountries[idx];
                                  final isSelected = _citizenshipCountry == country;
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    leading: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF881337).withValues(alpha: 0.1)
                                            : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.public, size: 18, color: Color(0xFF64748B)),
                                    ),
                                    title: Text(
                                      country,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF881337), size: 20)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _citizenshipCountry = country;
                                        _citizenshipCountryController.text = country;
                                        if (_isIndiaCitizenship) {
                                          _residencyStatus = null;
                                        }
                                      });
                                      Navigator.pop(ctx);
                                      _checkAndTriggerAutoScroll();
                                    },
                                  );
                                },
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

  void _addCustomHobby() {
    final text = _customHobbyController.text.trim();
    if (text.isNotEmpty && !_selectedHobbies.contains(text)) {
      setState(() {
        _selectedHobbies.add(text);
        _customHobbyController.clear();
      });
      _checkAndTriggerAutoScroll();
    }
  }

  void _removeHobby(String hobby) {
    setState(() {
      _selectedHobbies.remove(hobby);
    });
    _checkAndTriggerAutoScroll();
  }

  String _generateDefaultBio() {
    final List<String> sentences = [];

    final deg = _degreeController.text.trim();
    final college = _collegeController.text.trim();
    final desig = _designationController.text.trim();
    final comp = _companyController.text.trim();
    final loc = _workLocationController.text.trim();

    // 1. Education
    if (deg.isNotEmpty && college.isNotEmpty) {
      sentences.add("I have completed my $deg from $college.");
    } else if (deg.isNotEmpty) {
      sentences.add("I have completed my education in $deg.");
    } else if (_highestEducation != null && _highestEducation!.isNotEmpty) {
      sentences.add("I hold a $_highestEducation degree.");
    }

    // 2. Profession & Company & Location
    if (desig.isNotEmpty && comp.isNotEmpty && loc.isNotEmpty) {
      sentences.add("Currently, I am working as a $desig at $comp in $loc.");
    } else if (desig.isNotEmpty && comp.isNotEmpty) {
      sentences.add("Currently, I am working as a $desig at $comp.");
    } else if (desig.isNotEmpty && loc.isNotEmpty) {
      sentences.add("I am working as a $desig based in $loc.");
    } else if (desig.isNotEmpty) {
      sentences.add("I am working as a $desig.");
    } else if (_employmentSector != null && _employmentSector != 'Not Working') {
      sentences.add("I am employed in the $_employmentSector sector.");
    }

    // 3. Citizenship / Country if abroad
    if (_citizenshipCountry != null && _citizenshipCountry != 'India') {
      if (_residencyStatus != null && _residencyStatus!.isNotEmpty) {
        sentences.add("I am currently living in $_citizenshipCountry on $_residencyStatus.");
      } else {
        sentences.add("I am currently living in $_citizenshipCountry.");
      }
    }

    // 4. Cultural outlook & values
    if (_culturalOutlook != null) {
      if (_culturalOutlook == 'Traditional') {
        sentences.add("I am a family-oriented person who values traditional Tamil customs and ethics.");
      } else if (_culturalOutlook == 'Modern & Traditional') {
        sentences.add("I maintain a healthy balance between modern thoughts and traditional family values.");
      } else if (_culturalOutlook == 'Moderate') {
        sentences.add("I have a balanced and practical outlook towards life and relationships.");
      } else if (_culturalOutlook == 'Liberal') {
        sentences.add("I have an open-minded and progressive approach towards life.");
      } else if (_culturalOutlook == 'Orthodox') {
        sentences.add("I have deep faith in our traditions, spirituality, and cultural roots.");
      }
    }

    // 5. Dietary lifestyle
    if (_selectedDietaryPreferences.isNotEmpty) {
      if (_selectedDietaryPreferences.contains('Veg') && _selectedDietaryPreferences.contains('Non-Veg')) {
        sentences.add("I enjoy both vegetarian and non-vegetarian food.");
      } else if (_selectedDietaryPreferences.contains('Veg') && _selectedDietaryPreferences.contains('Eggetarian')) {
        sentences.add("I follow a vegetarian diet and consume eggs (eggetarian).");
      } else if (_selectedDietaryPreferences.contains('Veg')) {
        sentences.add("I follow a vegetarian lifestyle.");
      } else if (_selectedDietaryPreferences.contains('Vegan')) {
        sentences.add("I follow a conscious vegan lifestyle.");
      } else if (_selectedDietaryPreferences.contains('Eggetarian')) {
        sentences.add("I am an eggetarian.");
      } else if (_selectedDietaryPreferences.contains('Non-Veg')) {
        sentences.add("I enjoy non-vegetarian food.");
      }
    }

    // 6. Hobbies
    if (_selectedHobbies.isNotEmpty) {
      final hobbies = _selectedHobbies.take(3).join(', ');
      sentences.add("In my leisure time, I enjoy $hobbies.");
    }

    // 7. Life partner expectations
    sentences.add("Looking for an understanding, caring, and compatible partner to walk together through life's journey.");

    return sentences.join(' ');
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Education & Career Draft Saved Successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();

    if (!_isInterestsComplete) {
      String message = 'Please fill all mandatory fields marked with *';
      if (!_isEducationComplete) {
        message = 'Please select Highest Education and enter Degree *';
      } else if (!_isCareerComplete) {
        message = 'Please select Sector, enter Designation & Work Location *';
      } else if (!_isIncomeComplete) {
        message = 'Please enter Annual Gross Income *';
      } else if (!_isCitizenshipComplete) {
        message = 'Please select Citizenship *';
      } else if (!_isLifestyleComplete) {
        message = 'Please select Dietary, Smoking & Drinking preferences *';
      } else if (!_isInterestsComplete) {
        message = 'Please select Cultural Outlook *';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFE11D48),
          duration: const Duration(milliseconds: 2000),
        ),
      );
      return;
    }

    if (_bioController.text.trim().isEmpty) {
      _bioController.text = _generateDefaultBio();
    }

    print('====================================================');
    print(' [USER INPUT: STEP 3 - EDUCATION, CAREER & LIFESTYLE]');
    print('   Highest Education  : $_highestEducation');
    print('   Degree             : ${_degreeController.text.trim()}');
    print('   College/University : ${_collegeController.text.trim()}');
    print('   Employment Sector  : $_employmentSector');
    print('   Designation        : ${_designationController.text.trim()}');
    print('   Company            : ${_companyController.text.trim()}');
    print('   Work Location      : ${_workLocationController.text.trim()}');
    print('   Work Arrangement   : $_workArrangement');
    print('   Annual Income      : $_currencySymbol ${_incomeController.text.trim()}');
    print('   Citizenship Country: $_citizenshipCountry');
    print('   Residency Status   : $_residencyStatus');
    print('   Dietary Preference : ${_selectedDietaryPreferences.join(", ")}');
    print('   Smoking Habit      : $_smokingHabit');
    print('   Drinking Habit     : $_drinkingHabit');
    print('   Hobbies            : $_selectedHobbies');
    print('   Cultural Outlook   : $_culturalOutlook');
    print('   About Me / Bio     : ${_bioController.text.trim()}');
    print('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Education & Career details saved!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotosPrivacyScreen(
          mobileNumber: widget.mobileNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SafeArea(
        bottom: false,
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
                    // A) Subheader
                    _buildStepSubheader(),
                    const SizedBox(height: 14),

                    // B) Education Details Card (Always Visible)
                    _buildEducationCard(),
                    const SizedBox(height: 14),

                    // C) Career & Profession Card (Revealed after Education)
                    _buildProgressiveCard(
                      isVisible: _isEducationComplete,
                      child: _buildCareerCard(),
                    ),

                    // D) Annual Income Card (Revealed after Career)
                    _buildProgressiveCard(
                      isVisible: _isCareerComplete,
                      child: _buildIncomeCard(),
                    ),

                    // E) Citizenship Card (Revealed after Income)
                    _buildProgressiveCard(
                      isVisible: _isIncomeComplete,
                      child: _buildCitizenshipCard(),
                    ),

                    // F) Lifestyle & Habits Card (Revealed after Citizenship)
                    _buildProgressiveCard(
                      isVisible: _isCitizenshipComplete,
                      child: _buildLifestyleCard(),
                    ),

                    // G) Interests & Cultural Outlook Card (Revealed after Lifestyle)
                    _buildProgressiveCard(
                      isVisible: _isLifestyleComplete,
                      child: _buildInterestsCard(),
                    ),

                    // H) Few Words About Me Card (Revealed after Interests)
                    _buildProgressiveCard(
                      isVisible: _isInterestsComplete,
                      child: _buildBioCard(),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progressive Animated Card Container
  Widget _buildProgressiveCard({
    required bool isVisible,
    required Widget child,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: isVisible
          ? AnimatedOpacity(
              duration: const Duration(milliseconds: 320),
              opacity: isVisible ? 1.0 : 0.0,
              curve: Curves.easeIn,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: child,
              ),
            )
          : const SizedBox.shrink(),
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
                  'STEP 3 OF 5',
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
                child: const Center(
                  child: Icon(Icons.favorite_rounded, color: Color(0xFFE5A93C), size: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3 Subheader
  Widget _buildStepSubheader() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF881337),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'EDUCATION, CAREER & LIFESTYLE',
              style: TextStyle(
                color: Color(0xFF881337),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // B) Education Details Card
  Widget _buildEducationCard() {
    return _buildCardWrapper(
      title: 'Education Details',
      children: [
        _buildMandatoryLabel('Highest Level of Education'),
        const SizedBox(height: 2),
        const Text(
          'Select the highest formal degree completed',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _showEducationPicker,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE8EBFA),
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.school_outlined, size: 18, color: Color(0xFF64748B)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _highestEducation ?? 'Select Education Level',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _highestEducation != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Degree & Specialization'),
        const SizedBox(height: 6),
        _buildSingleInputField(
          controller: _degreeController,
          hintText: _highestEducation?.contains('Professional Certification') == true
              ? 'e.g. Chartered Accountant (CA) / CS / CFA'
              : 'e.g. M.S. Software Systems / B.Tech / MBA',
          prefixIcon: Icons.workspace_premium_outlined,
        ),
        const SizedBox(height: 14),

        const Text(
          'College / University',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        _buildSingleInputField(
          controller: _collegeController,
          hintText: 'e.g. Anna University (CEG Guindy) / IIT',
          prefixIcon: Icons.account_balance_outlined,
        ),
      ],
    );
  }

  // C) Career & Profession Card
  Widget _buildCareerCard() {
    return _buildCardWrapper(
      title: 'Career & Profession',
      children: [
        _buildMandatoryLabel('Employment Sector'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _employmentSectors.map((sector) {
            final isSelected = _employmentSector == sector;
            return InkWell(
              onTap: () {
                setState(() => _employmentSector = sector);
                _checkAndTriggerAutoScroll();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFFF1F3FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF881337) : const Color(0xFFE8EBFA),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Text(
                  sector,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Profession / Designation'),
        const SizedBox(height: 6),
        _buildSingleInputField(
          controller: _designationController,
          hintText: 'e.g. Staff Software Engineer / Manager',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 14),

        const Text(
          'Company / Organization',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        _buildSingleInputField(
          controller: _companyController,
          hintText: 'e.g. Zoho Corporation / TCS / Amazon',
          prefixIcon: Icons.apartment_outlined,
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Work Location'),
        const SizedBox(height: 6),
        _buildSingleInputField(
          controller: _workLocationController,
          hintText: 'e.g. Chennai, Tamil Nadu, India',
          prefixIcon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 14),

        const Text(
          'Work Arrangement',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildPillSelectTile(
                label: 'Office',
                isSelected: _workArrangement == 'Office',
                onTap: () => setState(() => _workArrangement = 'Office'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Hybrid',
                isSelected: _workArrangement == 'Hybrid',
                onTap: () => setState(() => _workArrangement = 'Hybrid'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Remote',
                isSelected: _workArrangement == 'Remote',
                onTap: () => setState(() => _workArrangement = 'Remote'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // D) Annual Income Card
  Widget _buildIncomeCard() {
    return _buildCardWrapper(
      title: 'Annual Income',
      trailing: InkWell(
        onTap: _showCurrencyPicker,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.swap_horiz_rounded, size: 14, color: Color(0xFF1E40AF)),
              const SizedBox(width: 4),
              Text(
                '$_currencyDisplay (Auto-set)',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E40AF),
                ),
              ),
            ],
          ),
        ),
      ),
      children: [
        // Currency mapped banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDBEAFE), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currency mapped to Work Location:',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_workLocationController.text.isNotEmpty ? _workLocationController.text : "India"} -> $_currencyDisplay',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Selecting a foreign work location (e.g. USA, UK, Singapore, UAE) automatically updates the currency to USD (\$), GBP (£), SGD, or AED.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3B82F6),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Annual Gross Income'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _incomeController,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F3FB),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.payments_outlined, size: 18, color: const Color(0xFF64748B)),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            suffixText: 'per annum',
            suffixStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
            hintText: 'e.g. 25,00,000',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter your total annual gross income',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  // E) Citizenship & Residency Card
  Widget _buildCitizenshipCard() {
    final bool isIndia = _isIndiaCitizenship;

    return _buildCardWrapper(
      title: 'Citizenship',
      children: [
        _buildMandatoryLabel('Citizenship Country'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _citizenshipCountryController,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F3FB),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.public_outlined, size: 18, color: Color(0xFF64748B)),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            hintText: 'Enter or select country',
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Color(0xFF64748B)),
              onPressed: _showCitizenshipCountryPicker,
              splashRadius: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _citizenshipCountry = val;
              if (_isIndiaCitizenship) {
                _residencyStatus = null;
              }
            });
            _checkAndTriggerAutoScroll();
          },
        ),

        // Residency Status is hidden when Citizenship Country is India!
        // Only shown when other country names are typed or selected.
        if (!isIndia) ...[
          const SizedBox(height: 14),
          _buildMandatoryLabel('Residency Status'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            key: ValueKey('residency_${_citizenshipCountryController.text}'),
            initialValue: _residencyStatus,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 20),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF1F3FB),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.badge_outlined, size: 18, color: Color(0xFF64748B)),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
              hintText: 'Select Residency Status',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
              ),
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            items: const [
              DropdownMenuItem(
                value: 'Citizenship',
                child: Text('Citizenship'),
              ),
              DropdownMenuItem(
                value: 'Work Visa',
                child: Text('Work Visa'),
              ),
              DropdownMenuItem(
                value: 'Permanent Resident (PR)',
                child: Text('Permanent Resident (PR)'),
              ),
              DropdownMenuItem(
                value: 'Student Visa',
                child: Text('Student Visa'),
              ),
              DropdownMenuItem(
                value: 'Temporary Visa',
                child: Text('Temporary Visa'),
              ),
            ],
            onChanged: (val) {
              setState(() {
                _residencyStatus = val;
              });
              FocusScope.of(context).unfocus();
              _checkAndTriggerAutoScroll();
            },
          ),
        ],
      ],
    );
  }

  void _onDietaryPreferenceTapped(String diet) {
    setState(() {
      if (_selectedDietaryPreferences.contains(diet)) {
        _selectedDietaryPreferences.remove(diet);
      } else {
        if (_selectedDietaryPreferences.isEmpty) {
          _selectedDietaryPreferences.add(diet);
        } else if (_selectedDietaryPreferences.length == 1) {
          final current = _selectedDietaryPreferences.first;
          // Only permitted 2-item pairs: {Veg, Non-Veg} or {Veg, Eggetarian}
          final isAllowedPair = (current == 'Veg' && (diet == 'Non-Veg' || diet == 'Eggetarian')) ||
              ((current == 'Non-Veg' || current == 'Eggetarian') && diet == 'Veg');
          if (isAllowedPair) {
            _selectedDietaryPreferences.add(diet);
          } else {
            // Not an allowed combination (e.g. Non-Veg + Eggetarian, or Vegan + anything)
            // Replace with newly tapped selection
            _selectedDietaryPreferences.clear();
            _selectedDietaryPreferences.add(diet);
          }
        } else {
          // Already 2 selected: {Veg, Non-Veg} or {Veg, Eggetarian}
          if (diet == 'Eggetarian' && _selectedDietaryPreferences.contains('Veg')) {
            _selectedDietaryPreferences.clear();
            _selectedDietaryPreferences.addAll(['Veg', 'Eggetarian']);
          } else if (diet == 'Non-Veg' && _selectedDietaryPreferences.contains('Veg')) {
            _selectedDietaryPreferences.clear();
            _selectedDietaryPreferences.addAll(['Veg', 'Non-Veg']);
          } else {
            // Switched to another single option (e.g. Vegan or Veg)
            _selectedDietaryPreferences.clear();
            _selectedDietaryPreferences.add(diet);
          }
        }
      }
    });
    _checkAndTriggerAutoScroll();
  }

  // F) Lifestyle & Habits Card
  Widget _buildLifestyleCard() {
    return _buildCardWrapper(
      title: 'Lifestyle & Habits',
      children: [
        _buildMandatoryLabel('Dietary Preference'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDietTile(
                label: 'Veg',
                icon: Icons.eco_outlined,
                isSelected: _selectedDietaryPreferences.contains('Veg'),
                onTap: () => _onDietaryPreferenceTapped('Veg'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDietTile(
                label: 'Non-Veg',
                icon: Icons.restaurant_outlined,
                isSelected: _selectedDietaryPreferences.contains('Non-Veg'),
                onTap: () => _onDietaryPreferenceTapped('Non-Veg'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDietTile(
                label: 'Eggetarian',
                icon: Icons.egg_outlined,
                isSelected: _selectedDietaryPreferences.contains('Eggetarian'),
                onTap: () => _onDietaryPreferenceTapped('Eggetarian'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDietTile(
                label: 'Vegan',
                icon: Icons.grass_outlined,
                isSelected: _selectedDietaryPreferences.contains('Vegan'),
                onTap: () => _onDietaryPreferenceTapped('Vegan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Smoking Habit'),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildPillSelectTile(
                label: 'Non-Smoker',
                isSelected: _smokingHabit == 'Non-Smoker',
                onTap: () {
                  setState(() => _smokingHabit = 'Non-Smoker');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Occasionally',
                isSelected: _smokingHabit == 'Occasionally',
                onTap: () {
                  setState(() => _smokingHabit = 'Occasionally');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Yes',
                isSelected: _smokingHabit == 'Yes',
                onTap: () {
                  setState(() => _smokingHabit = 'Yes');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Drinking Habit'),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildPillSelectTile(
                label: 'Non-Drinker',
                isSelected: _drinkingHabit == 'Non-Drinker',
                onTap: () {
                  setState(() => _drinkingHabit = 'Non-Drinker');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Social',
                isSelected: _drinkingHabit == 'Social',
                onTap: () {
                  setState(() => _drinkingHabit = 'Social');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Occasional',
                isSelected: _drinkingHabit == 'Occasional',
                onTap: () {
                  setState(() => _drinkingHabit = 'Occasional');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Regular',
                isSelected: _drinkingHabit == 'Regular',
                onTap: () {
                  setState(() => _drinkingHabit = 'Regular');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // G) Interests & Cultural Outlook Card
  Widget _buildInterestsCard() {
    return _buildCardWrapper(
      title: 'Interests & Cultural Outlook',
      trailing: const Text(
        '(Select 1 or more)',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2563EB),
        ),
      ),
      children: [
        _buildOptionalLabel('Hobbies & Passions'),
        const SizedBox(height: 8),
        if (_selectedHobbies.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedHobbies.map((hobby) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF881337),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hobby,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => _removeHobby(hobby),
                      child: const Icon(Icons.close_rounded, size: 14, color: Colors.white70),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],

        // Quick Suggestions
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            'Carnatic Music',
            'Bharatanatyam',
            'Reading / Tamil Literature',
            'Travel & Trekking',
            'Photography',
            'Cooking / Baking',
            'Yoga & Fitness',
          ].where((h) => !_selectedHobbies.contains(h)).map((suggestion) {
            return InkWell(
              onTap: () {
                setState(() => _selectedHobbies.add(suggestion));
                _checkAndTriggerAutoScroll();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3FB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8EBFA)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 13, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      suggestion,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),

        // Add custom hobby
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _customHobbyController,
                style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF1F3FB),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  prefixIcon: const Icon(Icons.add_reaction_outlined, size: 16, color: Color(0xFF64748B)),
                  prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  hintText: 'Add a custom interest / hobby...',
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE8EBFA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE8EBFA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
                  ),
                ),
                onFieldSubmitted: (_) => _addCustomHobby(),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _addCustomHobby,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF881337).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF881337).withValues(alpha: 0.2)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '+ Add',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF881337),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _buildMandatoryLabel('Cultural & Personal Outlook'),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildPillSelectTile(
                label: 'Traditional',
                isSelected: _culturalOutlook == 'Traditional',
                onTap: () {
                  setState(() => _culturalOutlook = 'Traditional');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPillSelectTile(
                label: 'Modern & Traditional',
                isSelected: _culturalOutlook == 'Modern & Traditional',
                onTap: () {
                  setState(() => _culturalOutlook = 'Modern & Traditional');
                  _checkAndTriggerAutoScroll();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // H) Bio Card
  Widget _buildBioCard() {
    if (!_hasUserEditedBio) {
      final defaultBio = _generateDefaultBio();
      if (defaultBio.isNotEmpty && defaultBio != _bioController.text) {
        _bioController.text = defaultBio;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
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
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF881337).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.format_quote_rounded, size: 16, color: Color(0xFF881337)),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Few Words About Me',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Express your aspirations',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'We generated this based on your details. You can keep it as is, or tap inside to edit.',
            style: TextStyle(
              fontSize: 11.5,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _bioController,
            maxLines: 4,
            maxLength: 500,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF334155),
              height: 1.4,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFAF5FF),
              isDense: true,
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Write a brief summary about yourself, hobbies, values, and what kind of partner you are looking for...',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE9D5FF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE9D5FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
              ),
            ),
            onChanged: (_) {
              _hasUserEditedBio = true;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  // Card Wrapper
  Widget _buildCardWrapper({
    required String title,
    required List<Widget> children,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
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
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF881337),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F3FB)),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // Label with red mandatory asterisk
  Widget _buildMandatoryLabel(String label) {
    return Text.rich(
      TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Optional label without asterisk
  Widget _buildOptionalLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF334155),
      ),
    );
  }

  // Single Input Field (Clean single border)
  Widget _buildSingleInputField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F3FB),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(prefixIcon, size: 18, color: const Color(0xFF64748B)),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 38),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8EBFA), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
        ),
      ),
    );
  }

  // Pill Select Tile
  Widget _buildPillSelectTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF881337) : const Color(0xFFF1F3FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF881337) : const Color(0xFFE8EBFA),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  // Diet Tile
  Widget _buildDietTile({
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
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFFDA4AF) : const Color(0xFFDBEAFE),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF881337) : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom Actions Bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    final bool canContinue = _isInterestsComplete;

    return SafeArea(
      top: false,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF2F3FF), width: 1)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Action
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1760A3),
                    letterSpacing: 0.14,
                  ),
                ),
              ),
            ),

            // Save Draft Action
            InkWell(
              onTap: _onSaveDraft,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  'Save Draft',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF131B2E),
                    letterSpacing: 0.36,
                  ),
                ),
              ),
            ),

            // Continue CTA Button
            Material(
              color: canContinue ? const Color(0xFF881337) : const Color(0xFF94A3B8),
              borderRadius: BorderRadius.circular(12),
              elevation: canContinue ? 1 : 0,
              child: InkWell(
                onTap: _onContinue,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.14,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
