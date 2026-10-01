import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  final bool initialScrollToPhoto;

  const PrivacySettingsScreen({
    super.key,
    this.initialScrollToPhoto = false,
  });

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Mobile Privacy Toggles (Each is completely independent)
  bool _visibleToAccepted = true;
  bool _visibleToPremium = true;
  bool _hideFromEveryone = true;

  // Photo Privacy Toggles (Each is completely independent)
  bool _photoOpenToView = true;
  bool _photoPremiumOnly = true;
  bool _photoRequestToView = true;
  bool _photoBlurUnverified = true;

  // Horoscope Privacy Toggles
  bool _restrictHoroscopeDownload = true;
  bool _horoscopePremiumOnly = false;

  // Masked number reveal toggle
  bool _revealNumber = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialScrollToPhoto) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            380,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSavePreferences() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Privacy preferences updated successfully!',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onResetDefaults() {
    setState(() {
      _visibleToAccepted = true;
      _visibleToPremium = true;
      _hideFromEveryone = true;
      _photoOpenToView = true;
      _photoPremiumOnly = true;
      _photoRequestToView = true;
      _photoBlurUnverified = true;
      _restrictHoroscopeDownload = true;
      _horoscopePremiumOnly = false;
      _revealNumber = false;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings reset to default'),
        backgroundColor: Color(0xFF64748B),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAF6),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF701A33),
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mobile Number Privacy',
          style: TextStyle(
            color: Color(0xFF701A33),
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Section ──
              Row(
                children: const [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: Color(0xFFB45309),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'SECURE PRIVACY CONTROL',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF701A33),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Mobile Number Privacy',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Control who can view your contact details & initiate alliance calls with complete family dignity.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),

              // ── Primary Registered Line Card ──
              _buildPrimaryLineCard(),
              const SizedBox(height: 18),

              // ── Who Can View Your Number Header ──
              Row(
                children: const [
                  Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF701A33)),
                  SizedBox(width: 6),
                  Text(
                    'Who Can View Your Number',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Option 1: Visible to Accepted Matches Only
              _buildMobileOptionCard(
                title: 'Visible to Accepted Matches Only',
                subtitle: 'Only profiles whose alliance interest you have mutually accepted can view your contact digits.',
                isActive: _visibleToAccepted,
                onToggle: () {
                  setState(() => _visibleToAccepted = !_visibleToAccepted);
                },
              ),
              const SizedBox(height: 10),

              // Option 2: Visible to Verified Premium Members
              _buildMobileOptionCard(
                title: 'Visible to Verified Premium Members',
                badge: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF5E6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE5B84B), width: 0.8),
                  ),
                  child: const Text(
                    'Gold & VIP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
                subtitle: 'Any member holding an active Kalyanam Gold tier with verified government photo-ID can unlock your number.',
                isActive: _visibleToPremium,
                onToggle: () {
                  setState(() => _visibleToPremium = !_visibleToPremium);
                },
              ),
              const SizedBox(height: 10),

              // Option 3: Hide from Everyone (Strict Privacy)
              _buildMobileOptionCard(
                title: 'Hide from Everyone (Strict Privacy)',
                subtitle: 'No member can view direct digits. All phone conversations are routed through our Tamil Alliance Masked Cloud Bridge.',
                isActive: _hideFromEveryone,
                onToggle: () {
                  setState(() => _hideFromEveryone = !_hideFromEveryone);
                },
              ),
              const SizedBox(height: 20),

              // ── Photo Privacy Card Box ──
              _buildPhotoPrivacyBox(),
              const SizedBox(height: 16),

              // ── Horoscope Privacy Card Box ──
              _buildHoroscopePrivacyBox(),
              const SizedBox(height: 24),

              // ── Bottom Action Buttons ──
              InkWell(
                onTap: _onSavePreferences,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF701A33),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF701A33).withAlpha(50),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.save_outlined, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Save Privacy Preferences',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Center(
                child: InkWell(
                  onTap: _onResetDefaults,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Reset to Default Settings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Primary Line Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildPrimaryLineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              color: Color(0xFF701A33),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Primary Registered Line',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _revealNumber ? '+91 98401 88912' : '+91 98401 •••••',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => setState(() => _revealNumber = !_revealNumber),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          _revealNumber
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 16,
                          color: const Color(0xFF701A33),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Profile: Dr. Siddharth S. (Self)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Mobile Option Card with Custom Toggle
  // ─────────────────────────────────────────────────────────────
  Widget _buildMobileOptionCard({
    required String title,
    Widget? badge,
    required String subtitle,
    required bool isActive,
    required VoidCallback onToggle,
  }) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? const Color(0xFF701A33).withAlpha(80) : const Color(0xFFEDE9E3),
            width: isActive ? 1.2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(height: 4),
                    badge,
                  ],
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildCustomSwitch(
              value: isActive,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Photo Privacy Box
  // ─────────────────────────────────────────────────────────────
  Widget _buildPhotoPrivacyBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF2F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: Color(0xFF701A33),
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Photo Privacy',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'You have full control over who views your photos',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 1: Open to View
          _buildPhotoRow(
            title: 'Open to View',
            subtitle: 'Allow all active and verified community members to view your full profile photos and bio.',
            value: _photoOpenToView,
            onChanged: (v) {
              setState(() => _photoOpenToView = v);
            },
          ),
          const Divider(height: 22, color: Color(0xFFF1F5F9)),

          // Row 2: Show to Premium Only
          _buildPhotoRow(
            title: 'Show to Premium Only',
            subtitle: 'Restrict full biodata and photo visibility exclusively to verified Premium & Tier-1 Elite members.',
            value: _photoPremiumOnly,
            onChanged: (v) {
              setState(() => _photoPremiumOnly = v);
            },
          ),
          const Divider(height: 22, color: Color(0xFFF1F5F9)),

          // Row 3: Request-to-View mode
          _buildPhotoRow(
            title: 'Request-to-View mode',
            subtitle: 'Members must send an explicit photo request which you or your registered parents must accept before revealing gallery.',
            value: _photoRequestToView,
            onChanged: (v) {
              setState(() => _photoRequestToView = v);
            },
          ),
          const Divider(height: 22, color: Color(0xFFF1F5F9)),

          // Row 4: Blur photos for unverified profiles
          _buildPhotoRow(
            title: 'Blur photos for unverified profiles',
            subtitle: 'Only profiles with verified Government ID (Aadhaar, Passport, or Singpass) can view your unblurred photos.',
            value: _photoBlurUnverified,
            onChanged: (v) {
              setState(() => _photoBlurUnverified = v);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Horoscope Privacy Box
  // ─────────────────────────────────────────────────────────────
  Widget _buildHoroscopePrivacyBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE9E3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDF2F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Color(0xFF701A33),
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Horoscope Privacy',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'You have full control over who views your horoscope',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 1: Restrict Horoscope Download
          _buildPhotoRow(
            title: 'Restrict Horoscope Download',
            subtitle: 'Prevent users from saving or downloading your horoscope as a PDF/image.',
            value: _restrictHoroscopeDownload,
            onChanged: (v) {
              setState(() => _restrictHoroscopeDownload = v);
            },
          ),
          const Divider(height: 22, color: Color(0xFFF1F5F9)),

          // Row 2: Premium Members Only
          _buildPhotoRow(
            title: 'Premium Members Only',
            subtitle: 'Grant full horoscope access exclusively to paid and identity-verified premium members.',
            value: _horoscopePremiumOnly,
            onChanged: (v) {
              setState(() => _horoscopePremiumOnly = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildCustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Custom Switch matching Exact Mockup (Maroon pill vs Soft Grey)
  // ─────────────────────────────────────────────────────────────
  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF701A33) : const Color(0xFFDDE2ED),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 19,
            height: 19,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
