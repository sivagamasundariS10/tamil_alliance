import 'package:flutter/material.dart';

class EditLifestyleValuesScreen extends StatefulWidget {
  final String? initialDietary;
  final String? initialDietaryNote;
  final String? initialHabits;
  final String? initialHabitsNote;
  final String? initialFamilyStructure;
  final String? initialFamilyStructureNote;
  final String? initialCultural;

  const EditLifestyleValuesScreen({
    super.key,
    this.initialDietary,
    this.initialDietaryNote,
    this.initialHabits,
    this.initialHabitsNote,
    this.initialFamilyStructure,
    this.initialFamilyStructureNote,
    this.initialCultural,
  });

  @override
  State<EditLifestyleValuesScreen> createState() => _EditLifestyleValuesScreenState();
}

class _EditLifestyleValuesScreenState extends State<EditLifestyleValuesScreen> {
  // Theme Colors
  static const Color primaryMaroon = Color(0xFF701A31);
  static const Color darkSlate = Color(0xFF0F172A);
  static const Color slateText = Color(0xFF334155);
  static const Color mutedText = Color(0xFF64748B);
  static const Color cardBorderColor = Color(0xFFEAEDFF);
  static const Color fieldBgColor = Color(0xFFF1F3FB);

  // Controllers
  late TextEditingController _dietaryController;
  late TextEditingController _dietaryNoteController;
  late TextEditingController _habitsController;
  late TextEditingController _habitsNoteController;
  late TextEditingController _familyStructureController;
  late TextEditingController _familyStructureNoteController;
  late TextEditingController _culturalController;

  // Predefined options
  final List<String> _dietaryOptions = [
    'Vegetarian (சைவம்)',
    'Pure Vegetarian (No Onion/Garlic)',
    'Eggetarian',
    'Non-Vegetarian (அசைவம்)',
    'Flexitarian / Occasional Non-Veg',
    'Vegan',
    'Doesn\'t Matter',
  ];

  final List<String> _dietaryNoteOptions = [
    'No eggs / non-veg inside domestic household',
    'Separate cooking vessels preferred',
    'Non-veg outside allowed, veg at home',
    'No kitchen restrictions',
    'Traditional Sattvic cooking preferred',
  ];

  final List<String> _habitsOptions = [
    'Teetotaler',
    'Non-Smoker, Non-Drinker',
    'Social Drinker (Non-Smoker)',
    'Occasional / Festive Drinker',
    'Doesn\'t Matter',
  ];

  final List<String> _habitsNoteOptions = [
    'Non-Smoker, Non-Drinker',
    'Health conscious & active fitness routine',
    'Zero tolerance for smoking or substances',
    'Moderate & responsible lifestyle',
  ];

  final List<String> _familyStructureOptions = [
    'Joint / Nuclear',
    'Nuclear Family Preferred',
    'Joint Family Preferred',
    'Flexible / Based on work city',
    'Independent living with close family ties',
  ];

  final List<String> _familyNoteOptions = [
    'Harmonious bonding',
    'Respect for elders & traditional warmth',
    'Mutual space, understanding & independence',
    'Close family support with career freedom',
  ];

  final List<String> _culturalTags = [
    'Carnatic Music appreciation',
    'Traditional festivals (Marghazhi, Navarathri)',
    'Temple visits & spiritual inclination',
    'Modern progressive thoughts with cultural roots',
    'Yoga & holistic lifestyle',
    'Fine arts & Classical dance',
    'Travel & cultural exploration',
  ];

  @override
  void initState() {
    super.initState();

    _dietaryController = TextEditingController(
      text: widget.initialDietary ?? 'Vegetarian (சைவம்)',
    );
    _dietaryNoteController = TextEditingController(
      text: widget.initialDietaryNote ?? 'No eggs / non-veg inside domestic household',
    );
    _habitsController = TextEditingController(
      text: widget.initialHabits ?? 'Teetotaler',
    );
    _habitsNoteController = TextEditingController(
      text: widget.initialHabitsNote ?? 'Non-Smoker, Non-Drinker',
    );
    _familyStructureController = TextEditingController(
      text: widget.initialFamilyStructure ?? 'Joint / Nuclear',
    );
    _familyStructureNoteController = TextEditingController(
      text: widget.initialFamilyStructureNote ?? 'Harmonious bonding',
    );
    _culturalController = TextEditingController(
      text: widget.initialCultural ??
          'Carnatic Music appreciation, traditional festivals (Marghazhi, Navarathri), temple visits, alongside modern progressive thoughts',
    );
  }

