import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'govt_id_verification_screen.dart';

class PhotosPrivacyScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? profileFor;

  const PhotosPrivacyScreen({
    Key? key,
    this.mobileNumber,
    this.profileFor,
  }) : super(key: key);

  @override
  State<PhotosPrivacyScreen> createState() => _PhotosPrivacyScreenState();
}

class _PhotosPrivacyScreenState extends State<PhotosPrivacyScreen> {
  // Primary photo state
  String _primaryPhotoAsset = 'assets/images/avatar1.jpg';
  double _zoomScale = 1.0;
  int _rotationTurns = 0;

  // Available sample photos in assets
  final List<Map<String, String>> _sampleOptions = [
    {'name': 'Traditional Saree', 'asset': 'assets/images/avatar1.jpg'},
    {'name': 'Family & Kalyanam', 'asset': 'assets/images/wedding_hero.jpg'},
    {'name': 'Full Length Attire', 'asset': 'assets/images/avatar2.jpg'},
    {'name': 'Close-Up Portrait', 'asset': 'assets/images/avatar3.jpg'},
  ];

  // Gallery photos list (Initial slots)
  final List<Map<String, String>> _galleryPhotos = [
    {
      'id': '1',
      'asset': 'assets/images/avatar1.jpg',
      'label': 'Traditional Attire',
      'status': 'Approved',
      'slot': 'Slot 1 of 5',
    },
    {
      'id': '2',
      'asset': 'assets/images/wedding_hero.jpg',
      'label': 'Family / Outdoor',
      'status': 'Approved',
      'slot': 'Slot 2 of 5',
    },
    {
      'id': '3',
      'asset': 'assets/images/avatar2.jpg',
      'label': 'Full Length',
      'status': 'Approved',
      'slot': 'Slot 3 of 5',
    },
  ];

