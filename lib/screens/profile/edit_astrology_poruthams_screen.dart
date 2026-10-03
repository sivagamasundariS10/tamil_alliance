import 'package:flutter/material.dart';

class EditAstrologyPoruthamsScreen extends StatefulWidget {
  final String? initialMinPoruthams;
  final String? initialChevvai;
  final String? initialRahuKethu;
  final String? initialPapasamyam;
  final List<String>? initialPreferredStars;

  const EditAstrologyPoruthamsScreen({
    super.key,
    this.initialMinPoruthams,
    this.initialChevvai,
    this.initialRahuKethu,
    this.initialPapasamyam,
    this.initialPreferredStars,
  });

  @override
  State<EditAstrologyPoruthamsScreen> createState() => _EditAstrologyPoruthamsScreenState();
}

class _EditAstrologyPoruthamsScreenState extends State<EditAstrologyPoruthamsScreen> {
  // Theme Colors
  static const Color primaryMaroon = Color(0xFF701A31);

  // Options
  final List<String> _poruthamOptions = [
    '7+ out of 10',
    '6+ out of 10',
    '8+ out of 10',
    '5+ out of 10',
    'Flexible / Any',
  ];

  final List<String> _chevvaiOptions = [
    'Dosham Only',
    'No Dosham ',
    'Doesn\'t Matter',
  ];

  final List<String> _rahuKethuOptions = [
    'Conditional',
    'Must Have Rahu/Ketu',
    'No Rahu/Ketu Dosham',
    'Doesn\'t Matter',
  ];

  final List<String> _papasamyamOptions = [
    'Balanced',
    'Equal or Less',
    'Strict Equal Match',
    'Flexible / Any',
  ];

  // 27 Nakshatras
  final List<String> _allNakshatras = [
    'Aswini',
    'Bharani',
    'Krithigai',
    'Rohini',
    'Mrigashira',
    'Thiruvathirai',
    'Punarpoosam',
    'Poosam',
    'Ayilyam',
    'Makam',
    'Pooram',
    'Uthiram',
    'Hastham',
    'Chithirai',
    'Swathi',
    'Visakam',
    'Anusham',
    'Kettai',
    'Moolam',
    'Pooradam',
    'Uthiradam',
    'Thiruvonam',
    'Avittam',
    'Sathayam',
    'Poorattathi',
    'Uthirattathi',
    'Revathi',
  ];

  // State Variables
  late String _selectedMinPoruthams;
  late String _selectedChevvai;
  late String _selectedRahuKethu;
  late String _selectedPapasamyam;
  late Set<String> _selectedStars;

  @override
  void initState() {
    super.initState();
    _selectedMinPoruthams = widget.initialMinPoruthams ?? '7+ out of 10';
    if (!_poruthamOptions.contains(_selectedMinPoruthams)) {
      _selectedMinPoruthams = _poruthamOptions.first;
    }

    _selectedChevvai = widget.initialChevvai ?? 'Shuddha / Equal';
    if (!_chevvaiOptions.contains(_selectedChevvai)) {
      _selectedChevvai = _chevvaiOptions.first;
    }

    _selectedRahuKethu = widget.initialRahuKethu ?? 'Conditional';
    if (!_rahuKethuOptions.contains(_selectedRahuKethu)) {
      _selectedRahuKethu = _rahuKethuOptions.first;
    }

    _selectedPapasamyam = widget.initialPapasamyam ?? 'Balanced';
    if (!_papasamyamOptions.contains(_selectedPapasamyam)) {
      _selectedPapasamyam = _papasamyamOptions.first;
    }

    if (widget.initialPreferredStars != null && widget.initialPreferredStars!.isNotEmpty) {
      _selectedStars = Set<String>.from(widget.initialPreferredStars!);
    } else {
      _selectedStars = {'Rohini', 'Mrigashira', 'Hastham', 'Swati', 'Revati', 'Uthiradam'};
    }
  }