  @override
  void dispose() {
    _dietaryController.dispose();
    _dietaryNoteController.dispose();
    _habitsController.dispose();
    _habitsNoteController.dispose();
    _familyStructureController.dispose();
    _familyStructureNoteController.dispose();
    _culturalController.dispose();
    super.dispose();
  }

  void _resetToDefault() {
    setState(() {
      _dietaryController.text = 'Vegetarian (சைவம்)';
      _dietaryNoteController.text = 'No eggs / non-veg inside domestic household';
      _habitsController.text = 'Teetotaler';
      _habitsNoteController.text = 'Non-Smoker, Non-Drinker';
      _familyStructureController.text = 'Joint / Nuclear';
      _familyStructureNoteController.text = 'Harmonious bonding';
      _culturalController.text =
          'Carnatic Music appreciation, traditional festivals (Marghazhi, Navarathri), temple visits, alongside modern progressive thoughts';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lifestyle & Values preferences reset to default.'),
        backgroundColor: primaryMaroon,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _appendCulturalTag(String tag) {
    setState(() {
      final current = _culturalController.text.trim();
      if (current.isEmpty) {
        _culturalController.text = tag;
      } else if (!current.toLowerCase().contains(tag.toLowerCase())) {
        _culturalController.text = '$current, $tag';
      }
    });
  }

  void _saveLifestyleDetails() {
    FocusScope.of(context).unfocus();

    final result = {
      'dietary': _dietaryController.text.trim(),
      'dietaryNote': _dietaryNoteController.text.trim(),
      'habits': _habitsController.text.trim(),
      'habitsNote': _habitsNoteController.text.trim(),
      'familyStructure': _familyStructureController.text.trim(),
      'familyStructureNote': _familyStructureNoteController.text.trim(),
      'cultural': _culturalController.text.trim(),
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

            // Card 1: Dietary Expectation
            _buildDietaryCard(),
            const SizedBox(height: 14),

            // Card 2: Habits & Lifestyle
            _buildHabitsCard(),
            const SizedBox(height: 14),

            // Card 3: Family Structure
            _buildFamilyStructureCard(),
            const SizedBox(height: 14),

            // Card 4: Cultural Inclination
            _buildCulturalCard(),
            const SizedBox(height: 14),

            // Info note
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
                        'Lifestyle & Values',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'வாழ்க்கை முறை & ஒழுக்கம்',
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
              'DIET, HABITS, FAMILY & CULTURAL VALUES',
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

  // Header Helper for Cards
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

  // Field Label WITHOUT required asterisk
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
  // Card 1: Dietary Expectation
  // ─────────────────────────────────────────────────────────────
  Widget _buildDietaryCard() {
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
            icon: Icons.restaurant_rounded,
            title: 'DIETARY EXPECTATION',
            subtitle: 'Food preference & domestic kitchen practices',
          ),
          const SizedBox(height: 14),

          // Label: Dietary Preference
          _buildFieldLabel('Dietary Preference'),
          const SizedBox(height: 8),

          // Dietary Options Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dietaryOptions.map((diet) {
              final isSelected = _dietaryController.text.trim() == diet;
              return ActionChip(
                label: Text(diet),
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
                    _dietaryController.text = diet;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          _buildTextField(
            controller: _dietaryController,
            hintText: 'e.g. Vegetarian (சைவம்)',
            prefixIcon: Icons.eco_rounded,
          ),
          const SizedBox(height: 16),

          // Label: Dietary Note
          _buildFieldLabel('Dietary Household Note'),
          const SizedBox(height: 8),

          // Dietary Note Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dietaryNoteOptions.map((note) {
              final isSelected = _dietaryNoteController.text.trim() == note;
              return ActionChip(
                label: Text(note),
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
                    _dietaryNoteController.text = note;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          _buildTextField(
            controller: _dietaryNoteController,
            hintText: 'e.g. No eggs / non-veg inside domestic household',
            prefixIcon: Icons.kitchen_rounded,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 2: Habits & Lifestyle
  // ─────────────────────────────────────────────────────────────
  Widget _buildHabitsCard() {
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
            icon: Icons.favorite_border_rounded,
            title: 'HABITS & HEALTH ROUTINE',
            subtitle: 'Personal habits, smoking & drinking status',
          ),
          const SizedBox(height: 14),

          // Label: Habits
          _buildFieldLabel('Habits Status'),
          const SizedBox(height: 8),

          // Habits presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _habitsOptions.map((h) {
              final isSelected = _habitsController.text.trim() == h;
              return ActionChip(
                label: Text(h),
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
                    _habitsController.text = h;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          _buildTextField(
            controller: _habitsController,
            hintText: 'e.g. Teetotaler',
            prefixIcon: Icons.smoke_free_rounded,
          ),
          const SizedBox(height: 16),

          // Label: Habits Note
          _buildFieldLabel('Habits Subtitle Note'),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _habitsNoteOptions.map((hn) {
              final isSelected = _habitsNoteController.text.trim() == hn;
              return ActionChip(
                label: Text(hn),
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
                    _habitsNoteController.text = hn;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          _buildTextField(
            controller: _habitsNoteController,
            hintText: 'e.g. Non-Smoker, Non-Drinker',
            prefixIcon: Icons.health_and_safety_outlined,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 3: Family Structure
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyStructureCard() {
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
            icon: Icons.family_restroom_rounded,
            title: 'FAMILY STRUCTURE & VALUES',
            subtitle: 'Living arrangement & domestic lifestyle preference',
          ),
          const SizedBox(height: 14),

          // Label: Family Structure
          _buildFieldLabel('Family Structure Preference'),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _familyStructureOptions.map((fs) {
              final isSelected = _familyStructureController.text.trim() == fs;
              return ActionChip(
                label: Text(fs),
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
                    _familyStructureController.text = fs;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          _buildTextField(
            controller: _familyStructureController,
            hintText: 'e.g. Joint / Nuclear',
            prefixIcon: Icons.home_outlined,
          ),
          const SizedBox(height: 16),

          // Label: Family Bonding Note
          _buildFieldLabel('Family Bonding Subtitle'),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _familyNoteOptions.map((fno) {
              final isSelected = _familyStructureNoteController.text.trim() == fno;
              return ActionChip(
                label: Text(fno),
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
                    _familyStructureNoteController.text = fno;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          _buildTextField(
            controller: _familyStructureNoteController,
            hintText: 'e.g. Harmonious bonding',
            prefixIcon: Icons.volunteer_activism_outlined,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Card 4: Cultural Inclination & Outlook
  // ─────────────────────────────────────────────────────────────
  Widget _buildCulturalCard() {
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
            title: 'CULTURAL INCLINATION',
            subtitle: 'Arts, festivals, spiritual outlook & progressive values',
          ),
          const SizedBox(height: 14),

          // Label
          _buildFieldLabel('Cultural Inclination & Outlook', subLabel: '(Tap tag to append)'),
          const SizedBox(height: 8),

          // Quick Cultural Tag Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _culturalTags.map((tag) {
              return ActionChip(
                label: Text(tag),
                backgroundColor: const Color(0xFFF8FAFC),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
                onPressed: () => _appendCulturalTag(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Multi-line Text Area for Cultural description
          Container(
            decoration: BoxDecoration(
              color: fieldBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8EBFA), width: 1.0),
            ),
            child: TextField(
              controller: _culturalController,
              maxLines: 4,
              minLines: 3,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: darkSlate,
                height: 1.4,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
                hintText:
                    'Describe partner cultural expectations, music / fine arts appreciation, festival celebrations, temple visits, and progressive worldview...',
                hintStyle: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
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
                'All lifestyle and value fields are optional.',
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
              onPressed: _saveLifestyleDetails,
              icon: const Icon(Icons.check_circle_rounded, size: 20, color: Colors.white),
              label: const Text(
                'Save Lifestyle Preferences',
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
