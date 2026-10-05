import 'package:flutter/material.dart';

class EditLocationResidenceScreen extends StatefulWidget {
  final String? initialTargetCities;
  final String? initialRelocationNote;
  final String? initialCountries;
  final String? initialVisaNote;
  final String? initialAncestralRoots;
  final String? initialAncestralBelt;

  const EditLocationResidenceScreen({
    super.key,
    this.initialTargetCities,
    this.initialRelocationNote,
    this.initialCountries,
    this.initialVisaNote,
    this.initialAncestralRoots,
    this.initialAncestralBelt,
  });

  @override
  State<EditLocationResidenceScreen> createState() => _EditLocationResidenceScreenState();
}

class _EditLocationResidenceScreenState extends State<EditLocationResidenceScreen> {
  // Theme Colors
  static const Color primaryMaroon = Color(0xFF701A31);
  static const Color darkSlate = Color(0xFF0F172A);
  static const Color slateText = Color(0xFF334155);
  static const Color mutedText = Color(0xFF64748B);
  static const Color cardBorderColor = Color(0xFFEAEDFF);
  static const Color fieldBgColor = Color(0xFFF1F3FB);

  // Controllers
  late TextEditingController _targetCitiesController;
  late TextEditingController _relocationNoteController;
  late TextEditingController _countriesController;
  late TextEditingController _visaNoteController;
  late TextEditingController _ancestralRootsController;
  late TextEditingController _ancestralBeltController;

  // Selected quick chips
  final Set<String> _selectedCities = {};
  final Set<String> _selectedCountries = {};

  // Predefined quick city options
  final List<String> _quickCities = [
    'Chennai',
    'Bangalore',
    'Hyderabad',
    'Coimbatore',
    'Madurai',
    'Tiruchirappalli',
    'Salem',
    'Tirunelveli',
    'Mumbai',
    'Pune',
    'Delhi NCR',
    'Kochi',
  ];

  // Predefined relocation notes
  final List<String> _relocationOptions = [
    'Willingness to relocate to Chennai or Hybrid work',
    'Open to relocate anywhere',
    'Current city preferred (Relocation negotiable)',
    'Hybrid work preferred',
    'Remote / Work from home open',
    'Flexible / Mutual decision',
  ];

  // Predefined quick countries
  final List<String> _quickCountries = [
    'India',
    'USA',
    'Singapore',
    'United Kingdom',
    'Canada',
    'Australia',
    'UAE / Dubai',
    'Germany',
    'Malaysia',
    'Any Country',
  ];

  // Predefined visa status notes
  final List<String> _visaOptions = [
    'H1B / PR acceptable',
    'Citizen / Permanent Resident only',
    'Work Permit / Employment Visa open',
    'Valid Visa or Indian Resident open',
    'No visa restriction',
    'India resident preferred',
  ];

  // Predefined Ancestral Roots
  final List<String> _ancestralRootsOptions = [
    'Tamil Nadu Origin',
    'Kerala Origin',
    'Karnataka Origin',
    'Andhra / Telangana Origin',
    'Any South Indian Origin',
    'Any / Doesn\'t Matter',
  ];

  // Predefined Ancestral Belts
  final List<String> _ancestralBeltOptions = [
    'Thanjavur, Trichy belt',
    'Madurai, Pandya belt',
    'Kongu belt (Coimbatore / Erode / Salem)',
    'Tirunelveli, Thoothukudi belt',
    'Chennai & Northern TN belt',
    'Chettinad belt',
    'Any / Flexible',
  ];

  @override
  void initState() {
    super.initState();

    final initialCities = widget.initialTargetCities ?? 'Chennai, Bangalore, Hyderabad, Coimbatore';
    final initialRelocation = widget.initialRelocationNote ?? 'Willingness to relocate to Chennai or Hybrid work';
    final initialCountries = widget.initialCountries ?? 'India, USA, Singapore';
    final initialVisa = widget.initialVisaNote ?? 'H1B / PR acceptable';
    final initialRoots = widget.initialAncestralRoots ?? 'Tamil Nadu Origin';
    final initialBelt = widget.initialAncestralBelt ?? 'Thanjavur, Trichy belt';

    _targetCitiesController = TextEditingController(text: initialCities);
    _relocationNoteController = TextEditingController(text: initialRelocation);
    _countriesController = TextEditingController(text: initialCountries);
    _visaNoteController = TextEditingController(text: initialVisa);
    _ancestralRootsController = TextEditingController(text: initialRoots);
    _ancestralBeltController = TextEditingController(text: initialBelt);

    _syncSelectedChipsFromControllers();
  }

  void _syncSelectedChipsFromControllers() {
    _selectedCities.clear();
    final cityTokens = _targetCitiesController.text
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
    for (var c in _quickCities) {
      if (cityTokens.any((t) => c.toLowerCase() == t || c.toLowerCase().contains(t))) {
        _selectedCities.add(c);
      }
    }

    _selectedCountries.clear();
    final countryTokens = _countriesController.text
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
    for (var co in _quickCountries) {
      if (countryTokens.any((t) => co.toLowerCase() == t || co.toLowerCase().contains(t))) {
        _selectedCountries.add(co);
      }
    }
  }

