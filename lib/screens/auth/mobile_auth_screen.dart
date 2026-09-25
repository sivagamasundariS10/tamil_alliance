import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'otp_verification_screen.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({super.key});

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';
  bool _agreeTerms = false;
  bool _confirmMarriagePurpose = false;
  bool _whatsappAlerts = false;

  final List<Map<String, String>> _countryCodes = [
    {'name': 'India', 'code': '+91'},
    {'name': 'United States', 'code': '+1'},
    {'name': 'United Kingdom', 'code': '+44'},
    {'name': 'Singapore', 'code': '+65'},
    {'name': 'Malaysia', 'code': '+60'},
    {'name': 'United Arab Emirates', 'code': '+971'},
    {'name': 'Sri Lanka', 'code': '+94'},
    {'name': 'Australia', 'code': '+61'},
    {'name': 'Canada', 'code': '+1'},
    {'name': 'Germany', 'code': '+49'},
    {'name': 'France', 'code': '+33'},
    {'name': 'Qatar', 'code': '+974'},
    {'name': 'Saudi Arabia', 'code': '+966'},
    {'name': 'Oman', 'code': '+968'},
    {'name': 'Kuwait', 'code': '+965'},
  ];

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    final cleanDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return cleanDigits.length >= 10;
  }

  int get _completedPercentage {
    int score = 0;
    final cleanDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (cleanDigits.length >= 10) {
      score += 15;
    } else if (cleanDigits.length >= 5) {
      score += 7;
    }

    if (_agreeTerms) {
      score += 9;
    }
    if (_confirmMarriagePurpose) {
      score += 9;
    }

    return score > 33 ? 33 : score;
  }

  double get _progressFactor {
    return _completedPercentage / 100.0;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.65,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                const SizedBox(height: 18),
                const Text(
                  'Select Country Code',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.separated(
                    itemCount: _countryCodes.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    itemBuilder: (context, index) {
                      final item = _countryCodes[index];
                      final isSelected = item['code'] == _selectedCountryCode;
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        title: Text(
                          item['name']!,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF701A33)
                                : const Color(0xFF1F2937),
                          ),
                        ),
                        trailing: Text(
                          item['code']!,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF701A33)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCountryCode = item['code']!;
                          });
                          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF701A33),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'TAMIL ALLIANCE',
                style: TextStyle(
                  color: Color(0xFFE5B84B),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Phone Authentication',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.favorite,
                  color: AppColors.gold,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Step Progress Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
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
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Color(0xFF701A33),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '1',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Step 1 of 3: Mobile Verification',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$_completedPercentage% Completed',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF701A33),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress Bar Track
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              width: double.infinity,
                              color: const Color(0xFFF1F5F9),
                            ),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 300),
                              widthFactor: _progressFactor,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF701A33),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 2. Hero Information Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges Row
                      Row(
                        children: [
                          // Auspicious Beginnings
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome,
                                    size: 13, color: Color(0xFF9A3412)),
                                SizedBox(width: 5),
                                Text(
                                  'Auspicious Beginnings',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF9A3412),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Trusted Portal
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_user_outlined,
                                    size: 13, color: Color(0xFF1D4ED8)),
                                SizedBox(width: 5),
                                Text(
                                  'Trusted Portal',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1D4ED8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Heading
                      const Text(
                        'Enter Your Mobile Number',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF701A33),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                        'We will send an instant 6-digit verification code to validate your profile and ensure family trust.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Social Proof Badge with 3 Realistic Avatars
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EEFD),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // 3 Overlapping Real Wedding Avatars
                            SizedBox(
                              width: 68,
                              height: 30,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: _buildImageAvatar(
                                        'assets/images/avatar1.jpg'),
                                  ),
                                  Positioned(
                                    left: 18,
                                    child: _buildImageAvatar(
                                        'assets/images/avatar2.jpg'),
                                  ),
                                  Positioned(
                                    left: 36,
                                    child: _buildImageAvatar(
                                        'assets/images/avatar3.jpg'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF4B5563),
                                      height: 1.35),
                                  children: [
                                    TextSpan(text: 'Joined by '),
                                    TextSpan(
                                      text: '54,000+ verified families',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF701A33),
                                      ),
                                    ),
                                    TextSpan(
                                        text: '\nacross Tamil Nadu & overseas.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Primary Contact Number Input Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Primary Contact Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            'Mandatory',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF701A33),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Phone Input Row with Country Code
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            // Interactive Country Code Selector (No Flag)
                            InkWell(
                              onTap: _showCountryPicker,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountryCode,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Mobile Number Text Input
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111827),
                                  letterSpacing: 0.3,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  fillColor: Colors.transparent,
                                  hintText: 'Enter 10-digit number',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            // Validated Check Icon ONLY when phone is valid (NO HIDDEN CIRCLE WHEN EMPTY)
                            if (_isPhoneValid)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFCE7F3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Color(0xFFBE185D),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Privacy Note
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.lock, size: 13.5, color: Color(0xFF854D0E)),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Direct numbers are strictly private and never shared without mutual family consent.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 4. Consents & Declarations Section
                const Text(
                  'CONSENTS & DECLARATIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 12),

                // Declaration 1: Terms & Conditions
                _buildConsentTile(
                  isSelected: _agreeTerms,
                  onTap: () {
                    setState(() {
                      _agreeTerms = !_agreeTerms;
                    });
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          height: 1.4),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF701A33)),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF701A33)),
                        ),
                        TextSpan(text: ' of Tamil Alliance.'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Declaration 2: Marriage Purpose
                _buildConsentTile(
                  isSelected: _confirmMarriagePurpose,
                  onTap: () {
                    setState(() {
                      _confirmMarriagePurpose = !_confirmMarriagePurpose;
                    });
                  },
                  child: const Text(
                    'I confirm this account is created for marriage purpose only, upholding traditional decorum and authentic family values.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF374151),
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Declaration 3: WhatsApp Auspicious Alerts Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E7FF)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _whatsappAlerts = !_whatsappAlerts;
                          });
                        },
                        child: _buildCheckboxBox(_whatsappAlerts),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'WhatsApp Auspicious Alerts',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Enabled',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF065F46),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Receive matched horoscope points (Porutham) and immediate interest alerts directly on WhatsApp.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF6B7280),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // 5. Primary CTA Button: Get 4-Digit OTP ->
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isPhoneValid && _agreeTerms && _confirmMarriagePurpose
                        ? () {
                            debugPrint('====================================================');
                            debugPrint('[AUTH: MOBILE NUMBER SUBMITTED]');
                            debugPrint('  Country Code : $_selectedCountryCode');
                            debugPrint('  Phone Number : ${_phoneController.text.trim()}');
                            debugPrint('  Full Mobile  : $_selectedCountryCode ${_phoneController.text.trim()}');
                            debugPrint('  Agreed Terms : $_agreeTerms');
                            debugPrint('  Confirmed Marriage Purpose : $_confirmMarriagePurpose');
                            debugPrint('====================================================');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OtpVerificationScreen(
                                  mobileNumber: _phoneController.text.trim(),
                                  countryCode: _selectedCountryCode,
                                ),
                              ),
                            );
                          }
                        : () {
                            if (!_isPhoneValid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid 10-digit mobile number'),
                                  backgroundColor: Color(0xFF701A33),
                                ),
                              );
                            } else if (!_agreeTerms || !_confirmMarriagePurpose) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please accept the required declarations to continue'),
                                  backgroundColor: Color(0xFF701A33),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF701A33),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get 4–Digit OTP',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 6. Footer Trust Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.verified, size: 12.5, color: Color(0xFF701A33)),
                    SizedBox(width: 4),
                    Text(
                      '100% Spam Free',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                    SizedBox(width: 8),
                    Icon(Icons.shield, size: 12.5, color: Color(0xFF701A33)),
                    SizedBox(width: 4),
                    Text(
                      'Anti–Commercial',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                    SizedBox(width: 8),
                    Icon(Icons.lock, size: 12.5, color: Color(0xFF701A33)),
                    SizedBox(width: 4),
                    Text(
                      '256–bit SSL',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Revered Tamil Matrimonial Network • Chennai • Madurai • Coimbatore • Global Diaspora',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageAvatar(String assetPath) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF701A33),
            child: const Icon(Icons.person, size: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: _buildCheckboxBox(isSelected),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxBox(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF701A33) : Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color:
              isSelected ? const Color(0xFF701A33) : const Color(0xFFD1D5DB),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Center(
              child: Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
