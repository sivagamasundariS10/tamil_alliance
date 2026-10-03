import 'package:flutter/material.dart';

class EditSiblingInfo {
  final TextEditingController nameController;
  String? relationship;
  String? maritalStatus;

  EditSiblingInfo({
    String name = '',
    this.relationship,
    this.maritalStatus,
  }) : nameController = TextEditingController(text: name);

  void dispose() {
    nameController.dispose();
  }
}

class EditFamilyDetailsScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;
  final String? email;

  const EditFamilyDetailsScreen({
    super.key,
    this.mobileNumber,
    this.countryCode,
    this.email,
  });

  @override
  State<EditFamilyDetailsScreen> createState() => _EditFamilyDetailsScreenState();
}

class _EditFamilyDetailsScreenState extends State<EditFamilyDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  // Father's Details
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherOccController = TextEditingController();

  // Mother's Details
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherOccController = TextEditingController();

  // Siblings Details
  bool _noSiblings = false;
  final List<EditSiblingInfo> _siblings = [];

  // Structure & Family Values
  String? _familyType;
  String? _familyValues;

  // Location & Native Roots
  final TextEditingController _residenceCityController = TextEditingController();
  final TextEditingController _nativeTownController = TextEditingController();

  // Family Affluence & Assets
  String? _affluenceTier;
  String? _propertyStatus;

  @override
  void initState() {
    super.initState();

    // Initialize with 1 empty sibling
    final initialSibling = EditSiblingInfo(
      name: '',
      relationship: null,
      maritalStatus: null,
    );
    _siblings.add(initialSibling);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fatherNameController.dispose();
    _fatherOccController.dispose();
    _motherNameController.dispose();
    _motherOccController.dispose();
    _residenceCityController.dispose();
    _nativeTownController.dispose();
    for (var s in _siblings) {
      s.dispose();
    }
    super.dispose();
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

  void _addSibling() {
    final newSibling = EditSiblingInfo(
      name: '',
      relationship: null,
      maritalStatus: null,
    );
    setState(() {
      _siblings.add(newSibling);
    });
    _scrollToBottom();
  }

  void _removeSibling(int index) {
    setState(() {
      if (_siblings.length > 1) {
        _siblings[index].dispose();
        _siblings.removeAt(index);
      } else {
        _noSiblings = true;
      }
    });
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();

    print('====================================================');
    print('👨‍👩‍👧‍👦 [USER INPUT: EDIT FAMILY DETAILS - SAVE PROFILE]');
    print('   Father Name       : ${_fatherNameController.text.trim()}');
    print('   Father Occupation : ${_fatherOccController.text.trim()}');
    print('   Mother Name       : ${_motherNameController.text.trim()}');
    print('   Mother Occupation : ${_motherOccController.text.trim()}');
    print('   No Siblings       : $_noSiblings');
    if (!_noSiblings) {
      for (int i = 0; i < _siblings.length; i++) {
        print('   Sibling ${i + 1}         : Name="${_siblings[i].nameController.text}", Rel="${_siblings[i].relationship}", Status="${_siblings[i].maritalStatus}"');
      }
    }
    print('   Family Type       : $_familyType');
    print('   Family Values     : $_familyValues');
    print('   Residence City    : ${_residenceCityController.text.trim()}');
    print('   Native Town       : ${_nativeTownController.text.trim()}');
    print('   Affluence Tier    : $_affluenceTier');
    print('   Property Status   : $_propertyStatus');
    print('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family details updated successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

    final result = {
      'fatherName': _fatherNameController.text.trim(),
      'fatherOcc': _fatherOccController.text.trim(),
      'motherName': _motherNameController.text.trim(),
      'motherOcc': _motherOccController.text.trim(),
      'noSiblings': _noSiblings,
      'familyType': _familyType,
      'familyValues': _familyValues,
      'residenceCity': _residenceCityController.text.trim(),
      'nativeTown': _nativeTownController.text.trim(),
      'affluenceTier': _affluenceTier,
      'propertyStatus': _propertyStatus,
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A) Step 2 Subheader
                    _buildStepSubheader(),
                    const SizedBox(height: 14),

                    // B) Father's Details Card
                    _buildFatherDetailsCard(),
                    const SizedBox(height: 14),

                    // C) Mother's Details Card
                    _buildMotherDetailsCard(),
                    const SizedBox(height: 14),

                    // D) Siblings Details Card
                    _buildSiblingsDetailsCard(),
                    const SizedBox(height: 14),

                    // E) Structure & Family Values Card
                    _buildStructureFamilyValuesCard(),
                    const SizedBox(height: 14),

                    // F) Location & Native Roots Card
                    _buildLocationNativeRootsCard(),
                    const SizedBox(height: 14),

                    // G) Family Affluence & Assets Card
                    _buildFamilyAffluenceCard(),
                    const SizedBox(height: 14),

                    // H) Security Footer Badge
                    _buildSecurityFooterBadge(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
    );
  }

  // Reset form values to default
  void _resetToDefault() {
    setState(() {
      _fatherNameController.clear();
      _fatherOccController.clear();
      _motherNameController.clear();
      _motherOccController.clear();
      _residenceCityController.clear();
      _nativeTownController.clear();
      _familyType = null;
      _familyValues = null;
      _affluenceTier = null;
      _propertyStatus = null;
      _noSiblings = false;
      for (var s in _siblings) {
        s.dispose();
      }
      _siblings.clear();
      final initialSibling = EditSiblingInfo(
        name: '',
        relationship: null,
        maritalStatus: null,
      );
      _siblings.add(initialSibling);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form values reset to default.'),
        backgroundColor: Color(0xFF701A31),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // 1. Custom App Bar matching Edit Profile
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: const Color(0xFF701A31),
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

  // A) Step 2 Subheader
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
              'FAMILY DETAILS',
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
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFF1F3FB)),
      ],
    );
  }

  // B) Father's Details Card
  Widget _buildFatherDetailsCard() {
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
          _buildCardHeader(
            icon: Icons.person_pin_rounded,
            title: "FATHER'S DETAILS",
            subtitle: 'Parental lineage & background',
          ),
          const SizedBox(height: 14),

          // Father's Full Name (Optional)
          const Text(
            "Father's Full Name",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
          _buildFigmaInputField(
            controller: _fatherNameController,
            hintText: 'e.g. Sundaresan R',
          ),
          const SizedBox(height: 14),

          // Occupation & Professional Status *
          _buildMandatoryLabel('Occupation & Professional Status'),
          const SizedBox(height: 6),
          _buildFigmaInputField(
            controller: _fatherOccController,
            hintText: 'e.g. Retd. Dy GM, State Bank of India / Business',
          ),
        ],
      ),
    );
  }

  // C) Mother's Details Card
  Widget _buildMotherDetailsCard() {
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
          _buildCardHeader(
            icon: Icons.face_3_rounded,
            title: "MOTHER'S DETAILS",
            subtitle: 'Maternal lineage & profession',
          ),
          const SizedBox(height: 14),

          // Mother's Full Name (Optional)
          const Text(
            "Mother's Full Name",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
          _buildFigmaInputField(
            controller: _motherNameController,
            hintText: 'e.g. Kalyani Sundaresan',
          ),
          const SizedBox(height: 14),

          // Occupation & Status *
          _buildMandatoryLabel('Occupation & Status'),
          const SizedBox(height: 6),
          _buildFigmaInputField(
            controller: _motherOccController,
            hintText: 'e.g. Homemaker & Carnatic Vocal Teacher',
          ),
        ],
      ),
    );
  }

  // D) Siblings Details Card
  Widget _buildSiblingsDetailsCard() {
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
          // Header with count badge
          _buildCardHeader(
            icon: Icons.groups_2_rounded,
            title: 'SIBLINGS DETAILS',
            subtitle: 'Brothers & sisters information',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
              decoration: BoxDecoration(
                color: const Color(0xFF881337).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                _noSiblings ? 'None' : '${_siblings.length} Added',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF881337),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // No Siblings / Only Child Checkbox Toggle
          InkWell(
            onTap: () {
              setState(() {
                _noSiblings = !_noSiblings;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _noSiblings ? const Color(0xFF881337) : const Color(0xFFE8EBFA),
                  width: _noSiblings ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _noSiblings,
                      onChanged: (val) {
                        setState(() => _noSiblings = val ?? false);
                      },
                      activeColor: const Color(0xFF881337),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'No Siblings',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (!_noSiblings) ...[
            const SizedBox(height: 14),
            // Sibling Entry Cards
            for (int i = 0; i < _siblings.length; i++) ...[
              _buildSiblingEntryCard(i),
              const SizedBox(height: 12),
            ],

            // Add Another Sibling Button
            InkWell(
              onTap: _addSibling,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF881337).withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF881337).withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded, size: 17, color: Color(0xFF881337)),
                    SizedBox(width: 6),
                    Text(
                      'Add Another Sibling',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF881337),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Individual Sibling Item Box
  Widget _buildSiblingEntryCard(int index) {
    final sibling = _siblings[index];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF881337),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sibling ${index + 1}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _removeSibling(index),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.delete_outline_rounded, size: 15, color: Color(0xFFE11D48)),
                    SizedBox(width: 3),
                    Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE11D48),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Sibling Full Name
          const Text(
            'Sibling Full Name',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: sibling.nameController,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              hintText: 'e.g. Vignesh Sundaresan',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF881337), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Relationship * (2x2 Grid)
          _buildMandatoryLabel('Relationship'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildSiblingRelationButton(
                  label: 'Elder Brother',
                  isSelected: sibling.relationship == 'Elder Brother',
                  onTap: () {
                    setState(() => sibling.relationship = 'Elder Brother');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSiblingRelationButton(
                  label: 'Younger Brother',
                  isSelected: sibling.relationship == 'Younger Brother',
                  onTap: () {
                    setState(() => sibling.relationship = 'Younger Brother');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSiblingRelationButton(
                  label: 'Elder Sister',
                  isSelected: sibling.relationship == 'Elder Sister',
                  onTap: () {
                    setState(() => sibling.relationship = 'Elder Sister');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSiblingRelationButton(
                  label: 'Younger Sister',
                  isSelected: sibling.relationship == 'Younger Sister',
                  onTap: () {
                    setState(() => sibling.relationship = 'Younger Sister');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Marital Status * (2-button Row)
          _buildMandatoryLabel('Marital Status'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildSiblingMaritalButton(
                  label: 'Married',
                  isSelected: sibling.maritalStatus == 'Married',
                  onTap: () {
                    setState(() => sibling.maritalStatus = 'Married');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSiblingMaritalButton(
                  label: 'Unmarried',
                  isSelected: sibling.maritalStatus == 'Unmarried',
                  onTap: () {
                    setState(() => sibling.maritalStatus = 'Unmarried');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Relationship Button Helper
  Widget _buildSiblingRelationButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF881337).withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF881337) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF881337),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Marital Status Button Helper
  Widget _buildSiblingMaritalButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF881337).withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF881337) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF881337)),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // E) Structure & Family Values Card
  Widget _buildStructureFamilyValuesCard() {
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
          _buildCardHeader(
            icon: Icons.temple_hindu_rounded,
            title: 'STRUCTURE & FAMILY VALUES',
            subtitle: 'Household living setup & cultural ethos',
          ),
          const SizedBox(height: 14),

          // Family Type *
          _buildMandatoryLabel('Family Type'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildSelectableTile(
                  label: 'Nuclear Family',
                  isSelected: _familyType == 'Nuclear Family',
                  onTap: () {
                    setState(() => _familyType = 'Nuclear Family');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectableTile(
                  label: 'Joint Family',
                  isSelected: _familyType == 'Joint Family',
                  onTap: () {
                    setState(() => _familyType = 'Joint Family');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Family Values *
          _buildMandatoryLabel('Family Values'),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildPillValueTile(
                  label: 'Orthodox',
                  isSelected: _familyValues == 'Orthodox',
                  onTap: () {
                    setState(() => _familyValues = 'Orthodox');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPillValueTile(
                  label: 'Moderate',
                  isSelected: _familyValues == 'Moderate',
                  onTap: () {
                    setState(() => _familyValues = 'Moderate');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // F) Location & Native Roots Card
  Widget _buildLocationNativeRootsCard() {
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
          _buildCardHeader(
            icon: Icons.location_on_rounded,
            title: 'LOCATION & NATIVE ROOTS',
            subtitle: 'Ancestral nativity & current living town',
          ),
          const SizedBox(height: 14),

          // Current Family Residence City *
          _buildMandatoryLabel('Current Family Residence City'),
          const SizedBox(height: 6),
          _buildFigmaInputField(
            controller: _residenceCityController,
            hintText: 'e.g. Chennai, Tamil Nadu',
            prefixIcon: Icons.location_city_rounded,
          ),
          const SizedBox(height: 14),

          // Native Ancestral District / Town *
          _buildMandatoryLabel('Native Ancestral District / Town'),
          const SizedBox(height: 6),
          _buildFigmaInputField(
            controller: _nativeTownController,
            hintText: 'e.g. Thanjavur (Papanasam / Kumbakonam Roots)',
            prefixIcon: Icons.pin_drop_rounded,
          ),
        ],
      ),
    );
  }

  // G) Family Affluence & Assets Card
  Widget _buildFamilyAffluenceCard() {
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
          _buildCardHeader(
            icon: Icons.account_balance_wallet_rounded,
            title: 'FAMILY AFFLUENCE & ASSETS',
            subtitle: 'Economic standing & property status',
          ),
          const SizedBox(height: 14),

          // Affluence Tier *
          _buildMandatoryLabel('Affluence Tier'),
          const SizedBox(height: 8),

          // 2x2 Affluence Tier Grid
          Row(
            children: [
              Expanded(
                child: _buildTierBox(
                  title: 'Middle Class',
                  range: 'Below 1Cr',
                  isSelected: _affluenceTier == 'Middle Class',
                  onTap: () {
                    setState(() => _affluenceTier = 'Middle Class');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTierBox(
                  title: 'Upper Middle',
                  range: 'Upto  1Cr - 5Cr',
                  isSelected: _affluenceTier == 'Upper Middle',
                  onTap: () {
                    setState(() => _affluenceTier = 'Upper Middle');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTierBox(
                  title: 'Affluent/Rich',
                  range: 'Upto ₹5Cr - 25Cr',
                  isSelected: _affluenceTier == 'Affluent/Rich',
                  onTap: () {
                    setState(() => _affluenceTier = 'Affluent/Rich');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTierBox(
                  title: 'Elite',
                  range: 'Upto  ₹25Cr+',
                  isSelected: _affluenceTier == 'Elite',
                  onTap: () {
                    setState(() => _affluenceTier = 'Elite');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Residential Property Status *
          _buildMandatoryLabel('Residential Property Status'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildSelectableTile(
                  label: 'Own House / Villa',
                  isSelected: _propertyStatus == 'Own House / Villa',
                  onTap: () {
                    setState(() => _propertyStatus = 'Own House / Villa');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSelectableTile(
                  label: 'Rented / Leased',
                  isSelected: _propertyStatus == 'Rented / Leased',
                  onTap: () {
                    setState(() => _propertyStatus = 'Rented / Leased');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // H) Security Footer Badge
  Widget _buildSecurityFooterBadge() {
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
                '256-Bit Encrypted Sacred Matrimonial Charter',
                style: TextStyle(
                  fontSize: 13,
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

  // Figma Input Field with Single Clean Border (No double borders)
  Widget _buildFigmaInputField({
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

  // Radio Selection Tile (e.g. Nuclear Family / Joint Family / Property Status)
  Widget _buildSelectableTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF881337).withValues(alpha: 0.04) : const Color(0xFFF1F3FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF881337) : const Color(0xFFE8EBFA),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFFCBD5E1),
                  width: isSelected ? 1.8 : 1.2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF881337),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF881337) : const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pill Value Tile (Orthodox, Moderate)
  Widget _buildPillValueTile({
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
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Affluence Tier Box (2x2 Grid)
  Widget _buildTierBox({
    required String title,
    required String range,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF881337) : const Color(0xFFF1F3FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF881337) : const Color(0xFFE8EBFA),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              range,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF64748B),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Actions Bar - Save Profile Button
  Widget _buildBottomNavigationBar(BuildContext context) {
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
                backgroundColor: const Color(0xFF701A31),
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
