import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../registration/basic_info_screen.dart';

class AccountSecurityScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;

  const AccountSecurityScreen({
    super.key,
    this.mobileNumber,
    this.countryCode,
  });

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _biometricEnabled = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasDigit => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      _passwordController.text.contains(RegExp(r'[@#$!%*?&]'));
  bool get _hasMixedCase =>
      _passwordController.text.contains(RegExp(r'[A-Z]')) &&
      _passwordController.text.contains(RegExp(r'[a-z]'));

  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  int get _strengthScore {
    if (_passwordController.text.isEmpty) return 0;
    int score = 0;
    if (_hasMinLength) score++;
    if (_hasDigit) score++;
    if (_hasSpecialChar) score++;
    if (_hasMixedCase) score++;
    return score;
  }

  String get _strengthText {
    final score = _strengthScore;
    if (_passwordController.text.isEmpty) return 'Required';
    if (score == 4) return '• Strong (98%)';
    if (score == 3) return '• Good (75%)';
    if (score == 2) return '• Fair (50%)';
    return '• Weak (25%)';
  }

  Color get _strengthBadgeBg {
    final score = _strengthScore;
    if (_passwordController.text.isEmpty) return const Color(0xFFF1F5F9);
    if (score == 4) return const Color(0xFFFEF3C7);
    if (score == 3) return const Color(0xFFE0F2FE);
    if (score == 2) return const Color(0xFFFEF3C7);
    return const Color(0xFFFEE2E2);
  }

  Color get _strengthTextColor {
    final score = _strengthScore;
    if (_passwordController.text.isEmpty) return const Color(0xFF64748B);
    if (score == 4) return const Color(0xFF92400E);
    if (score == 3) return const Color(0xFF0369A1);
    if (score == 2) return const Color(0xFFB45309);
    return const Color(0xFFB91C1C);
  }

  int get _completedPercentage {
    // Step 1 + Step 2 = 66%
    // In Step 3:
    // +17% for valid password (all criteria met)
    // +17% for matching confirm password
    int pct = 66;
    if (_strengthScore == 4) pct += 17;
    if (_passwordsMatch) pct += 17;
    return pct > 100 ? 100 : pct;
  }

  double get _progressFactor => _completedPercentage / 100.0;

  void _onProceed() {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a password'),
          backgroundColor: Color(0xFF701A33),
        ),
      );
      return;
    }

    if (_strengthScore < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fulfill all password criteria'),
          backgroundColor: Color(0xFF701A33),
        ),
      );
      return;
    }

    if (!_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Color(0xFF701A33),
        ),
      );
      return;
    }

    debugPrint('====================================================');
    debugPrint('[AUTH: ACCOUNT SECURITY & PASSWORD CREATED]');
    debugPrint('  Country Code     : ${widget.countryCode}');
    debugPrint('  Mobile Number    : ${widget.mobileNumber}');
    debugPrint('  Full Mobile      : ${widget.countryCode} ${widget.mobileNumber}');
    debugPrint('  Email ID         : ${_emailController.text.trim()}');
    debugPrint('  Created Password : ${_passwordController.text}');
    debugPrint('  Confirm Password : ${_confirmPasswordController.text}');
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account Security Configured Successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1000),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BasicInfoScreen(
              mobileNumber: widget.mobileNumber,
              countryCode: widget.countryCode,
              email: _emailController.text.trim(),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Custom App Bar
            _buildCustomAppBar(context),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Progress Card
                    _buildStepProgressCard(),
                    const SizedBox(height: 16),

                    // Mail ID Card
                    _buildMailIdCard(),
                    const SizedBox(height: 18),

                    // Final Step of Security Pill + Title + Subtitle
                    _buildHeaderSection(),
                    const SizedBox(height: 18),

                    // Password Form Card (New Password, Criteria, Confirm Password, Biometric)
                    _buildPasswordFormCard(),
                    const SizedBox(height: 18),

                    // Security Encryption Badge
                    _buildSecurityVaultBadge(),
                    const SizedBox(height: 16),

                    // Proceed Button
                    _buildProceedButton(),
                    const SizedBox(height: 14),

                    // Footer Link
                    _buildFooterLink(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Custom App Bar
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
                  'TAMIL ALLIANCE',
                  style: TextStyle(
                    color: Color(0xFFE5A93C),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Account Registration',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Logo Badge
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
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Color(0xFFE5A93C),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  // 2. Step 3 of 3 Progress Card
  Widget _buildStepProgressCard() {
    final pct = _completedPercentage;
    final is100 = pct >= 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
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
              const Icon(
                Icons.verified_user_rounded,
                color: Color(0xFF701A33),
                size: 17,
              ),
              const SizedBox(width: 6),
              const Text(
                'Step 3 of 3: Account Security',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: is100 ? const Color(0xFFD1FAE5) : const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  is100 ? '100% Complete' : '$pct% Completed',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: is100 ? const Color(0xFF065F46) : const Color(0xFF9F1239),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Dynamic Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 5,
                  width: double.infinity,
                  color: const Color(0xFFF1F5F9),
                ),
                FractionallySizedBox(
                  widthFactor: _progressFactor,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    height: 5,
                    color: const Color(0xFF701A33),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Mail Id Card
  Widget _buildMailIdCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
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
              const Text(
                'Mail Id',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OPTIONAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your email address',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Header Section
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pill: FINAL STEP OF SECURITY
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFCE7F3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.lock_rounded,
                size: 12,
                color: Color(0xFF701A33),
              ),
              SizedBox(width: 5),
              Text(
                'FINAL STEP OF SECURITY',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Color(0xFF701A33),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Title: Set Secure Password
        const Text(
          'Set Secure Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            fontFamily: 'serif',
            color: Color(0xFF5B1124),
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        // Subtitle
        const Text(
          'Protect your confidential matrimonial biodata, sacred horoscope charts, and intimate family communications.',
          style: TextStyle(
            fontSize: 12.5,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // 5. Password Form Card
  Widget _buildPasswordFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A) New Password Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Password',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (_passwordController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _strengthBadgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _strengthText,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: _strengthTextColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // New Password Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter secure password',
                      hintStyle: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF64748B),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 4-Segmented Strength Bar
          Row(
            children: List.generate(4, (index) {
              final isFilled = index < _strengthScore;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index == 3 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? const Color(0xFF5B1124)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),

          // Subtext right-aligned
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _strengthScore == 4
                  ? 'Exceptional cryptographic entropy'
                  : 'Requires 8+ chars, numbers & symbols',
              style: TextStyle(
                fontSize: 10,
                color: _strengthScore == 4
                    ? const Color(0xFF92400E)
                    : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // B) Password Criteria Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PASSWORD CRITERIA',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF475569),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 10),
                _buildCriteriaItem('At least 8 characters length', _hasMinLength),
                const SizedBox(height: 6),
                _buildCriteriaItem('At least 1 numerical digit (0-9)', _hasDigit),
                const SizedBox(height: 6),
                _buildCriteriaItem('At least 1 special symbol (@, #, \$, !)', _hasSpecialChar),
                const SizedBox(height: 6),
                _buildCriteriaItem('Mixed uppercase and lowercase letters', _hasMixedCase),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // C) Confirm Password Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (_passwordsMatch)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check_circle,
                      size: 13,
                      color: Color(0xFF065F46),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Passwords Match',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Confirm Password Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: _passwordController.text.isNotEmpty &&
                      _confirmPasswordController.text.isNotEmpty &&
                      !_passwordsMatch
                  ? Border.all(color: const Color(0xFFE11D48), width: 1.2)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Confirm password',
                      hintStyle: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
                if (_passwordsMatch)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.check_circle_outline_rounded,
                      color: Color(0xFF065F46),
                      size: 20,
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // D) Enable Biometric Login Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBEAFE),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.fingerprint_rounded,
                      color: Color(0xFF3B82F6),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Enable Biometric Login',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Instant Face ID or Fingerprint unlock',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _biometricEnabled = !_biometricEnabled;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 48,
                    height: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: _biometricEnabled
                          ? const Color(0xFF701A33)
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: _biometricEnabled
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          _biometricEnabled ? Icons.check : Icons.close,
                          size: 13,
                          color: _biometricEnabled
                              ? const Color(0xFF701A33)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaItem(String title, bool isMet) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isMet ? const Color(0xFFE0E7FF) : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.check,
              size: 11,
              color: isMet ? const Color(0xFF4338CA) : const Color(0xFF94A3B8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            color: isMet ? const Color(0xFF334155) : const Color(0xFF94A3B8),
            fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // 6. Security Vault Badge
  Widget _buildSecurityVaultBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.shield_rounded,
          size: 13,
          color: Color(0xFF92400E),
        ),
        SizedBox(width: 6),
        Flexible(
          child: Text(
            'Encrypted with 256–bit AES Vault • Zero Spam Guarantee',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF78350F),
            ),
          ),
        ),
      ],
    );
  }

  // 7. Proceed Button
  Widget _buildProceedButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF701A33),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59701A33),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _onProceed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Proceed to Create Profile (Step 1)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 8. Footer Link
  Widget _buildFooterLink() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: const Text(
          'Need help? Contact Alliance Family Desk',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E40AF),
          ),
        ),
      ),
    );
  }
}