  void _resetToDefault() {
    setState(() {
      _selectedMinPoruthams = '7+ out of 10';
      _selectedChevvai = 'Shuddha / Equal';
      _selectedRahuKethu = 'Conditional';
      _selectedPapasamyam = 'Balanced';
      _selectedStars = {'Rohini', 'Mrigashira', 'Hastham', 'Swati', 'Revati', 'Uthiradam'};
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Astrology & Poruthams preferences reset to default.'),
        backgroundColor: primaryMaroon,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _savePreferences() {
    final result = {
      'minPoruthams': _selectedMinPoruthams,
      'chevvai': _selectedChevvai,
      'rahuKethu': _selectedRahuKethu,
      'papasamyam': _selectedPapasamyam,
      'preferredStars': _selectedStars.toList(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Astrology & Poruthams preferences updated successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

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

            // 1. Min Poruthams Card
            _buildMinPoruthamsCard(),
            const SizedBox(height: 14),

            // 2. Chevvai (Kuja) Card
            _buildChevvaiCard(),
            const SizedBox(height: 14),

            // 3. Rahu-Kethu & Papasamyam Card
            _buildRahuAndPapasamyamCard(),
            const SizedBox(height: 14),

            // 4. Preferred Nakshatrams Card
            _buildPreferredNakshatramsCard(),
            const SizedBox(height: 14),

            // 5. Security Guarantee Badge
            _buildSecurityBadge(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top Custom App Bar (Common Header Style)
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
                    'Astrology & Poruthams',
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

  // Subheader
  Widget _buildSubHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        'ஜாதகம் & பொருத்தங்கள் விருப்பங்கள்',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: primaryMaroon,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 1: Minimum Poruthams
  // ─────────────────────────────────────────────────────────────
  Widget _buildMinPoruthamsCard() {
    return _buildContainerCard(
      icon: Icons.star_border_purple500_rounded,
      title: 'MIN. PORUTHAMS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Minimum Required Poruthams (out of 10)'),
          const SizedBox(height: 8),
          _buildDropdownSelector(
            value: _selectedMinPoruthams,
            items: _poruthamOptions,
            onChanged: (val) {
              if (val != null) setState(() => _selectedMinPoruthams = val);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 2: Chevvai (Kuja) Dosham
  // ─────────────────────────────────────────────────────────────
  Widget _buildChevvaiCard() {
    return _buildContainerCard(
      icon: Icons.shield_outlined,
      title: 'DOSHAM PREFERENCE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Select Dosham Preference'),
          const SizedBox(height: 8),
          _buildDropdownSelector(
            value: _selectedChevvai,
            items: _chevvaiOptions,
            onChanged: (val) {
              if (val != null) setState(() => _selectedChevvai = val);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 3: Rahu-Kethu & Papasamyam
  // ─────────────────────────────────────────────────────────────
  Widget _buildRahuAndPapasamyamCard() {
    return _buildContainerCard(
      icon: Icons.balance_rounded,
      title: 'RAHU-KETHU & PAPASAMYAM',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rahu-Kethu
          _buildFieldLabel('Rahu-Kethu Dosham Policy'),
          const SizedBox(height: 6),
          _buildDropdownSelector(
            value: _selectedRahuKethu,
            items: _rahuKethuOptions,
            onChanged: (val) {
              if (val != null) setState(() => _selectedRahuKethu = val);
            },
          ),
          const SizedBox(height: 14),

          // Papasamyam
          _buildFieldLabel('Papasamyam (Dosha Point Balance)'),
          const SizedBox(height: 6),
          _buildDropdownSelector(
            value: _selectedPapasamyam,
            items: _papasamyamOptions,
            onChanged: (val) {
              if (val != null) setState(() => _selectedPapasamyam = val);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 4: Preferred Nakshatrams (Uthiradam Alliances)
  // ─────────────────────────────────────────────────────────────
  Widget _buildPreferredNakshatramsCard() {
    return _buildContainerCard(
      icon: Icons.auto_awesome_rounded,
      title: 'PREFERRED NAKSHATRAMS',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedStars = Set<String>.from(_allNakshatras);
              });
            },
            child: const Text(
              'Select All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primaryMaroon,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedStars.clear();
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedStars.length} of 27 Nakshatrams selected as preferred:',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allNakshatras.map((star) {
              final isSelected = _selectedStars.contains(star);
              return FilterChip(
                label: Text(star),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedStars.add(star);
                    } else {
                      _selectedStars.remove(star);
                    }
                  });
                },
                selectedColor: const Color(0xFFFFF1F2),
                checkmarkColor: primaryMaroon,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? primaryMaroon : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? primaryMaroon : const Color(0xFF1E293B),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Security Badge
  Widget _buildSecurityBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEF3C7), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.verified_user_rounded,
              size: 15,
              color: Color(0xFFD97706),
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                '256-Bit Encrypted Vedic Astro Match Engine Protected',
                style: TextStyle(
                  fontSize: 12.5,
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

  // Container Card Helper
  Widget _buildContainerCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget child,
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
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryMaroon, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F3FB)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // Field Label Helper
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF334155),
      ),
    );
  }


  // Dropdown Selector Helper
  Widget _buildDropdownSelector({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EBFA), width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Bottom Actions Bar
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
            child: ElevatedButton(
              onPressed: _savePreferences,
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
                'Save Astrology Preferences',
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
