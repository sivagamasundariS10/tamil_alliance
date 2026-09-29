import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PremiumScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const PremiumScreen({
    super.key,
    this.onNavigateToHome,
  });

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedServiceType = 0; // 0: Self Service, 1: Personal Service
  String _activePlan = 'Prestige';

  void _showCheckoutModal({
    required String planName,
    required String price,
    required String validity,
    required String contacts,
    required Color themeColor,
    String badge = 'SELECTED PLAN • MOST POPULAR',
    String boost = '3x Profile Visibility Boost',
  }) {
    String selectedPaymentMethod = 'UPI';
    String selectedUpiApp = 'QR';
    bool isPrivilegesExpanded = true;
    final TextEditingController upiController = TextEditingController();
    bool isUpiVerified = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Column(
                  children: [
                  // ───────────────────────────────────────────────
                  // TOP HEADER (Maroon Brand Bar)
                  // ───────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF701A33),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(ctx),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0x22FFFFFF),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Secure Checkout & Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0x33FFFFFF),
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 24,
                              width: 24,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.workspace_premium_rounded,
                                color: Color(0xFFF5D68B),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ───────────────────────────────────────────────
                  // SCROLLABLE CONTENT BODY (4 Detailed Cards)
                  // ───────────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── CARD 1: Selected Plan Summary ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge & ID Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFF1F2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFFECDD3)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFBE123C),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            badge,
                                            style: const TextStyle(
                                              color: Color(0xFFBE123C),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Text(
                                      'ABID-7749',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Plan Name
                                Text(
                                  planName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 5),

                                // Validity Row
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xFFBE123C)),
                                    const SizedBox(width: 6),
                                    Text(
                                      validity,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Plan Description
                                const Text(
                                  'Accelerate verified parent connections, unlock locked jathagams, and initiate direct family alliances.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Base Price Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Base Membership Price',
                                      style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                    ),
                                    Text(
                                      '$price.00',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20, color: Color(0xFFF1F5F9)),

                                // Total Payable Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'TOTAL PAYABLE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF64748B),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF059669),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'Instant Gold Activation',
                                              style: TextStyle(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF059669),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      price,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF701A33),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── CARD 2: Included Gold Privileges (Collapsible) ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setModalState(() {
                                      isPrivilegesExpanded = !isPrivilegesExpanded;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF1F2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.verified_outlined,
                                          color: Color(0xFFE11D48),
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        child: Text(
                                          'Included Gold Privileges',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        isPrivilegesExpanded
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        color: const Color(0xFF64748B),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                if (isPrivilegesExpanded) ...[
                                  const Divider(height: 18, color: Color(0xFFF1F5F9)),
                                  _buildPrivilegeRow(
                                    title: '$contacts Verified Parent Phone Contacts',
                                    subtitle: 'Instant unmasking with family verification log',
                                  ),
                                  _buildPrivilegeRow(
                                    title: 'Unlimited Direct WhatsApp Interests',
                                    subtitle: 'Connect securely through curated family introductions',
                                  ),
                                  _buildPrivilegeRow(
                                    title: '12-House Vedic Jathagam PDF Export',
                                    subtitle: 'Thirukanitha & Vakya Panchangam with Dasa-Bhukti reports',
                                  ),
                                  _buildPrivilegeRow(
                                    title: boost,
                                    subtitle: 'Top slot placement in weekly Parent Alliance Digest',
                                  ),
                                  _buildPrivilegeRow(
                                    title: 'Kulam & Nakshatra Porutham Filters',
                                    subtitle: 'Strict matching across 10 vital Poruthams',
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── CARD 3: Member Credentials ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.badge_outlined,
                                        color: Color(0xFF2563EB),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Member Credentials',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Member profile details verified from registry.'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Edit Info',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFBE123C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Profile Box
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/images/siddharth_doctor.jpg',
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            width: 44,
                                            height: 44,
                                            color: const Color(0xFFE2E8F0),
                                            child: const Icon(Icons.person, color: Color(0xFF64748B)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: const [
                                                Text(
                                                  'Dr. Siddharth Sundaresan',
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Icon(Icons.verified_rounded, size: 14, color: Color(0xFF059669)),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Tamil Brahmin Iyer • TA-2026-0819',
                                              style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Email Receipt
                                Row(
                                  children: const [
                                    Icon(Icons.mail_outline_rounded, size: 14, color: Color(0xFF64748B)),
                                    SizedBox(width: 6),
                                    Text('Receipt', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    Spacer(),
                                    Text(
                                      'siddharth.sun@gmail.com',
                                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Phone Alerts
                                Row(
                                  children: const [
                                    Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Color(0xFF64748B)),
                                    SizedBox(width: 6),
                                    Text('Alerts', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    Spacer(),
                                    Text(
                                      '+91 98402 18921',
                                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ── CARD 4: Payment Options (Razorpay Gateway) ──
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gateway Header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFDF2F8),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.payment_rounded,
                                        color: Color(0xFF701A33),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Payment Options',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          Text(
                                            'Razorpay Secure 256-Bit Gateway',
                                            style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFFBFDBFE)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            'RAZORPAY',
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF1D4ED8),
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Icon(Icons.shield_outlined, size: 10, color: Color(0xFF1D4ED8)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // 1. Instant UPI (Recommended)
                                InkWell(
                                  onTap: () => setModalState(() => selectedPaymentMethod = 'UPI'),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: selectedPaymentMethod == 'UPI' ? const Color(0xFFF8FAFC) : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selectedPaymentMethod == 'UPI'
                                            ? const Color(0xFF701A33)
                                            : const Color(0xFFE2E8F0),
                                        width: selectedPaymentMethod == 'UPI' ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              selectedPaymentMethod == 'UPI'
                                                  ? Icons.radio_button_checked_rounded
                                                  : Icons.radio_button_unchecked_rounded,
                                              color: selectedPaymentMethod == 'UPI'
                                                  ? const Color(0xFF701A33)
                                                  : const Color(0xFFCBD5E1),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.qr_code_2_rounded, size: 18, color: Color(0xFF701A33)),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Instant UPI (Recommended)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w800,
                                                      color: Color(0xFF1E293B),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Google Pay, PhonePe, Paytm, QR',
                                                    style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDCFCE7),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                '0% FEE',
                                                style: TextStyle(
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF15803D),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Sub-tabs Grid for UPI
                                        if (selectedPaymentMethod == 'UPI') ...[
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              _buildUpiAppTab(
                                                label: 'Show QR',
                                                icon: Icons.qr_code_scanner_rounded,
                                                isSelected: selectedUpiApp == 'QR',
                                                onTap: () => setModalState(() => selectedUpiApp = 'QR'),
                                              ),
                                              const SizedBox(width: 6),
                                              _buildUpiAppTab(
                                                label: 'GPay',
                                                icon: Icons.phone_android_rounded,
                                                isSelected: selectedUpiApp == 'GPAY',
                                                onTap: () => setModalState(() => selectedUpiApp = 'GPAY'),
                                              ),
                                              const SizedBox(width: 6),
                                              _buildUpiAppTab(
                                                label: 'PhonePe',
                                                icon: Icons.mobile_friendly_rounded,
                                                isSelected: selectedUpiApp == 'PHONEPE',
                                                onTap: () => setModalState(() => selectedUpiApp = 'PHONEPE'),
                                              ),
                                              const SizedBox(width: 6),
                                              _buildUpiAppTab(
                                                label: 'Paytm',
                                                icon: Icons.account_balance_wallet_rounded,
                                                isSelected: selectedUpiApp == 'PAYTM',
                                                onTap: () => setModalState(() => selectedUpiApp = 'PAYTM'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          // UPI VPA Verification Field
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: isUpiVerified
                                                    ? const Color(0xFF059669)
                                                    : const Color(0xFFE2E8F0),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: TextField(
                                                      controller: upiController,
                                                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF1E293B)),
                                                      decoration: const InputDecoration(
                                                        hintText: 'e.g. mobile@oksbi, username@apl',
                                                        hintStyle: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                                        border: InputBorder.none,
                                                        isDense: true,
                                                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    print('====================================================');
                                                    print('🔍 [UPI VERIFICATION REQUESTED]');
                                                    print('   VPA Entered : ${upiController.text.isEmpty ? 'siddharth@oksbi' : upiController.text}');
                                                    print('   Status      : Verified ✓');
                                                    print('====================================================');
                                                    setModalState(() {
                                                      isUpiVerified = true;
                                                      if (upiController.text.isEmpty) {
                                                        upiController.text = 'siddharth@oksbi';
                                                      }
                                                    });
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('UPI ID Verified successfully! ✓'),
                                                        backgroundColor: Color(0xFF059669),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  },
                                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(9)),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: isUpiVerified
                                                          ? const Color(0xFF059669)
                                                          : const Color(0xFF701A33),
                                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(9)),
                                                    ),
                                                    child: Text(
                                                      isUpiVerified ? 'Verified ✓' : 'Verify',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // 2. Credit / Debit Card
                                _buildPaymentOptionTile(
                                  title: 'Credit / Debit Card',
                                  subtitle: 'Visa, MasterCard, RuPay, Amex',
                                  icon: Icons.credit_card_rounded,
                                  value: 'CARD',
                                  selectedValue: selectedPaymentMethod,
                                  trailingWidget: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.credit_card_outlined, size: 14, color: Color(0xFF94A3B8)),
                                    ],
                                  ),
                                  onChanged: (v) => setModalState(() => selectedPaymentMethod = v),
                                ),
                                const SizedBox(height: 8),

                                // 3. Net Banking
                                _buildPaymentOptionTile(
                                  title: 'Net Banking',
                                  subtitle: 'SBI, HDFC, ICICI, Axis, Canara',
                                  icon: Icons.account_balance_rounded,
                                  value: 'NETBANKING',
                                  selectedValue: selectedPaymentMethod,
                                  trailingWidget: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                                  onChanged: (v) => setModalState(() => selectedPaymentMethod = v),
                                ),
                                const SizedBox(height: 8),

                                // 4. EMI & PayLater
                                _buildPaymentOptionTile(
                                  title: 'EMI & PayLater',
                                  subtitle: 'Starting at ₹310/mo • Simpl & LazyPay',
                                  icon: Icons.calendar_month_outlined,
                                  value: 'EMI',
                                  selectedValue: selectedPaymentMethod,
                                  trailingWidget: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                                  onChanged: (v) => setModalState(() => selectedPaymentMethod = v),
                                ),
                                const SizedBox(height: 8),

                                // 5. Pay Via Cash Deposit
                                _buildPaymentOptionTile(
                                  title: 'Pay Via Cash Deposit',
                                  subtitle: 'Account number',
                                  icon: Icons.payments_outlined,
                                  value: 'CASH',
                                  selectedValue: selectedPaymentMethod,
                                  trailingWidget: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                                  onChanged: (v) => setModalState(() => selectedPaymentMethod = v),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // ───────────────────────────────────────────────
                  // BOTTOM FIXED PAY BAR (Payable Now + Razorpay Button)
                  // ───────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(12),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'PAYABLE NOW',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF64748B),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF701A33),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      print('====================================================');
                                      print('💳 [USER ACTION: PAYMENT PROCESSED WITH RAZORPAY]');
                                      print('   Plan Activated: $planName');
                                      print('   Amount Paid   : $price');
                                      print('   Validity      : $validity');
                                      print('   Method        : $selectedPaymentMethod ($selectedUpiApp)');
                                      print('   Member ID     : TA-2026-0819');
                                      print('   Status        : Payment Successful ✓');
                                      print('====================================================');

                                      Navigator.pop(ctx);
                                      setState(() {
                                        _activePlan = planName;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  'Congratulations! $planName successfully activated.',
                                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: const Color(0xFF1E293B),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 46,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF701A33),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.lock_rounded, size: 14, color: Colors.white),
                                          SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              'Pay with Razorpay',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.3,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(fontSize: 9.5, color: Color(0xFF64748B), height: 1.3),
                              children: [
                                TextSpan(text: 'By clicking Pay, you acknowledge the '),
                                TextSpan(
                                  text: 'Tamil Alliance Terms',
                                  style: TextStyle(
                                    color: Color(0xFF701A33),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' & '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFF701A33),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: '. Recurring billing disabled by default.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Modal Subcomponents
  // ─────────────────────────────────────────────────────────────
  Widget _buildPrivilegeRow({
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(2.5),
            decoration: const BoxDecoration(
              color: Color(0xFFCCFBF1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, size: 11, color: Color(0xFF0F766E)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpiAppTab({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFFBE123C) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? const Color(0xFFBE123C) : const Color(0xFF64748B),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFFBE123C) : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String selectedValue,
    required ValueChanged<String> onChanged,
    Widget? trailingWidget,
  }) {
    final bool isSelected = value == selectedValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? const Color(0xFF701A33) : const Color(0xFFCBD5E1),
              size: 18,
            ),
            const SizedBox(width: 10),
            Icon(icon, color: const Color(0xFF64748B), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                ],
              ),
            ),
            if (trailingWidget != null) trailingWidget,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Trust Banner (Enlarged Height & Size)
          _buildHeroTrustBanner(),
          const SizedBox(height: 16),

          // 2. 3-Button Service Toggle (Self Service, Personal Service, Compare)
          _buildServiceToggle(),
          const SizedBox(height: 18),

          // 3. Dynamic Section based on Selected Button
          if (_selectedServiceType == 0) ...[
            // 3A. Self Service: Select Membership Plan & All Membership Plans
            _buildPlanSectionHeader(),
            const SizedBox(height: 14),

            // Plan 1: Alliance Starter (1 Month)
            _buildPlanCard(
              headerTitle: 'ALLIANCE STARTER • 1 MONTH PLAN',
              headerBg: const Color(0xFF334155),
              planName: 'Alliance Starter',
              planSubtitle: 'Begin your alliance journey with essential access',
              price: '₹1,499',
              validity: '30 Days Full Alliance Validity',
              priceBoxBg: const Color(0xFFF8FAFC),
              buttonText: 'Choose Alliance Starter',
              buttonBg: const Color(0xFF334155),
              features: [
                const _PlanFeature(text: '10 Contacts unlocked directly', isIncluded: true),
                const _PlanFeature(text: '5 Chat invitations per day', isIncluded: true),
                const _PlanFeature(text: 'Unlimited* Horoscope View', isIncluded: true),
                const _PlanFeature(text: 'Unlimited* Star/Rasi Match', isIncluded: true),
                const _PlanFeature(text: 'Profile Booster — Not included', isIncluded: false),
                const _PlanFeature(text: 'Prospects Direct Contact — Not available', isIncluded: false),
              ],
              noticeText: '*Fair usage policy applies to horoscope visibility',
              themeColor: const Color(0xFF334155),
              contacts: '10',
              boost: '1x Profile Visibility Boost',
              badge: 'SELECTED PLAN • STARTER',
            ),
            const SizedBox(height: 18),

            // Plan 2: Alliance Prestige (3 Months) - Most Popular
            _buildPlanCard(
              headerTitle: 'ALLIANCE PRESTIGE • 3 MONTH PLAN',
              headerBg: const Color(0xFF701A33),
              planName: 'Alliance Prestige',
              planSubtitle: 'Ideal for families actively seeking matches within 3 months',
              price: '₹3,599',
              validity: '3 Months Full Alliance Validity',
              priceBoxBg: const Color(0xFFFFF1F2),
              buttonText: 'Choose Alliance Prestige',
              buttonBg: const Color(0xFF701A33),
              features: [
                const _PlanFeature(text: '35 Contacts unlocked directly', isIncluded: true),
                const _PlanFeature(text: 'Unlimited* Chat with matched families', isIncluded: true),
                const _PlanFeature(text: 'Unlimited* Horoscope View & Star/Rasi Match', isIncluded: true),
                const _PlanFeature(text: 'Profile Booster — 1x for 4 weeks', isIncluded: true),
                const _PlanFeature(text: 'Prospects Direct Contact — Not available', isIncluded: false),
              ],
              noticeText: '*Unlimited based on fair usage policy',
              themeColor: const Color(0xFF701A33),
              contacts: '35',
              boost: '2x Profile Visibility Boost',
              badge: 'SELECTED PLAN • MOST POPULAR',
            ),
            const SizedBox(height: 18),

            // Plan 3: Alliance Privilege (6 Months)
            _buildPlanCard(
              headerTitle: 'ALLIANCE PRIVILEGE • 6 MONTH PLAN',
              headerBg: const Color(0xFFB45309),
              planName: 'Alliance Privilege ★',
              planSubtitle: 'Premium Assisted access with direct prospect contact',
              price: '₹7,499',
              validity: '6 Months Full Alliance Validity',
              priceBoxBg: const Color(0xFFFFFBEB),
              buttonText: 'Choose Alliance Privilege',
              buttonBg: const Color(0xFF78350F),
              features: [
                const _PlanFeature(text: '120 Contacts unlocked directly', isIncluded: true),
                const _PlanFeature(text: 'Unlimited* Chat with matched families', isIncluded: true),
                const _PlanFeature(text: 'Unlimited* Horoscope View & Star/Rasi Match', isIncluded: true),
                const _PlanFeature(text: 'Profile Booster — 3 months included', isIncluded: true),
                const _PlanFeature(text: 'Prospects Direct Contact — Enabled ✓', isIncluded: true),
              ],
              noticeText: '*Unlimited based on fair usage policy',
              themeColor: const Color(0xFFB45309),
              contacts: '120',
              boost: '3x Profile Visibility Boost',
              badge: 'SELECTED PLAN • BEST VALUE',
            ),
            const SizedBox(height: 18),

            // Plan 4: ALLIANCE SIGNATURE (Ultimate 1 Year Plan - Luxury Dark Mode)
            _buildSignaturePlanCard(),
            const SizedBox(height: 20),
          ] else if (_selectedServiceType == 1) ...[
            // 3B. Personal Service (VIP Assisted Matchmaking)
            _buildPersonalServiceSection(),
            const SizedBox(height: 20),
          ] else ...[
            // 3C. Compare Plans Matrix
            _buildPlanComparisonSection(),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Hero Trust Banner (Enlarged Height, Spacing & Rich Typography)
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroTrustBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF701A33), Color(0xFF430718)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38701A33),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Star Graphic
          Positioned(
            right: -25,
            bottom: -30,
            child: Icon(
              Icons.stars_rounded,
              size: 160,
              color: Colors.white.withAlpha(16),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A).withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A).withAlpha(80)),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFF5D68B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'ACCELERATE KALYANAM ALLIANCES WITH VERIFIED TRUST',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFDE68A),
                        letterSpacing: 0.6,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Unlock direct verified phone numbers, horoscope unmasked WhatsApp introductions & full 10-Porutham Horoscope dossiers tailored for authentic Tamil families.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFCE7F3),
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),

              // Enhanced Stats Row with higher height & distinct pills
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(22),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withAlpha(35)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_user_rounded, color: Color(0xFFF5D68B), size: 16),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '100% ID Verified Families',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A).withAlpha(35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A).withAlpha(80)),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          '4.8x',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFFDE68A)),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Swift Response',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. 3-Button Service Toggle (Self Service, Personal Service, Compare)
  // ─────────────────────────────────────────────────────────────
  Widget _buildServiceToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          // 1. Self Service Button
          _buildServiceToggleButton(
            index: 0,
            label: 'Self Service',
            icon: Icons.description_outlined,
            activeColor: const Color(0xFF701A33),
          ),
          const SizedBox(width: 4),

          // 2. Personal Service Button
          _buildServiceToggleButton(
            index: 1,
            label: 'Personal Service',
            icon: Icons.support_agent_rounded,
            activeColor: const Color(0xFF059669),
          ),
          const SizedBox(width: 4),

          // 3. Compare Button (Increased Height & Width Prominence)
          _buildServiceToggleButton(
            index: 2,
            label: 'Compare',
            icon: Icons.compare_arrows_rounded,
            activeColor: const Color(0xFF4338CA),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceToggleButton({
    required int index,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final bool isSelected = _selectedServiceType == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedServiceType = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor.withAlpha(60) : Colors.transparent,
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withAlpha(25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? activeColor : const Color(0xFF64748B),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? activeColor : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Section Header: Select Membership Plan + Save 38%
  // ─────────────────────────────────────────────────────────────
  Widget _buildPlanSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Membership Plan',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Text(
                'Save up to 38%',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF15803D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          'All plans backed by 30-day family money-back guarantee',
          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3A. Self Service Overview Section (DIY Matrimony Search)
  // ─────────────────────────────────────────────────────────────
  Widget _buildSelfServiceOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.explore_outlined, color: Color(0xFF701A33), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Self-Service Alliance Discovery',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Direct search, explore 100% verified profiles, and express interest on your own schedule.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),

              _buildSelfServiceFeatureRow(
                icon: Icons.search_rounded,
                title: 'Smart Direct Search & Filters',
                desc: 'Filter verified candidates by Caste, Kulam, Star, Location, Education and Profession.',
              ),
              const SizedBox(height: 12),
              _buildSelfServiceFeatureRow(
                icon: Icons.auto_awesome_rounded,
                title: '10-Porutham Jathagam Compatibility',
                desc: 'Instant computerized Rasi & Nakshatra Porutham with Dosham checks.',
              ),
              const SizedBox(height: 12),
              _buildSelfServiceFeatureRow(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Direct Sacred Family Chat',
                desc: 'Chat directly with prospect parents & candidates with granular privacy controls.',
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => setState(() => _selectedServiceType = 2),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF701A33), Color(0xFF831843)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x28701A33),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.compare_arrows_rounded, color: Color(0xFFFDE68A), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Compare Membership Plans & Pricing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelfServiceFeatureRow({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: const Color(0xFF701A33)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF64748B),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3B. Personal Service Section (VIP Matchmaker Assisted)
  // ─────────────────────────────────────────────────────────────
  Widget _buildPersonalServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.handshake_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dedicated Relationship Manager',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Our senior matrimony advisors shortlists matches, conducts astrology vetting & coordinates family calls.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF047857), height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildPlanCard(
          headerTitle: 'VIP ASSISTED MATCHMAKING • 3 MONTHS',
          headerBg: const Color(0xFF065F46),
          planName: 'Alliance VIP Assisted',
          planSubtitle: 'Dedicated manager talks to families on your behalf',
          price: '₹18,999',
          validity: '3 Months Full Assisted Service',
          priceBoxBg: const Color(0xFFECFDF5),
          buttonText: 'Get Assigned a Manager',
          buttonBg: const Color(0xFF059669),
          features: [
            const _PlanFeature(text: 'Dedicated Senior Relationship Manager', isIncluded: true),
            const _PlanFeature(text: 'Direct Family-to-Family Meeting Setup', isIncluded: true),
            const _PlanFeature(text: 'Expert Vedic Astrologer 1-on-1 Consultation', isIncluded: true),
            const _PlanFeature(text: 'Unlimited Verified Contacts & Jathagam Access', isIncluded: true),
            const _PlanFeature(text: 'Top Slot Weekly Highlight in Tamil Matrimony Gazette', isIncluded: true),
          ],
          noticeText: '*Zero hassle — our team handles candidate screening completely',
          themeColor: const Color(0xFF059669),
          contacts: 'Unlimited',
          boost: 'Dedicated VIP Manager + Weekly Gazette Slot',
          badge: 'ASSISTED • DEDICATED MANAGER',
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3C. Comprehensive Plan Comparison Matrix Section
  // ─────────────────────────────────────────────────────────────
  Widget _buildPlanComparisonSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF312E81),
              borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              children: const [
                Icon(Icons.compare_arrows_rounded, color: Color(0xFFC7D2FE), size: 20),
                SizedBox(width: 8),
                Text(
                  'Membership Feature Comparison',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                _buildComparisonRow('Feature', 'Starter', 'Prestige', 'Privilege', 'Signature', isHeader: true),
                const Divider(height: 16),
                _buildComparisonRow('Price', '₹1,499', '₹3,599', '₹7,499', '₹15,499'),
                _buildComparisonRow('Validity', '1 Mo', '3 Mos', '6 Mos', '1 Year'),
                _buildComparisonRow('Contacts', '10', '35', '120', '250'),
                _buildComparisonRow('Chat', '5/day', 'Unlimited', 'Unlimited', 'Unlimited'),
                _buildComparisonRow('10 Porutham', '✓', '✓', '✓', '✓'),
                _buildComparisonRow('Profile Boost', '—', '1x 4wks', '3 Mos', '12 Mos VIP'),
                _buildComparisonRow('Direct Contact', '—', '—', '✓', '✓'),
                _buildComparisonRow('VIP Manager', '—', '—', '—', '✓'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String f,
    String c1,
    String c2,
    String c3,
    String c4, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              f,
              style: TextStyle(
                fontSize: isHeader ? 11 : 10.5,
                fontWeight: isHeader ? FontWeight.w900 : FontWeight.w700,
                color: isHeader ? const Color(0xFF1E293B) : const Color(0xFF475569),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              c1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isHeader ? FontWeight.w900 : FontWeight.w600,
                color: isHeader ? const Color(0xFF334155) : const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              c2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isHeader ? FontWeight.w900 : FontWeight.w700,
                color: isHeader ? const Color(0xFF701A33) : const Color(0xFF701A33),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              c3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isHeader ? FontWeight.w900 : FontWeight.w700,
                color: isHeader ? const Color(0xFFB45309) : const Color(0xFFB45309),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              c4,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isHeader ? FontWeight.w900 : FontWeight.w900,
                color: isHeader ? const Color(0xFFD97706) : const Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Standard Plan Card Component (Starter, Prestige, Privilege)
  // ─────────────────────────────────────────────────────────────
  Widget _buildPlanCard({
    required String headerTitle,
    required Color headerBg,
    required String planName,
    required String planSubtitle,
    required String price,
    required String validity,
    required Color priceBoxBg,
    required String buttonText,
    required Color buttonBg,
    required List<_PlanFeature> features,
    required String noticeText,
    required Color themeColor,
    required String contacts,
    required String boost,
    required String badge,
  }) {
    void openCheckout() {
      print('====================================================');
      print('👑 [USER ACTION: SELECTED MEMBERSHIP PLAN]');
      print('   Plan Name    : $planName');
      print('   Price        : $price');
      print('   Validity     : $validity');
      print('   Contacts     : $contacts Verified Contacts');
      print('   Booster      : $boost');
      print('====================================================');

      _showCheckoutModal(
        planName: planName,
        price: price,
        validity: validity,
        contacts: contacts,
        themeColor: themeColor,
        badge: badge,
        boost: boost,
      );
    }

    return InkWell(
      onTap: openCheckout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Top Header Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Text(
              headerTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan Name & Subtitle
                Text(
                  planName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  planSubtitle,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),

                // Price Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: priceBoxBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        validity,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Features List
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.5),
                    child: Row(
                      children: [
                        Icon(
                          f.isIncluded ? Icons.check_rounded : Icons.close_rounded,
                          size: 14,
                          color: f.isIncluded ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f.text,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: f.isIncluded ? FontWeight.w600 : FontWeight.w400,
                              color: f.isIncluded ? const Color(0xFF334155) : const Color(0xFF94A3B8),
                              decoration: f.isIncluded ? null : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Notice Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    noticeText,
                    style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 14),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: openCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBg,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // ─────────────────────────────────────────────────────────────
  // 7. ALLIANCE SIGNATURE (Luxury Dark 1-Year Plan)
  // ─────────────────────────────────────────────────────────────
  Widget _buildSignaturePlanCard() {
    void openSignatureCheckout() {
      print('====================================================');
      print('👑 [USER ACTION: SELECTED MEMBERSHIP PLAN]');
      print('   Plan Name    : ALLIANCE SIGNATURE 👑');
      print('   Price        : ₹15,499');
      print('   Validity     : 1 Year Full Alliance Validity');
      print('   Contacts     : 250 Verified Contacts');
      print('   Booster      : Full 12 Months VIP Visibility Boost');
      print('====================================================');

      _showCheckoutModal(
        planName: 'ALLIANCE SIGNATURE 👑',
        price: '₹15,499',
        validity: '1 Year Full Alliance Validity',
        contacts: '250',
        themeColor: const Color(0xFFB45309),
        badge: 'SELECTED PLAN • VIP SIGNATURE',
        boost: 'Full 12 Months VIP Visibility Boost',
      );
    }

    return InkWell(
      onTap: openSignatureCheckout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B1329),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD97706), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF78350F), Color(0xFFB45309)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Text(
              'ALLIANCE SIGNATURE • ULTIMATE 1 YEAR PLAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFEF3C7),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: const [
                    Text(
                      'ALLIANCE SIGNATURE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFDE68A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text('👑', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  'The ultimate 1-year alliance package with complete access and direct assisted contact',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 12),

                // Price Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFD97706).withAlpha(100)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '₹15,499',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      Text(
                        '365 Days Validity',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Features
                _buildDarkFeature('250 Contacts unlocked directly'),
                _buildDarkFeature('Unlimited* Chat with all matched families'),
                _buildDarkFeature('Unlimited* Horoscope View & Star/Rasi Match'),
                _buildDarkFeature('Profile Booster — Full 12 months included'),
                _buildDarkFeature('Prospects Direct Contact — Fully Enabled ✓'),
                const SizedBox(height: 10),

                // Notice Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '*VIP dedicated relationship manager support included',
                    style: TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8), fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 14),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: openSignatureCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45309),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'CHOOSE ALLIANCE SIGNATURE',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDarkFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        children: [
          const Icon(Icons.check_rounded, size: 14, color: Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE2E8F0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanFeature {
  final String text;
  final bool isIncluded;

  const _PlanFeature({
    required this.text,
    required this.isIncluded,
  });
}
