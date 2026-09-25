import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mobile_auth_screen.dart';
import 'password_login_screen.dart';

class OtpLoginScreen extends StatefulWidget {
  final String? initialPhone;
  final String? initialCountryCode;

  const OtpLoginScreen({
    super.key,
    this.initialPhone,
    this.initialCountryCode,
  });

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  late final TextEditingController _mobileController;
  String _selectedCountryCode = '+91';

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

  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(4, (index) => FocusNode());

  int _resendCountdown = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.initialPhone ?? '');
    if (widget.initialCountryCode != null && widget.initialCountryCode!.isNotEmpty) {
      _selectedCountryCode = widget.initialCountryCode!;
    }
    _mobileController.addListener(() {
      setState(() {});
    });
    for (var f in _otpFocusNodes) {
      f.addListener(() {
        if (mounted) setState(() {});
      });
    }
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _resendCountdown = 45;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mobileController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();

  bool get _isMobileValid =>
      _mobileController.text.replaceAll(RegExp(r'\D'), '').length >= 10;

  String get _maskedMobile {
    final digits = _mobileController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 4) {
      final last4 = digits.substring(digits.length - 4);
      return '**$last4';
    }
    return '****';
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
                      final isSelected = item['code'] == _selectedCountryCode &&
                          (item['name'] == 'India' || _selectedCountryCode != '+91' || index == 0);
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

  void _onVerifyAndLogin() {
    final otp = _otpValue;
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit OTP'),
          backgroundColor: Color(0xFFE11D48),
          duration: Duration(milliseconds: 1500),
        ),
      );
      return;
    }

    debugPrint('====================================================');
    debugPrint('[AUTH: OTP LOGIN SUBMITTED]');
    debugPrint('  Country Code : $_selectedCountryCode');
    debugPrint('  Mobile Number: ${_mobileController.text.trim()}');
    debugPrint('  Full Phone   : $_selectedCountryCode ${_mobileController.text.trim()}');
    debugPrint('  Entered OTP  : $otp');
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login Successful! Welcome to Tamil Alliance'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1000),
      ),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  void _onPasswordLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PasswordLoginScreen(
          initialPhone: _mobileController.text.trim(),
          initialCountryCode: _selectedCountryCode,
        ),
      ),
    );
  }

  void _onResendWhatsApp() {
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent via WhatsApp successfully!'),
        backgroundColor: Color(0xFF059669),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerSeconds = _resendCountdown.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Top Bar with Back Button and Centered Quick Verification Pill
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08000000),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 15,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFBCFE8)),
                    ),
                    child: const Text(
                      'QUICK VERIFICATION',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9F1239),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. Circular Logo Badge
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF701A33),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x20701A33),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 40,
                      height: 40,
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
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3. TAMIL ALLIANCE Subtitle
              const Text(
                'TAMIL ALLIANCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD97706),
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 6),

              // 4. Login with OTP • OTP உள்நுழைவு Title
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF701A33),
                    fontFamily: 'serif',
                  ),
                  children: [
                    TextSpan(text: 'Login with OTP '),
                    TextSpan(
                      text: '• OTP உள்நுழைவு',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF831843),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // 5. Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Enter your registered mobile number to receive a secure 4–digit verification code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 6. Main Card Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A) Mobile Number Header & Verified Only Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Mobile Number',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              '*',
                              style: TextStyle(
                                color: Color(0xFFE11D48),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (_isMobileValid)
                          Row(
                            children: const [
                              Icon(Icons.check_circle, size: 13, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text(
                                'Verified Only',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // B) Mobile Input with Country Code (No flag, working bottom sheet, no pencil icon)
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          // Country Code Dropdown
                          GestureDetector(
                            onTap: _showCountryPicker,
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  Text(
                                    _selectedCountryCode,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: Color(0xFF64748B),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
                          const SizedBox(width: 10),

                          // Phone Number Input (Empty default)
                          Expanded(
                            child: TextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                letterSpacing: 0.5,
                              ),
                              decoration: const InputDecoration(
                                filled: false,
                                fillColor: Colors.transparent,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Enter mobile number',
                                hintStyle: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // OTP Sent Sub-caption
                    Text(
                      _isMobileValid
                          ? 'OTP sent to registered mobile ending in $_maskedMobile'
                          : 'OTP will be sent to your registered mobile number',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // C) Enter 4-Digit OTP Header & Instant Badge
                    Row(
                      children: [
                        const Text(
                          'Enter 4–Digit OTP',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Instant',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Auto-reading...',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF94A3B8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // D) 4-Box OTP Input Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return _buildOtpBox(index);
                      }),
                    ),
                    const SizedBox(height: 14),

                    // E) Timer & Resend via WhatsApp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 4),
                            Text(
                              'Resend OTP in 00:$timerSeconds',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _resendCountdown > 0
                                    ? const Color(0xFFE11D48)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _onResendWhatsApp,
                          child: Row(
                            children: const [
                              Icon(Icons.chat_bubble_outline_rounded, size: 13, color: Color(0xFF059669)),
                              SizedBox(width: 4),
                              Text(
                                'Resend via WhatsApp',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // F) Verify & Log In CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _onVerifyAndLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF701A33),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Verify & Log In',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 17),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // G) OR ALTERNATIVE Separator
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OR ALTERNATIVE',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade400,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // H) Log in with Password instead Button
                    GestureDetector(
                      onTap: _onPasswordLogin,
                      child: Container(
                        width: double.infinity,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.key_rounded, size: 16, color: Color(0xFF2563EB)),
                            SizedBox(width: 8),
                            Text(
                              'Log in with Password instead',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 7. New to Tamil Alliance? Register Free
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New to Tamil Alliance? ',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MobileAuthScreen()),
                      );
                    },
                    child: const Text(
                      'Register Free',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF701A33),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final controller = _otpControllers[index];
    final focusNode = _otpFocusNodes[index];
    final hasValue = controller.text.isNotEmpty;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasValue || focusNode.hasFocus
              ? const Color(0xFF701A33)
              : const Color(0xFFE2E8F0),
          width: hasValue || focusNode.hasFocus ? 1.8 : 1.0,
        ),
        boxShadow: hasValue || focusNode.hasFocus
            ? const [
                BoxShadow(
                  color: Color(0x15701A33),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF701A33),
          ),
          decoration: const InputDecoration(
            counterText: '',
            filled: false,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: '•',
            hintStyle: TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            setState(() {});
            if (value.isNotEmpty) {
              if (index < 3) {
                _otpFocusNodes[index + 1].requestFocus();
              } else {
                focusNode.unfocus();
              }
            } else {
              if (index > 0) {
                _otpFocusNodes[index - 1].requestFocus();
              }
            }
          },
        ),
      ),
    );
  }
}
