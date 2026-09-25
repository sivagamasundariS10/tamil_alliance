import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'education_career_screen.dart';

class SiblingInfo {
  final TextEditingController nameController;
  String? relationship;
  String? maritalStatus;

  SiblingInfo({
    String name = '',
    this.relationship,
    this.maritalStatus,
  }) : nameController = TextEditingController(text: name);

  void dispose() {
    nameController.dispose();
  }
}

class FamilyDetailsScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;
  final String? email;

  const FamilyDetailsScreen({
    super.key,
    this.mobileNumber,
    this.countryCode,
    this.email,
  });

  @override
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  // Father's Details
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _fatherOccController = TextEditingController();

  // Mother's Details
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _motherOccController = TextEditingController();

  // Siblings Details
  bool _noSiblings = false;
  final List<SiblingInfo> _siblings = [];

  // Structure & Family Values
  String? _familyType;
  String? _familyValues;

  // Location & Native Roots
  final TextEditingController _residenceCityController = TextEditingController();
  final TextEditingController _nativeTownController = TextEditingController();

  // Family Affluence & Assets
  String? _affluenceTier;
  String? _propertyStatus;

  // Track previous visibility states to auto-scroll on new unlock
  bool _prevMotherVisible = false;
  bool _prevSiblingsVisible = false;
  bool _prevStructureVisible = false;
  bool _prevLocationVisible = false;
  bool _prevAffluenceVisible = false;

  // Progressive Validation Getters
  bool get _isFatherComplete => _fatherOccController.text.trim().isNotEmpty;

  bool get _isMotherComplete =>
      _isFatherComplete && _motherOccController.text.trim().isNotEmpty;

  bool get _isSiblingsComplete {
    if (!_isMotherComplete) return false;
    if (_noSiblings) return true;
    if (_siblings.isEmpty) return false;
    return _siblings.every(
      (s) => s.relationship != null && s.maritalStatus != null,
    );
  }

  bool get _isStructureComplete =>
      _isSiblingsComplete && _familyType != null && _familyValues != null;

  bool get _isLocationComplete =>
      _isStructureComplete &&
      _residenceCityController.text.trim().isNotEmpty &&
      _nativeTownController.text.trim().isNotEmpty;

  bool get _isAffluenceComplete =>
      _isLocationComplete && _affluenceTier != null && _propertyStatus != null;

  @override
  void initState() {
    super.initState();

    // Initialize with 1 empty sibling
    final initialSibling = SiblingInfo(
      name: '',
      relationship: null,
      maritalStatus: null,
    );
    initialSibling.nameController.addListener(_onFieldChanged);
    _siblings.add(initialSibling);

    _fatherNameController.addListener(_onFieldChanged);
    _fatherOccController.addListener(_onFieldChanged);
    _motherNameController.addListener(_onFieldChanged);
    _motherOccController.addListener(_onFieldChanged);
    _residenceCityController.addListener(_onFieldChanged);
    _nativeTownController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!mounted) return;
    _checkAndTriggerAutoScroll();
    setState(() {});
  }

  void _checkAndTriggerAutoScroll() {
    bool shouldScroll = false;

    if (_isFatherComplete && !_prevMotherVisible) {
      _prevMotherVisible = true;
      shouldScroll = true;
    } else if (!_isFatherComplete) {
      _prevMotherVisible = false;
    }

    if (_isMotherComplete && !_prevSiblingsVisible) {
      _prevSiblingsVisible = true;
      shouldScroll = true;
    } else if (!_isMotherComplete) {
      _prevSiblingsVisible = false;
    }

    if (_isSiblingsComplete && !_prevStructureVisible) {
      _prevStructureVisible = true;
      shouldScroll = true;
    } else if (!_isSiblingsComplete) {
      _prevStructureVisible = false;
    }

    if (_isStructureComplete && !_prevLocationVisible) {
      _prevLocationVisible = true;
      shouldScroll = true;
    } else if (!_isStructureComplete) {
      _prevLocationVisible = false;
    }

    if (_isLocationComplete && !_prevAffluenceVisible) {
      _prevAffluenceVisible = true;
      shouldScroll = true;
    } else if (!_isLocationComplete) {
      _prevAffluenceVisible = false;
    }

    if (shouldScroll) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _fatherNameController.removeListener(_onFieldChanged);
    _fatherOccController.removeListener(_onFieldChanged);
    _motherNameController.removeListener(_onFieldChanged);
    _motherOccController.removeListener(_onFieldChanged);
    _residenceCityController.removeListener(_onFieldChanged);
    _nativeTownController.removeListener(_onFieldChanged);
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
    final newSibling = SiblingInfo(
      name: '',
      relationship: null,
      maritalStatus: null,
    );
    newSibling.nameController.addListener(_onFieldChanged);
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
    _checkAndTriggerAutoScroll();
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family Details Draft Saved Successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();

    if (!_isAffluenceComplete) {
      String message = 'Please fill all mandatory fields marked with *';
      if (!_isFatherComplete) {
        message = "Please enter Father's Occupation & Status *";
      } else if (!_isMotherComplete) {
        message = "Please enter Mother's Occupation & Status *";
      } else if (!_isSiblingsComplete) {
        message = 'Please select relationship & marital status for siblings or check No Siblings *';
      } else if (!_isStructureComplete) {
        message = 'Please choose Family Type and Family Values *';
      } else if (!_isLocationComplete) {
        message = 'Please enter Residence City and Native Town *';
      } else if (!_isAffluenceComplete) {
        message = 'Please choose Affluence Tier and Property Status *';
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

    debugPrint('====================================================');
    debugPrint('[STEP 2: FAMILY DETAILS SUBMITTED]');
    debugPrint('  Father Name       : ${_fatherNameController.text}');
    debugPrint('  Father Occupation : ${_fatherOccController.text}');
    debugPrint('  Mother Name       : ${_motherNameController.text}');
    debugPrint('  Mother Occupation : ${_motherOccController.text}');
    debugPrint('  No Siblings       : $_noSiblings');
    if (!_noSiblings) {
      for (int i = 0; i < _siblings.length; i++) {
        debugPrint(
          '    Sibling ${i + 1}  : Name="${_siblings[i].nameController.text}", Rel="${_siblings[i].relationship}", Marital="${_siblings[i].maritalStatus}"',
        );
      }
    }
    debugPrint('  Family Type       : $_familyType');
    debugPrint('  Family Values     : $_familyValues');
    debugPrint('  Residence City    : ${_residenceCityController.text}');
    debugPrint('  Native Town       : ${_nativeTownController.text}');
    debugPrint('  Affluence Tier    : $_affluenceTier');
    debugPrint('  Property Status   : $_propertyStatus');
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family Details Saved! Proceeding to Step 3.'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EducationCareerScreen(
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
                    // A) Step 2 Subheader
                    _buildStepSubheader(),
                    const SizedBox(height: 14),

                    // B) Father's Details Card (Always Visible)
                    _buildFatherDetailsCard(),
                    const SizedBox(height: 14),

                    // C) Mother's Details Card (Revealed after Father's mandatory details)
                    _buildProgressiveCard(
                      isVisible: _isFatherComplete,
                      child: _buildMotherDetailsCard(),
                    ),

                    // D) Siblings Details Card (Revealed after Mother's mandatory details)
                    _buildProgressiveCard(
                      isVisible: _isMotherComplete,
                      child: _buildSiblingsDetailsCard(),
                    ),

                    // E) Structure & Family Values Card (Revealed after Siblings details)
                    _buildProgressiveCard(
                      isVisible: _isSiblingsComplete,
                      child: _buildStructureFamilyValuesCard(),
                    ),

                    // F) Location & Native Roots Card (Revealed after Structure & Values)
                    _buildProgressiveCard(
                      isVisible: _isStructureComplete,
                      child: _buildLocationNativeRootsCard(),
                    ),

                    // G) Family Affluence & Assets Card (Revealed after Location)
                    _buildProgressiveCard(
                      isVisible: _isLocationComplete,
                      child: _buildFamilyAffluenceCard(),
                    ),

                    // H) Security Footer Badge (Revealed after Affluence)
                    _buildProgressiveCard(
                      isVisible: _isAffluenceComplete,
                      child: _buildSecurityFooterBadge(),
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

  // 1. Custom App Bar (Height: 58px, #881337 Deep Maroon)
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
                  'STEP 2 OF 6',
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
                  child: Icon(Icons.favorite_rounded, color: Color(0xFFE5A93C), size: 16),
                ),
              ),
            ),
          ),
        ],
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
              'STEP 2 OF 6 • FAMILY DETAILS',
              style: TextStyle(
                color: Color(0xFF881337),
                fontSize: 12,
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
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10.5,
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
              fontSize: 11.5,
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
              fontSize: 11.5,
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
                  fontSize: 10.5,
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
              _checkAndTriggerAutoScroll();
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
                        _checkAndTriggerAutoScroll();
                      },
                      activeColor: const Color(0xFF881337),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'No Siblings (Only Child)',
                    style: TextStyle(
                      fontSize: 12.5,
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
                        fontSize: 12.5,
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
                          fontSize: 11,
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
                      fontSize: 12,
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
                        fontSize: 11.5,
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
              fontSize: 11.5,
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                  fontSize: 11.5,
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
                fontSize: 11.5,
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
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
                  range: '₹5L – ₹15L / year',
                  isSelected: _affluenceTier == 'Middle Class',
                  onTap: () {
                    setState(() => _affluenceTier = 'Middle Class');
                    _checkAndTriggerAutoScroll();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTierBox(
                  title: 'Upper Middle',
                  range: '₹15L – ₹40L / year',
                  isSelected: _affluenceTier == 'Upper Middle',
                  onTap: () {
                    setState(() => _affluenceTier = 'Upper Middle');
                    _checkAndTriggerAutoScroll();
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
                  range: '₹40L – ₹1 Cr+ / year',
                  isSelected: _affluenceTier == 'Affluent/Rich',
                  onTap: () {
                    setState(() => _affluenceTier = 'Affluent/Rich');
                    _checkAndTriggerAutoScroll();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTierBox(
                  title: 'Elite',
                  range: '₹1 Cr+ / year & Ultra HNI',
                  isSelected: _affluenceTier == 'Elite',
                  onTap: () {
                    setState(() => _affluenceTier = 'Elite');
                    _checkAndTriggerAutoScroll();
                  },
                ),
              ),
            ],
          ),

          if (_affluenceTier != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFCE7EC), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF881337).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Color(0xFF881337),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Selected Range: ',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF881337),
                        ),
                        children: [
                          TextSpan(
                            text: _selectedRangeDetail,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                    _checkAndTriggerAutoScroll();
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
                    _checkAndTriggerAutoScroll();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _selectedRangeDetail {
    switch (_affluenceTier) {
      case 'Middle Class':
        return '₹5L – ₹15L Annual Family Income';
      case 'Upper Middle':
        return '₹15L – ₹40L Annual Family Income';
      case 'Affluent/Rich':
        return '₹40L – ₹1 Cr+ Annual Family Income';
      case 'Elite':
        return '₹1 Cr+ & Ultra HNI Annual Family Income';
      default:
        return '${_affluenceTier ?? ""} Annual Family Income';
    }
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
                  fontSize: 11,
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
          fontSize: 11.5,
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
                  fontSize: 12,
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
                fontSize: 12,
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
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Actions Bar (Height 64px, #FAF8FF with shadow)
  Widget _buildBottomNavigationBar(BuildContext context) {
    final bool canContinue = _isAffluenceComplete;

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
                    fontSize: 12,
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