  @override
  void dispose() {
    _targetCitiesController.dispose();
    _relocationNoteController.dispose();
    _countriesController.dispose();
    _visaNoteController.dispose();
    _ancestralRootsController.dispose();
    _ancestralBeltController.dispose();
    super.dispose();
  }

  void _toggleCity(String city) {
    setState(() {
      if (_selectedCities.contains(city)) {
        _selectedCities.remove(city);
      } else {
        _selectedCities.add(city);
      }
      _targetCitiesController.text = _selectedCities.join(', ');
    });
  }

  void _toggleCountry(String country) {
    setState(() {
      if (country == 'Any Country') {
        _selectedCountries.clear();
        _selectedCountries.add(country);
      } else {
        _selectedCountries.remove('Any Country');
        if (_selectedCountries.contains(country)) {
          _selectedCountries.remove(country);
        } else {
          _selectedCountries.add(country);
        }
      }
      _countriesController.text = _selectedCountries.join(', ');
    });
  }

  void _resetToDefault() {
    setState(() {
      _targetCitiesController.text = 'Chennai, Bangalore, Hyderabad, Coimbatore';
      _relocationNoteController.text = 'Willingness to relocate to Chennai or Hybrid work';
      _countriesController.text = 'India, USA, Singapore';
      _visaNoteController.text = 'H1B / PR acceptable';
      _ancestralRootsController.text = 'Tamil Nadu Origin';
      _ancestralBeltController.text = 'Thanjavur, Trichy belt';
      _syncSelectedChipsFromControllers();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location & Residence preferences reset to default.'),
        backgroundColor: primaryMaroon,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _saveLocationDetails() {
    FocusScope.of(context).unfocus();

    final result = {
      'targetCities': _targetCitiesController.text.trim(),
      'relocationNote': _relocationNoteController.text.trim(),
      'countries': _countriesController.text.trim(),
      'visaNote': _visaNoteController.text.trim(),
      'ancestralRoots': _ancestralRootsController.text.trim(),
      'ancestralBelt': _ancestralBeltController.text.trim(),
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeader(),
            const SizedBox(height: 14),

            // Card 1: Target Cities & Relocation
            _buildTargetCitiesCard(),
            const SizedBox(height: 14),

            // Card 2: Preferred Countries & Visa Status
            _buildCountriesCard(),
            const SizedBox(height: 14),

            // Card 3: Ancestral Roots & Native Heritage
            _buildAncestralRootsCard(),
            const SizedBox(height: 14),

            // Privacy & Info note
            _buildInfoNoteBadge(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Top Custom App Bar
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Location & Residence',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'இருப்பிடம் & பூர்வீகம்',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFED7AA),
                        ),
                      ),
                    ],
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

  // Subheader
  Widget _buildSubHeader() {
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
              'LOCATION, SETTLEMENT & ANCESTRAL PREFERENCES',
              style: TextStyle(
                color: Color(0xFF881337),
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Header Helper
  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF881337).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF881337).withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF881337),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: darkSlate,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: mutedText,
                    ),
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFF1F3FB)),
      ],
    );
  }

  // Clean Field Label WITHOUT required asterisk
  Widget _buildFieldLabel(String label, {String? subLabel}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: slateText,
          ),
        ),
        if (subLabel != null) ...[
          const SizedBox(width: 6),
          Text(
            subLabel,
            style: const TextStyle(
              fontSize: 11.5,
              color: mutedText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 1: Target Cities & Relocation
  // ─────────────────────────────────────────────────────────────
  Widget _buildTargetCitiesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 1),
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
          _buildCardHeader(
            icon: Icons.location_city_rounded,
            title: 'TARGET CITIES & RELOCATION',
            subtitle: 'Preferred metropolitan cities & working hubs',
          ),
          const SizedBox(height: 14),

          // Label: Target Cities
          _buildFieldLabel('Target Cities', subLabel: '(Tap to select multiple)'),
          const SizedBox(height: 8),

          // Quick City Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickCities.map((city) {
              final isSelected = _selectedCities.contains(city);
              return FilterChip(
                label: Text(city),
                selected: isSelected,
                onSelected: (_) => _toggleCity(city),
                selectedColor: primaryMaroon,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : slateText,
                ),
                backgroundColor: fieldBgColor,
                side: BorderSide(
                  color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Editable Custom Cities Text Field
          _buildTextField(
            controller: _targetCitiesController,
            hintText: 'e.g. Chennai, Bangalore, Hyderabad, Coimbatore',
            prefixIcon: Icons.edit_location_alt_outlined,
            onChanged: (_) {
              _syncSelectedChipsFromControllers();
              setState(() {});
            },
          ),
          const SizedBox(height: 16),

          // Label: Relocation & Work Flexibility
          _buildFieldLabel('Relocation & Work Flexibility Note'),
          const SizedBox(height: 8),

          // Relocation Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _relocationOptions.map((opt) {
              final isSelected = _relocationNoteController.text.trim() == opt;
              return ActionChip(
                label: Text(opt),
                backgroundColor: isSelected ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                ),
                onPressed: () {
                  setState(() {
                    _relocationNoteController.text = opt;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Custom Relocation Note Input
          _buildTextField(
            controller: _relocationNoteController,
            hintText: 'e.g. Willingness to relocate to Chennai or Hybrid work',
            prefixIcon: Icons.commute_rounded,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 2: Preferred Countries & Visa Status
  // ─────────────────────────────────────────────────────────────
  Widget _buildCountriesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 1),
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
          _buildCardHeader(
            icon: Icons.public_rounded,
            title: 'COUNTRIES & VISA PREFERENCE',
            subtitle: 'Accepted settlement nations & visa conditions',
          ),
          const SizedBox(height: 14),

          // Label: Countries
          _buildFieldLabel('Accepted Countries', subLabel: '(Tap to select multiple)'),
          const SizedBox(height: 8),

          // Quick Country Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickCountries.map((country) {
              final isSelected = _selectedCountries.contains(country);
              return FilterChip(
                label: Text(country),
                selected: isSelected,
                onSelected: (_) => _toggleCountry(country),
                selectedColor: primaryMaroon,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : slateText,
                ),
                backgroundColor: fieldBgColor,
                side: BorderSide(
                  color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Editable Custom Countries Text Field
          _buildTextField(
            controller: _countriesController,
            hintText: 'e.g. India, USA, Singapore',
            prefixIcon: Icons.flag_outlined,
            onChanged: (_) {
              _syncSelectedChipsFromControllers();
              setState(() {});
            },
          ),
          const SizedBox(height: 16),

          // Label: Visa / Immigration Status
          _buildFieldLabel('Visa / Immigration Preference'),
          const SizedBox(height: 8),

          // Visa Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _visaOptions.map((v) {
              final isSelected = _visaNoteController.text.trim() == v;
              return ActionChip(
                label: Text(v),
                backgroundColor: isSelected ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                ),
                onPressed: () {
                  setState(() {
                    _visaNoteController.text = v;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Custom Visa Note Input
          _buildTextField(
            controller: _visaNoteController,
            hintText: 'e.g. H1B / PR acceptable, Citizen / PR open',
            prefixIcon: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 3: Ancestral Roots & Native Heritage
  // ─────────────────────────────────────────────────────────────
  Widget _buildAncestralRootsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 1),
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
          _buildCardHeader(
            icon: Icons.temple_hindu_rounded,
            title: 'ANCESTRAL ROOTS & NATIVE BELT',
            subtitle: 'Heritage origins & native regional cultural belts',
          ),
          const SizedBox(height: 14),

          // Label: Ancestral Roots Origin
          _buildFieldLabel('Ancestral Roots (பூர்வீகம்)'),
          const SizedBox(height: 8),

          // Roots presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ancestralRootsOptions.map((roots) {
              final isSelected = _ancestralRootsController.text.trim() == roots;
              return ActionChip(
                label: Text(roots),
                backgroundColor: isSelected ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                ),
                onPressed: () {
                  setState(() {
                    _ancestralRootsController.text = roots;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Custom Ancestral Roots Input
          _buildTextField(
            controller: _ancestralRootsController,
            hintText: 'e.g. Tamil Nadu Origin, Kerala Origin',
            prefixIcon: Icons.account_balance_outlined,
          ),
          const SizedBox(height: 16),

          // Label: Native Region / Belt
          _buildFieldLabel('Native Region / District Belt (பூர்விக மாவட்டம்)'),
          const SizedBox(height: 8),

          // Belt Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _ancestralBeltOptions.map((belt) {
              final isSelected = _ancestralBeltController.text.trim() == belt;
              return ActionChip(
                label: Text(belt),
                backgroundColor: isSelected ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                side: BorderSide(
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                ),
                onPressed: () {
                  setState(() {
                    _ancestralBeltController.text = belt;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Custom Belt Input
          _buildTextField(
            controller: _ancestralBeltController,
            hintText: 'e.g. Thanjavur, Trichy belt / Madurai / Kongu belt',
            prefixIcon: Icons.map_outlined,
          ),
        ],
      ),
    );
  }

  // Info Note Badge
  Widget _buildInfoNoteBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEF3C7), width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 15,
              color: Color(0xFFD97706),
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'All location fields are optional. Leave blank if open to all locations.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF92400E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Clean Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fieldBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EBFA), width: 1.0),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: darkSlate,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12.5,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(prefixIcon, size: 18, color: const Color(0xFF881337)),
        ),
      ),
    );
  }

  // Bottom Action Bar
  Widget _buildBottomActionBar() {
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
            child: ElevatedButton.icon(
              onPressed: _saveLocationDetails,
              icon: const Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
              label: const Text(
                'Save Location Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: const Color(0x33701A31),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
