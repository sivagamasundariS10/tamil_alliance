import 'package:flutter/material.dart';
import 'privacy_settings_screen.dart';
import '../profile/download_biodata_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification Toggle States
  bool _pushNotifications = true;
  bool _interestRequests = true;
  bool _chatMessages = true;
  bool _horoscopeAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF701A33),
          elevation: 0,
          leadingWidth: 54,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Center(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF701A33),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'SETTINGS',
                style: TextStyle(
                  color: Color(0xFFF5D68B),
                  fontFamily: 'serif',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Preferences & Account Control',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Profile Card (Dr. Siddharth S)
            _buildUserProfileCard(),
            const SizedBox(height: 14),

            // 2. Membership & Plan Validity Card
            _buildMembershipCard(),
            const SizedBox(height: 18),

            // 3. Notification Preferences
            _buildSectionHeader(Icons.notifications_active_outlined, 'NOTIFICATION PREFERENCES'),
            const SizedBox(height: 8),
            _buildNotificationPreferencesCard(),
            const SizedBox(height: 18),

            // 4. Account & Security
            _buildSectionHeader(Icons.shield_outlined, 'ACCOUNT & SECURITY'),
            const SizedBox(height: 8),
            _buildAccountSecurityCard(),
            const SizedBox(height: 18),

            // 5. Privacy & Safety Controls
            _buildSectionHeader(Icons.shield_outlined, 'PRIVACY & SAFETY CONTROLS'),
            const SizedBox(height: 8),
            _buildPrivacyControlsCard(),
            const SizedBox(height: 18),

            // 6. Jathagam & Horoscope Settings
            _buildSectionHeader(Icons.auto_awesome_rounded, 'JATHAGAM & HOROSCOPE SETTINGS'),
            const SizedBox(height: 8),
            _buildHoroscopeSettingsCard(),
            const SizedBox(height: 18),

            // 7. Support & Feedback
            _buildSectionHeader(Icons.support_agent_rounded, 'SUPPORT & FEEDBACK'),
            const SizedBox(height: 8),
            _buildSupportFeedbackCard(),
            const SizedBox(height: 18),

            // 8. Account Actions
            _buildSectionHeader(Icons.manage_accounts_outlined, 'ACCOUNT ACTIONS'),
            const SizedBox(height: 8),
            _buildAccountActionsCard(),
            const SizedBox(height: 18),

            // 9. Log Out Button
            _buildLogoutButton(),
            const SizedBox(height: 20),

            // 10. App Version & Heritage Footer
            _buildFooterBranding(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. User Profile Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF5D68B), width: 1.5),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/groom_avatar.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 9, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dr. Siddharth S',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Alliance ID -TA889123 • Chennai, TN',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DownloadBiodataScreen(
                    candidateName: 'Dr. Siddharth S',
                    allianceId: 'TA-889123',
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Text(
                'Download bio data',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF701A33),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Membership & Plan Validity Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildMembershipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined, size: 17, color: Color(0xFFD97706)),
              const SizedBox(width: 6),
              const Text(
                'MEMBERSHIP & PLAN VALIDITY',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF475569),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  'Kalyanam Gold',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Valid: 15 Jan 2026 – 15 May 2026',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Auto-renews at preferred community rate',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  '64 Days Remaining',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF701A33),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Navigating to Premium Upgrade Plans...'),
                  backgroundColor: const Color(0xFF701A33),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF701A33),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.star_outline_rounded, size: 16, color: Color(0xFFF5D68B)),
                  SizedBox(width: 6),
                  Text(
                    'Upgrade / Renew Plan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Notification Preferences Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildNotificationPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Push Notifications Primary Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Push Notifications & Alerts',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ON',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Receive instant updates for match requests, family chats, and astrologer-approved muhurtham matches.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.3),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: _pushNotifications,
                    activeThumbColor: const Color(0xFF701A33),
                    activeTrackColor: const Color(0xFF701A33).withAlpha(80),
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                ),
              ],
            ),
          ),

          // Sub Toggle: Interest & Match Requests
          _buildToggleItem(
            icon: Icons.favorite_border_rounded,
            title: 'Interest & Match Requests',
            value: _interestRequests,
            onChanged: (val) => setState(() => _interestRequests = val),
          ),

          // Sub Toggle: Sacred Family Chat Messages
          _buildToggleItem(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Sacred Family Chat Messages',
            value: _chatMessages,
            onChanged: (val) => setState(() => _chatMessages = val),
          ),

          // Sub Toggle: Horoscope Compatibility Alerts
          _buildToggleItem(
            icon: Icons.auto_awesome_outlined,
            title: 'Horoscope Compatibility Alerts',
            value: _horoscopeAlerts,
            onChanged: (val) => setState(() => _horoscopeAlerts = val),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              activeThumbColor: const Color(0xFF10B981),
              activeTrackColor: const Color(0xFF10B981).withAlpha(80),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Account & Security Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildAccountSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSettingsActionTile(
            icon: Icons.phone_android_rounded,
            iconBg: const Color(0xFFFDF2F4),
            iconColor: const Color(0xFFBE185D),
            title: 'Update Mobile Number',
            subtitleWidget: Row(
              children: [
                const Text(
                  '+91 98401 XXXXX',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '✓ Verified',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF15803D)),
                  ),
                ),
              ],
            ),
            onTap: () => _showComingSoon('Update Mobile Number'),
          ),
          _buildSettingsActionTile(
            icon: Icons.email_outlined,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF16A34A),
            title: 'Update Email ID',
            subtitle: 'siddharth.s@*****.com',
            onTap: () => _showComingSoon('Update Email ID'),
          ),
          _buildSettingsActionTile(
            icon: Icons.lock_reset_rounded,
            iconBg: const Color(0xFFF8FAFC),
            iconColor: const Color(0xFF475569),
            title: 'Change Password',
            subtitle: 'Last updated 3 months ago',
            onTap: () => _showComingSoon('Change Password'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Privacy & Safety Controls Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildPrivacyControlsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSettingsActionTile(
            icon: Icons.visibility_off_outlined,
            iconBg: const Color(0xFFF8FAFC),
            iconColor: const Color(0xFF64748B),
            title: 'Mobile Number Privacy',
            subtitle: 'Visible to Accepted Matches Only',
            subtitleColor: const Color(0xFFBE185D),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacySettingsScreen(),
                ),
              );
            },
          ),
          _buildSettingsActionTile(
            icon: Icons.image_not_supported_outlined,
            iconBg: const Color(0xFFF8FAFC),
            iconColor: const Color(0xFF64748B),
            title: 'Photo Privacy',
            subtitle: 'Blur photos for unverified profiles',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacySettingsScreen(initialScrollToPhoto: true),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Jathagam & Horoscope Settings Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildHoroscopeSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSettingsActionTile(
            icon: Icons.explore_outlined,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFF991B1B),
            title: 'Generate Digital Jathagam',
            subtitle: '12-House Chakram Porutham view',
            onTap: () => _showComingSoon('Digital Jathagam Generator'),
          ),
          _buildSettingsActionTile(
            icon: Icons.description_outlined,
            iconBg: const Color(0xFFFFF1F2),
            iconColor: const Color(0xFFE11D48),
            title: 'Upload / Replace Horoscope',
            subtitle: 'Document: jathagam_final.pdf',
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: const Text(
                'Update >',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9E1C3F),
                ),
              ),
            ),
            onTap: () => _showComingSoon('Horoscope Document Upload'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Support & Feedback Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildSupportFeedbackCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildSettingsActionTile(
            icon: Icons.help_outline_rounded,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFF991B1B),
            title: 'Help Center',
            subtitle: 'FAQs, Verification Guides & 24/7 Support',
            trailingWidget: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Toll-\nfree',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600, height: 1.1),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
              ],
            ),
            onTap: () => _showComingSoon('24/7 Help Center'),
          ),
          _buildSettingsActionTile(
            icon: Icons.star_rounded,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFFF59E0B),
            titleWidget: Row(
              children: const [
                Text(
                  'Rate the App',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                SizedBox(width: 2),
                Text(
                  '4.9',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
            title: 'Rate the App',
            subtitle: 'Share your experience on App Store & Play Store',
            trailingWidget: const Icon(Icons.open_in_new_rounded, size: 15, color: Color(0xFF94A3B8)),
            onTap: () => _showComingSoon('Rate on Play Store'),
          ),
          _buildSettingsActionTile(
            icon: Icons.description_outlined,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFF991B1B),
            titleWidget: Row(
              children: const [
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '(விதிமுறைகள்)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            title: 'Terms & Conditions',
            subtitle: 'User agreement, matrimonial code of conduct & privacy terms',
            onTap: () => _showComingSoon('Terms & Conditions'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Account Actions Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildAccountActionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Deactivate
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Center(
                  child: Icon(Icons.pause_circle_outline_rounded, size: 20, color: Color(0xFF475569)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Deactivate Account',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PAUSE',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF991B1B)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Temporarily hide your profile and photo from all search results. You can reactivate anytime by logging back in.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.3),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 18),

          // Delete Account
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: const Center(
                  child: Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFE11D48)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PERMANENT',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF991B1B)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Permanently wipe your biodata, verified Jathagam horoscope, conversation history, and active membership. This action cannot be reversed.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.3),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _showDeleteConfirmDialog,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE11D48),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.warning_amber_rounded, size: 14, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'Proceed to Delete',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Logout Button
  // ─────────────────────────────────────────────────────────────
  Widget _buildLogoutButton() {
    return InkWell(
      onTap: _showLogoutDialog,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFECDD3), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFFBE185D), size: 18),
            SizedBox(width: 8),
            Text(
              'Log Out / வெளியேறு',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFFBE185D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 10. Footer Branding
  // ─────────────────────────────────────────────────────────────
  Widget _buildFooterBranding() {
    return Center(
      child: Column(
        children: const [
          Text(
            'Tamil Alliance v1.4.2',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Recognized in 2026 • 100% Secure Cultural Heritage',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Helper Widgets & Dialogs
  // ─────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF701A33)),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: Color(0xFF701A33),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsActionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    Widget? titleWidget,
    String? subtitle,
    Widget? subtitleWidget,
    Color? subtitleColor,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (titleWidget != null)
                    titleWidget
                  else
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  if (subtitleWidget != null) ...[
                    const SizedBox(height: 3),
                    subtitleWidget,
                  ] else if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor ?? const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailingWidget ?? const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature settings is active and configured.'),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('Confirm Account Deletion', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
          ],
        ),
        content: const Text(
          'Are you sure you want to permanently delete your Tamil Alliance profile? All biodata, matching records, and active membership will be permanently erased.',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion request submitted.')),
              );
            },
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        content: const Text(
          'Are you sure you want to log out from Tamil Alliance?',
          style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF701A33),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