  // ─────────────────────────────────────────────────────────────
  // Photo Upload / Picker Sheet (Camera, Gallery, Sample)
  // ─────────────────────────────────────────────────────────────
  void _showPhotoSourcePicker({required bool isPrimary, String? slotLabel}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isPrimary ? 'Upload Primary Biodata Portrait' : 'Upload ${slotLabel ?? "Gallery Photo"}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'High-resolution photos increase mutual family interest by 8x',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),

              // Option 1: Take Photo with Camera
              _buildPickerOption(
                icon: Icons.camera_alt_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF1D4ED8),
                title: 'Take Photo (Camera)',
                subtitle: 'Open camera to capture new clear portrait',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _handlePhotoSelection(
                    asset: 'assets/images/avatar3.jpg',
                    isPrimary: isPrimary,
                    slotLabel: slotLabel ?? 'Camera Shot',
                  );
                },
              ),
              const SizedBox(height: 10),

              // Option 2: Choose from Device Gallery
              _buildPickerOption(
                icon: Icons.photo_library_rounded,
                iconBg: const Color(0xFFFAF5FF),
                iconColor: const Color(0xFF7E22CE),
                title: 'Choose from Gallery / Photos',
                subtitle: 'Select from existing images on your phone',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showSamplePickerSheet(isPrimary: isPrimary, slotLabel: slotLabel);
                },
              ),
              const SizedBox(height: 10),

              // Option 3: Choose from Matrimony Samples
              _buildPickerOption(
                icon: Icons.auto_awesome_rounded,
                iconBg: const Color(0xFFFFF1F2),
                iconColor: const Color(0xFFBE123C),
                title: 'Choose Sample Attire / Pose',
                subtitle: 'Select recommended high quality samples',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showSamplePickerSheet(isPrimary: isPrimary, slotLabel: slotLabel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Sample Photo Selector Sheet
  // ─────────────────────────────────────────────────────────────
  void _showSamplePickerSheet({required bool isPrimary, String? slotLabel}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sampleOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = _sampleOptions[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _handlePhotoSelection(
                          asset: item['asset']!,
                          isPrimary: isPrimary,
                          slotLabel: slotLabel ?? item['name']!,
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              item['asset']!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['name']!,
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePhotoSelection({
    required String asset,
    required bool isPrimary,
    required String slotLabel,
  }) {
    if (isPrimary) {
      setState(() {
        _primaryPhotoAsset = asset;
      });
      debugPrint('[STEP 4: PHOTOS] Primary photo updated to: $asset');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primary Biodata Portrait updated!'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(milliseconds: 1200),
        ),
      );
    } else {
      if (_galleryPhotos.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum 5 gallery photos already reached'),
            backgroundColor: Color(0xFFE11D48),
          ),
        );
        return;
      }
      setState(() {
        final nextSlot = _galleryPhotos.length + 1;
        _galleryPhotos.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'asset': asset,
          'label': slotLabel,
          'status': 'Approved',
          'slot': 'Slot $nextSlot of 5',
        });
      });
      debugPrint('[STEP 4: PHOTOS] Added gallery photo: "$slotLabel". Total: ${_galleryPhotos.length}/5');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "$slotLabel" to gallery (Slot ${_galleryPhotos.length}/5)'),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(milliseconds: 1200),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Adjust / Crop Modal (Golden Ratio Focus Adjuster)
  // ─────────────────────────────────────────────────────────────
  void _onAdjustPrimary() {
    double tempScale = _zoomScale;
    int tempRotationTurns = _rotationTurns;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.center_focus_strong, color: Color(0xFF881337), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Adjust Golden Ratio Framing',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.of(ctx).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Align face inside the rose-gold circular frame',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(height: 14),

                // Interactive Framing Box
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 230,
                    height: 230,
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        RotatedBox(
                          quarterTurns: tempRotationTurns,
                          child: Transform.scale(
                            scale: tempScale,
                            child: Image.asset(
                              _primaryPhotoAsset,
                              width: 230,
                              height: 230,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Dark mask outside aperture
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.35),
                              ),
                            ),
                          ),
                        ),
                        // Circular Spotlight focus ring
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFDA4AF), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Center crosshair
                        const Icon(Icons.add, size: 20, color: Color(0xFFFDA4AF)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Zoom Controls Slider
                Row(
                  children: [
                    const Icon(Icons.zoom_out, size: 18, color: Color(0xFF64748B)),
                    Expanded(
                      child: Slider(
                        value: tempScale,
                        min: 1.0,
                        max: 2.5,
                        activeColor: const Color(0xFF881337),
                        inactiveColor: const Color(0xFFE2E8F0),
                        onChanged: (val) {
                          setDialogState(() {
                            tempScale = val;
                          });
                        },
                      ),
                    ),
                    const Icon(Icons.zoom_in, size: 18, color: Color(0xFF881337)),
                  ],
                ),

                // Rotate Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          tempRotationTurns = (tempRotationTurns - 1) % 4;
                        });
                      },
                      icon: const Icon(Icons.rotate_left_rounded, size: 15),
                      label: const Text('Rotate Left', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF475569),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          tempRotationTurns = (tempRotationTurns + 1) % 4;
                        });
                      },
                      icon: const Icon(Icons.rotate_right_rounded, size: 15),
                      label: const Text('Rotate Right', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF475569),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF881337),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() {
                            _zoomScale = tempScale;
                            _rotationTurns = tempRotationTurns;
                          });
                          Navigator.of(ctx).pop();
                          debugPrint('[STEP 4: PHOTOS] Framing adjusted. Zoom: $_zoomScale, Rotation: $_rotationTurns');
                        },
                        child: const Text('Apply Focus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Fullscreen Watermarked Preview Modal
  // ─────────────────────────────────────────────────────────────
  void _onPreviewPrimary() {
    debugPrint('[STEP 4: PHOTOS] Previewing high-resolution watermarked portrait');
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                _primaryPhotoAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 300,
                  height: 400,
                  color: const Color(0xFF701A33),
                  child: const Center(
                    child: Icon(Icons.person, size: 80, color: Colors.white70),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFCC00).withOpacity(0.5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, color: Color(0xFFFFCC00), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'TAMIL ALLIANCE • CONFIDENTIAL WATERMARK',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoPreviewModal(String asset, String title) {
    debugPrint('[STEP 4: PHOTOS] Previewing photo: "$title" ($asset)');
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                asset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 300,
                  height: 400,
                  color: const Color(0xFF701A33),
                  child: Center(
                    child: Text(title, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFCC00).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, color: Color(0xFFFFCC00), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '$title • TAMIL ALLIANCE',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRemoveGalleryPhoto(int index) {
    final removed = _galleryPhotos[index]['label'];
    setState(() {
      _galleryPhotos.removeAt(index);
      for (int i = 0; i < _galleryPhotos.length; i++) {
        _galleryPhotos[i]['slot'] = 'Slot ${i + 1} of 5';
      }
    });
    debugPrint('[STEP 4: PHOTOS] Removed gallery photo "$removed". Remaining: ${_galleryPhotos.length}/5');
  }

  void _onSaveDraft() {
    debugPrint('====================================================');
    debugPrint('[STEP 4 DRAFT SAVED: PHOTOS & PRIVACY]');
    debugPrint('  Primary Photo   : $_primaryPhotoAsset');
    debugPrint('  Gallery Photos  : ${_galleryPhotos.map((e) => e['label']).toList()}');
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo draft saved successfully'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _onContinueToGovtId() {
    debugPrint('====================================================');
    debugPrint('[STEP 4: PHOTOS & PRIVACY SUBMITTED]');
    debugPrint('  Primary Photo   : $_primaryPhotoAsset');
    debugPrint('  Gallery Count   : ${_galleryPhotos.length}');
    for (int i = 0; i < _galleryPhotos.length; i++) {
      debugPrint('    Photo ${i + 1}   : ${_galleryPhotos[i]['label']} (${_galleryPhotos[i]['status']})');
    }
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Photos submitted successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

    // Navigates to Step 5: Govt ID Verification
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GovtIdVerificationScreen(
          mobileNumber: widget.mobileNumber,
          profileFor: widget.profileFor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubHeader(),
                    const SizedBox(height: 12),
                    _buildTitleAndDescription(),
                    const SizedBox(height: 18),
                    _buildPrimaryPortraitCard(),
                    const SizedBox(height: 20),
                    _buildAdditionalGallerySection(),
                    const SizedBox(height: 16),
                    _buildMatchmakerTip(),
                    const SizedBox(height: 16),
                    _buildAdminSafetyCard(),
                    const SizedBox(height: 16),
                    _buildSecurityBadges(),
                    const SizedBox(height: 20),
                    _buildContinueButton(),
                    const SizedBox(height: 12),
                    _buildBottomNavigationLinks(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top AppBar
  // ─────────────────────────────────────────────────────────────
  // 1. Top Custom App Bar
  Widget _buildAppBar() {
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
                  'STEP 4 OF 6',
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

  // ─────────────────────────────────────────────────────────────
  // 2. Sub-Header Tracker
  // ─────────────────────────────────────────────────────────────
  Widget _buildSubHeader() {
    return const Row(
      children: [
        Icon(Icons.circle, size: 6, color: Color(0xFF701A33)),
        SizedBox(width: 6),
        Text(
          'STEP 4 OF 6 • PHOTOS & PRIVACY',
          style: TextStyle(
            color: Color(0xFF701A33),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Title & Description
  // ─────────────────────────────────────────────────────────────
  Widget _buildTitleAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Photos & Moderation',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF475569),
              height: 1.45,
            ),
            children: [
              TextSpan(text: 'Clear, dignified photos receive '),
              TextSpan(
                text: '8x more mutual family interests',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextSpan(
                text: '. All uploads are cryptographically watermarked to prevent unauthorized redistribution.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Primary Biodata Portrait Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildPrimaryPortraitCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF701A33).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.account_box_outlined,
                  size: 18,
                  color: Color(0xFF701A33),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Primary Biodata Portrait',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'MANDATORY',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF991B1B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Portrait Image with Golden Ratio Focus Frame & Watermark
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: GestureDetector(
              onTap: () => _showPhotoSourcePicker(isPrimary: true),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 310,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Darkened Base Image (Exterior of spotlight)
                      Positioned.fill(
                        child: Transform.scale(
                          scale: _zoomScale,
                          child: RotatedBox(
                            quarterTurns: _rotationTurns,
                            child: Image.asset(
                              _primaryPhotoAsset,
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.42),
                              colorBlendMode: BlendMode.darken,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF334155),
                                child: const Center(
                                  child: Icon(Icons.person, size: 70, color: Colors.white70),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 2. Bright Central Circular Aperture (Golden Ratio Spotlight)
                      ClipOval(
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Transform.scale(
                            scale: _zoomScale,
                            child: RotatedBox(
                              quarterTurns: _rotationTurns,
                              child: Image.asset(
                                _primaryPhotoAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF701A33),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 3. Golden Ratio Concentric Guidelines & Rosy Ring
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFDA4AF).withOpacity(0.9),
                            width: 1.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF881337).withOpacity(0.25),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),

                      // Outer concentric decorative golden ring
                      Container(
                        width: 275,
                        height: 275,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFDE68A).withOpacity(0.22),
                            width: 1.0,
                          ),
                        ),
                      ),

                      // Central subtle focus crosshair (+)
                      IgnorePointer(
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: const Color(0xFFFDA4AF).withOpacity(0.7),
                        ),
                      ),

                      // 4. Cryptographic Watermark Overlay (Repeated diagonal strings)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Transform.rotate(
                            angle: -0.42,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'TA-98402-K • TAMIL ALLIANCE • TA-98402-K',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.2,
                                    color: Colors.white.withOpacity(0.32),
                                  ),
                                ),
                                Text(
                                  'TAMIL ALLIANCE • DO NOT DISTRIBUTE • CONFIDENTIAL',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.5,
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                                Text(
                                  'TA-98402-K • CONFIDENTIAL • TAMIL ALLIANCE',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.2,
                                    color: Colors.white.withOpacity(0.32),
                                  ),
                                ),
                                Text(
                                  'TAMIL ALLIANCE • TA-98402-K • PROTECTED',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                    color: Colors.white.withOpacity(0.28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 5. Top Badge: Golden Ratio Focus
                      Positioned(
                        top: 26,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF881337),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.center_focus_strong, size: 11, color: Color(0xFFFFCC00)),
                              SizedBox(width: 5),
                              Text(
                                'GOLDEN RATIO FOCUS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 6. Bottom Right Badge: Live Watermark
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF881337),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.branding_watermark_rounded, size: 12, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'LIVE WATERMARK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Metadata strip under photo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF92400E)),
                    SizedBox(width: 5),
                    Text(
                      'High Resolution (3000 x 3000 px)',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: const Text(
                    'Ready for Kalyanam Bio',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons: Replace, Adjust, Preview
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.photo_camera_outlined,
                    label: 'Replace',
                    onTap: () => _showPhotoSourcePicker(isPrimary: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.crop_rotate_rounded,
                    label: 'Adjust',
                    onTap: _onAdjustPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.fullscreen_rounded,
                    label: 'Preview',
                    onTap: _onPreviewPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFEFF6FF),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: const Color(0xFF1D4ED8)),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Additional Gallery Photos Section
  // ─────────────────────────────────────────────────────────────
  Widget _buildAdditionalGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Gallery Photos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Upload 2 to 5 photos for parent & family review',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  // Interactive reverse / reorder demonstration
                  _galleryPhotos.insert(0, _galleryPhotos.removeLast());
                  for (int i = 0; i < _galleryPhotos.length; i++) {
                    _galleryPhotos[i]['slot'] = 'Slot ${i + 1} of 5';
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gallery photos reordered!'),
                    backgroundColor: Color(0xFF701A33),
                    duration: Duration(milliseconds: 1000),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FE),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.drag_indicator_rounded, size: 12, color: Color(0xFF6D28D9)),
                    SizedBox(width: 3),
                    Text(
                      'DRAG TO REORDER',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6D28D9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3-Column Grid for Uploaded / Placeholder Slots
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 16) / 3;
            return Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                // Render uploaded gallery photos
                for (int i = 0; i < _galleryPhotos.length; i++)
                  _buildUploadedPhotoTile(i, itemWidth),

                // Render Slot placeholder (Selfie Pose)
                if (_galleryPhotos.length < 4)
                  _buildEmptySlotTile(
                    width: itemWidth,
                    icon: Icons.camera_alt_outlined,
                    iconBg: const Color(0xFFFCE7F3),
                    iconColor: const Color(0xFFDB2777),
                    title: 'Selfie Pose',
                    subtitle: 'Casual / Hobby',
                    onTap: () => _showPhotoSourcePicker(isPrimary: false, slotLabel: 'Selfie Pose'),
                  ),

                // Render Slot placeholder (Family Gathering)
                if (_galleryPhotos.length < 5)
                  _buildEmptySlotTile(
                    width: itemWidth,
                    icon: Icons.groups_outlined,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                    title: 'Family Gathering',
                    subtitle: 'Optional slot',
                    onTap: () => _showPhotoSourcePicker(isPrimary: false, slotLabel: 'Family Gathering'),
                  ),

                // Max Photos Notice Tile
                _buildInfoSlotTile(itemWidth),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildUploadedPhotoTile(int index, double width) {
    final item = _galleryPhotos[index];
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (ctx) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['label'] ?? 'Gallery Photo',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.fullscreen_rounded, color: Color(0xFF1D4ED8)),
                          title: const Text('Preview Fullscreen'),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _showPhotoPreviewModal(item['asset']!, item['label']!);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_camera_outlined, color: Color(0xFF701A33)),
                          title: const Text('Replace Photo'),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _showSamplePickerSheet(isPrimary: false, slotLabel: item['label']);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                          title: const Text('Remove Photo', style: TextStyle(color: Color(0xFFE11D48))),
                          onTap: () {
                            Navigator.of(ctx).pop();
                            _onRemoveGalleryPhoto(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(item['asset']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay at bottom for label
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.transparent,
                            Colors.black.withOpacity(0.75),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Drag handle icon top left
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.drag_indicator,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Close button top right
                  Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () => _onRemoveGalleryPhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Label on bottom
                  Positioned(
                    bottom: 6,
                    left: 6,
                    right: 6,
                    child: Text(
                      item['label']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['slot']!,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                item['status']!,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlotTile({
    required double width,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 125,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSlotTile(double width) {
    return Container(
      width: width,
      height: 125,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 22, color: Color(0xFF94A3B8)),
          SizedBox(height: 6),
          Text(
            'Max 5 Photos for\nfocused matches',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.5,
              color: Color(0xFF64748B),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Matchmaker Tip Container
  // ─────────────────────────────────────────────────────────────
  Widget _buildMatchmakerTip() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF1E3A8A),
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Matchmaker Tip: ',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text:
                        'Profiles with at least 1 traditional attire photo and 1 family gathering photo receive ',
                  ),
                  TextSpan(
                    text: 'parent endorsements 3x quicker.',
                    style: TextStyle(fontWeight: FontWeight.w800),
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
  // 7. Admin Quality & Safety Review Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildAdminSafetyCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF78350F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Admin Quality & Safety Review',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '12 HOURS SLA',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Our dedicated moderation team reviews every image to safeguard community dignity. Blurry photos, sunglasses, group shots without the bride/groom, or non-authentic pictures will be flagged. You can freely continue profile setup while review takes place in the background.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF78350F),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 8. Security Badges Footer
  // ─────────────────────────────────────────────────────────────
  Widget _buildSecurityBadges() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, size: 13, color: Color(0xFF0284C7)),
              SizedBox(width: 4),
              Text(
                'ID Authenticated',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.camera_alt_outlined, size: 13, color: Color(0xFFDB2777)),
              SizedBox(width: 4),
              Text(
                'EXIF Scrubbed',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.lock_outline, size: 13, color: Color(0xFFB45309)),
              SizedBox(width: 4),
              Text(
                'Encrypted Vault',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 9. Continue CTA Button
  // ─────────────────────────────────────────────────────────────
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _onContinueToGovtId,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF881337),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Govt ID',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 10. Bottom Navigation Secondary Links
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomNavigationLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              children: [
                Icon(Icons.arrow_back, size: 13, color: Color(0xFF475569)),
                SizedBox(width: 4),
                Text(
                  'Back to Step 4: Family Heritage',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: _onSaveDraft,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Row(
              children: [
                Icon(Icons.bookmark_outline, size: 13, color: Color(0xFF1D4ED8)),
                SizedBox(width: 4),
                Text(
                  'Save Draft & Exit',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
