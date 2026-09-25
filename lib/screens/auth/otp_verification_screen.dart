import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import 'account_security_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final String countryCode;

  const OtpVerificationScreen({
    super.key,
    this.mobileNumber = '',
    this.countryCode = '+91',
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _resendSeconds = 24;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto focus native keyboard after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _resendSeconds = 24;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _otp => _otpController.text;

  int get _completedPercentage {
    // Step 1 completed = 33%
    // Step 2 fills from 33% to 66% (33 + 8.25% per digit)
    final digits = _otp.length;
    if (digits == 0) return 33;
    if (digits == 1) return 41;
    if (digits == 2) return 50;
    if (digits == 3) return 58;
    return 66;
  }

  double get _progressFactor => _completedPercentage / 100.0;

  void _verifyOtp() {
    if (_otp.length == 4) {
      debugPrint('====================================================');
      debugPrint('[AUTH: OTP VERIFIED]');
      debugPrint('  Country Code : ${widget.countryCode}');
      debugPrint('  Mobile Number: ${widget.mobileNumber}');
      debugPrint('  Full Phone   : ${widget.countryCode} ${widget.mobileNumber}');
      debugPrint('  Entered OTP  : $_otp');
      debugPrint('====================================================');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Verified Successfully!'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(milliseconds: 1000),
        ),
      );
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AccountSecurityScreen(
                mobileNumber: widget.mobileNumber,
                countryCode: widget.countryCode,
              ),
            ),
          );
        }
      });
    } else {
      _focusNode.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 4-digit OTP'),
          backgroundColor: Color(0xFF701A33),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPhone = '${widget.countryCode} ${widget.mobileNumber}';

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
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
                'Otp Verification',
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
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Step 2 of 3 Navigation & Dynamic Progress Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.arrow_back, size: 14, color: Color(0xFF4B5563)),
                          SizedBox(width: 4),
                          Text(
                            'Back to Mobile Number',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_completedPercentage% Completed',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF701A33),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'STEP 2 OF 3',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: Color(0xFF9A3412),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Dynamic Progress Bar Track (fills 33% -> 66%)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Container(
                        height: 5,
                        width: double.infinity,
                        color: const Color(0xFFEDE9FE),
                      ),
                      AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 300),
                        widthFactor: _progressFactor,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF701A33),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Lock & Message Shield Badge
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEAD5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFD8B3),
                            width: 4,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock,
                            size: 30,
                            color: Color(0xFF701A33),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF701A33),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 3. Verify Mobile Number Heading
                const Text(
                  'Verify Mobile Number',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
                const SizedBox(height: 6),

                const Text(
                  'Enter the 4–digit OTP sent via SMS to',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),

                // Phone Number and Edit link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayPhone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Edit Number',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.edit, size: 12, color: Color(0xFF1D4ED8)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // 4. Auto-reading SMS Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Auto-reading SMS... 100% Secure & Instant',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Interactive 4-Digit OTP Boxes with Native Keyboard Support
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Visual 4 Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final hasDigit = index < _otp.length;
                        final digit = hasDigit ? _otp[index] : '';
                        final isCurrent = index == _otp.length;

                        return Container(
                          width: 58,
                          height: 64,
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          decoration: BoxDecoration(
                            color: hasDigit ? Colors.white : const Color(0xFFF3F6FD),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCurrent
                                  ? const Color(0xFF701A33)
                                  : (hasDigit
                                      ? const Color(0xFF701A33).withValues(alpha: 0.6)
                                      : const Color(0xFFE2E8F0)),
                              width: isCurrent ? 2.0 : 1.2,
                            ),
                            boxShadow: hasDigit || isCurrent
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              digit,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF701A33),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    // Hidden Transparent TextField for Native Keyboard
                    Opacity(
                      opacity: 0.0,
                      child: SizedBox(
                        width: 280,
                        height: 64,
                        child: TextField(
                          controller: _otpController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (val) {
                            setState(() {});
                            if (val.length == 4) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 6. Resend OTP Pill with Timer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 14,
                        color: Color(0xFF78350F),
                      ),
                      const SizedBox(width: 6),
                      _resendSeconds > 0
                          ? Text(
                              'Resend OTP in 00:${_resendSeconds.toString().padLeft(2, '0')}s',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4B5563),
                              ),
                            )
                          : GestureDetector(
                              onTap: _startResendTimer,
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF701A33),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 7. Verify & Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _verifyOtp,
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
                          'Verify & Continue',
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

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
