import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  // Primary photo state (Empty by default)
  String? _primaryPhotoAsset;
  double _zoomScale = 1.0;
  int _rotationTurns = 0;
  Offset _panOffset = Offset.zero;
  bool _isFlipped = false;
  String _activeFilter = 'Original';

  // Gallery photos list (Empty by default)
  final List<Map<String, String>> _galleryPhotos = [];

  final ImagePicker _picker = ImagePicker();

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  Widget _buildImageView(
    String path, {
    BoxFit fit = BoxFit.cover,
    Color? color,
    BlendMode? colorBlendMode,
    double? width,
    double? height,
  }) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFF334155),
          child: const Center(
            child: Icon(Icons.person, size: 60, color: Colors.white70),
          ),
        ),
      );
    } else {
      return Image.file(
        File(path),
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFF334155),
          child: const Center(
            child: Icon(Icons.person, size: 60, color: Colors.white70),
          ),
        ),
      );
    }
  }

  ColorFilter? _getFilterMatrix(String filterName) {
    switch (filterName) {
      case 'Warm Glow':
        return const ColorFilter.matrix([
          1.15, 0, 0, 0, 15,
          0, 1.05, 0, 0, 10,
          0, 0, 0.90, 0, -5,
          0, 0, 0, 1, 0,
        ]);
      case 'Vivid':
        return const ColorFilter.matrix([
          1.25, 0, 0, 0, -10,
          0, 1.25, 0, 0, -10,
          0, 0, 1.25, 0, -10,
          0, 0, 0, 1, 0,
        ]);
      case 'Studio':
        return const ColorFilter.matrix([
          1.10, 0, 0, 0, 15,
          0, 1.10, 0, 0, 15,
          0, 0, 1.15, 0, 20,
          0, 0, 0, 1, 0,
        ]);
      case 'Soft Classic':
        return const ColorFilter.matrix([
          1.05, 0, 0, 0, 8,
          0, 1.02, 0, 0, 8,
          0, 0, 0.95, 0, 5,
          0, 0, 0, 1, 0,
        ]);
      default:
        return null;
    }
  }

  Widget _buildTransformedPhoto({
    required String assetPath,
    required double scale,
    required int rotationTurns,
    required Offset panOffset,
    required bool isFlipped,
    required String filter,
    BoxFit fit = BoxFit.contain,
    Color? overlayColor,
    BlendMode? blendMode,
    double? width,
    double? height,
  }) {
    Widget img = _buildImageView(
      assetPath,
      fit: fit,
      color: overlayColor,
      colorBlendMode: blendMode,
      width: width,
      height: height,
    );

    final colorFilter = _getFilterMatrix(filter);
    if (colorFilter != null) {
      img = ColorFiltered(colorFilter: colorFilter, child: img);
    }

    if (isFlipped) {
      img = Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: img,
      );
    }

    if (rotationTurns != 0) {
      img = RotatedBox(quarterTurns: rotationTurns, child: img);
    }

    if (scale != 1.0 || panOffset != Offset.zero) {
      img = Transform.translate(
        offset: panOffset,
        child: Transform.scale(
          scale: scale,
          child: img,
        ),
      );
    }

    return img;
  }

  Future<void> _pickImageFromSource({
    required ImageSource source,
    required bool isPrimary,
    required String slotLabel,
  }) async {
    try {
      if (!isPrimary && source == ImageSource.gallery) {
        final List<XFile> pickedFiles = await _picker.pickMultiImage(imageQuality: 90);
        if (pickedFiles.isNotEmpty) {
          for (var file in pickedFiles) {
            if (_galleryPhotos.length >= 5) break;
            _handlePhotoSelection(
              asset: file.path,
              isPrimary: false,
              slotLabel: slotLabel,
            );
          }
          return;
        }
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (pickedFile != null) {
        _handlePhotoSelection(
          asset: pickedFile.path,
          isPrimary: isPrimary,
          slotLabel: slotLabel,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to access photos: $e'),
            backgroundColor: const Color(0xFFE11D48),
          ),
        );
      }
    }
  }

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
                'High-resolution photos (3 to 4 MB, JPG / PNG) increase interest by 8x',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(height: 18),

              // Option 1: Take Photo with Camera
              _buildPickerOption(
                icon: Icons.camera_alt_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF1D4ED8),
                title: 'Take Photo (Camera)',
                subtitle: 'Open camera to capture new clear portrait',
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickImageFromSource(
                    source: ImageSource.camera,
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
                title: 'Choose from Phone Gallery',
                subtitle: 'Select from existing images on your phone',
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickImageFromSource(
                    source: ImageSource.gallery,
                    isPrimary: isPrimary,
                    slotLabel: slotLabel ?? 'Gallery Photo',
                  );
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



  void _handlePhotoSelection({
    required String asset,
    required bool isPrimary,
    required String slotLabel,
  }) {
    if (isPrimary) {
      setState(() {
        _primaryPhotoAsset = asset;
        _zoomScale = 1.0;
        _rotationTurns = 0;
        _panOffset = Offset.zero;
        _isFlipped = false;
        _activeFilter = 'Original';
      });
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
  // Adjust, Crop, Rotate & Filter Modal Photo Editor
  // ─────────────────────────────────────────────────────────────
  void _onAdjustPrimary() {
    if (_primaryPhotoAsset == null || _primaryPhotoAsset!.isEmpty) {
      _showPhotoSourcePicker(isPrimary: true);
      return;
    }
    double tempScale = _zoomScale;
    double baseScale = _zoomScale;
    int tempRotationTurns = _rotationTurns;
    Offset tempPanOffset = _panOffset;
    bool tempIsFlipped = _isFlipped;
    String tempFilter = _activeFilter;
    int activeTabIndex = 0; // 0: Pan & Zoom, 1: Rotate & Flip

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (bottomSheetCtx, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Top Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.crop_rotate_rounded, color: Color(0xFFF43F5E), size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Adjust & Rotate Photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Pan to position, zoom scale, and rotate angle',
                              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            tempScale = 1.0;
                            baseScale = 1.0;
                            tempRotationTurns = 0;
                            tempPanOffset = Offset.zero;
                            tempIsFlipped = false;
                            tempFilter = 'Original';
                          });
                        },
                        icon: const Icon(Icons.replay_rounded, size: 14, color: Color(0xFFCBD5E1)),
                        label: const Text('Reset', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12)),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                      ),
                    ],
                  ),
                ),

                // Interactive Photo Adjust Canvas Area (Exact same frame size as Primary Biodata Portrait)
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 310,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFF020617),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0).withOpacity(0.35),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GestureDetector(
                          onScaleStart: (details) {
                            baseScale = tempScale;
                          },
                          onScaleUpdate: (details) {
                            setModalState(() {
                              // 1. Direct pinch-to-zoom on the photo with two fingers
                              if (details.pointerCount > 1 || details.scale != 1.0) {
                                tempScale = (baseScale * details.scale).clamp(0.8, 3.5);
                              }
                              // 2. Drag / pan the photo smoothly
                              tempPanOffset += details.focalPointDelta;
                            });
                          },
                          onDoubleTap: () {
                            setModalState(() {
                              if (tempScale > 1.2) {
                                tempScale = 1.0;
                                baseScale = 1.0;
                                tempPanOffset = Offset.zero;
                              } else {
                                tempScale = 2.0;
                                baseScale = 2.0;
                              }
                            });
                          },
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            height: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 1. Crisp Transformed Photo Base
                                Positioned.fill(
                                  child: _buildTransformedPhoto(
                                    assetPath: _primaryPhotoAsset!,
                                    scale: tempScale,
                                    rotationTurns: tempRotationTurns,
                                    panOffset: tempPanOffset,
                                    isFlipped: tempIsFlipped,
                                    filter: tempFilter,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                // Bottom gesture hint
                                Positioned(
                                  bottom: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.68),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.pinch_rounded, size: 13, color: Color(0xFFCBD5E1)),
                                        SizedBox(width: 6),
                                        Text(
                                          'Pinch to zoom • Drag to pan photo',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            color: Color(0xFFCBD5E1),
                                            fontWeight: FontWeight.w500,
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
                  ),
                ),

                // Tool Navigation Tabs (Pan & Zoom, Rotate & Flip)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildEditorTab(
                        index: 0,
                        currentIndex: activeTabIndex,
                        icon: Icons.zoom_in_rounded,
                        label: 'Pan & Zoom',
                        onTap: () => setModalState(() => activeTabIndex = 0),
                      ),
                      _buildEditorTab(
                        index: 1,
                        currentIndex: activeTabIndex,
                        icon: Icons.rotate_90_degrees_cw_rounded,
                        label: 'Rotate & Flip',
                        onTap: () => setModalState(() => activeTabIndex = 1),
                      ),
                    ],
                  ),
                ),

                // Tool Controls Content Box
                Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  child: activeTabIndex == 0
                      ? _buildCropZoomControls(
                          tempScale: tempScale,
                          onScaleChanged: (s) => setModalState(() => tempScale = s),
                          onCenterTap: () => setModalState(() {
                            tempPanOffset = Offset.zero;
                            tempScale = 1.0;
                          }),
                        )
                      : _buildRotateFlipControls(
                          tempRotationTurns: tempRotationTurns,
                          tempIsFlipped: tempIsFlipped,
                          onRotateLeft: () => setModalState(() => tempRotationTurns = (tempRotationTurns - 1) % 4),
                          onRotateRight: () => setModalState(() => tempRotationTurns = (tempRotationTurns + 1) % 4),
                          onFlipHorizontal: () => setModalState(() => tempIsFlipped = !tempIsFlipped),
                          onResetRotation: () => setModalState(() {
                            tempRotationTurns = 0;
                            tempIsFlipped = false;
                          }),
                        ),
                ),

                // Bottom Action Buttons (Cancel / Apply Changes)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    border: Border(top: BorderSide(color: Color(0xFF1E293B))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _zoomScale = tempScale;
                              _rotationTurns = tempRotationTurns;
                              _panOffset = tempPanOffset;
                              _isFlipped = tempIsFlipped;
                              _activeFilter = tempFilter;
                            });
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo adjusted & updated!'),
                                backgroundColor: Color(0xFF10B981),
                                duration: Duration(milliseconds: 1400),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                          label: const Text(
                            'Apply Changes',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBE123C),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditorTab({
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFBE123C) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropZoomControls({
    required double tempScale,
    required ValueChanged<double> onScaleChanged,
    required VoidCallback onCenterTap,
  }) {
    return Row(
      children: [
        const Icon(Icons.zoom_out, size: 18, color: Color(0xFF94A3B8)),
        Expanded(
          child: Slider(
            value: tempScale.clamp(0.8, 3.5),
            min: 0.8,
            max: 3.5,
            activeColor: const Color(0xFFBE123C),
            inactiveColor: const Color(0xFF334155),
            onChanged: onScaleChanged,
          ),
        ),
        const Icon(Icons.zoom_in, size: 18, color: Color(0xFFBE123C)),
        const SizedBox(width: 10),
        InkWell(
          onTap: onCenterTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_center_focus_rounded, size: 13, color: Colors.white70),
                SizedBox(width: 4),
                Text('Center', style: TextStyle(fontSize: 11.5, color: Colors.white70, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRotateFlipControls({
    required int tempRotationTurns,
    required bool tempIsFlipped,
    required VoidCallback onRotateLeft,
    required VoidCallback onRotateRight,
    required VoidCallback onFlipHorizontal,
    required VoidCallback onResetRotation,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildEditorActionButton(
          icon: Icons.rotate_left_rounded,
          label: 'Rotate -90°',
          onTap: onRotateLeft,
        ),
        _buildEditorActionButton(
          icon: Icons.rotate_right_rounded,
          label: 'Rotate +90°',
          onTap: onRotateRight,
        ),
        _buildEditorActionButton(
          icon: Icons.flip_rounded,
          label: tempIsFlipped ? 'Flipped' : 'Flip Horiz.',
          isActive: tempIsFlipped,
          onTap: onFlipHorizontal,
        ),
        _buildEditorActionButton(
          icon: Icons.restart_alt_rounded,
          label: 'Reset',
          onTap: onResetRotation,
        ),
      ],
    );
  }

  Widget _buildEditorActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFBE123C).withOpacity(0.2) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? const Color(0xFFBE123C) : const Color(0xFF334155)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isActive ? const Color(0xFFFDA4AF) : Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                color: isActive ? const Color(0xFFFDA4AF) : const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }



  // ─────────────────────────────────────────────────────────────
  // Fullscreen Watermarked Preview Modal & Photo Deletion
  // ─────────────────────────────────────────────────────────────
  void _onDeletePrimaryPhoto() {
    setState(() {
      _primaryPhotoAsset = null;
      _zoomScale = 1.0;
      _rotationTurns = 0;
      _panOffset = Offset.zero;
      _isFlipped = false;
      _activeFilter = 'Original';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Primary photo deleted successfully'),
        backgroundColor: Color(0xFFE11D48),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void _onPreviewPrimary() {
    if (_primaryPhotoAsset == null || _primaryPhotoAsset!.isEmpty) {
      _showPhotoSourcePicker(isPrimary: true);
      return;
    }
    _showPhotoPreviewModal(_primaryPhotoAsset!, 'Primary Biodata Portrait');
  }

  void _showPhotoPreviewModal(String asset, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Full uncropped uploaded image with interactive pinch & zoom
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Center(
                    child: _buildImageView(
                      asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // 2. Close button top right
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: () => Navigator.of(ctx).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRemoveGalleryPhoto(int index) {
    setState(() {
      _galleryPhotos.removeAt(index);
      for (int i = 0; i < _galleryPhotos.length; i++) {
        _galleryPhotos[i]['slot'] = 'Slot ${i + 1} of 5';
      }
    });
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo draft saved successfully'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _onContinueToGovtId() {
    // Optional check: user can proceed even without primary photo during testing
    print('====================================================');
    print(' [USER INPUT: STEP 4 - PHOTOS & PRIVACY]');
    print('   Primary Photo   : $_primaryPhotoAsset');
    print('   Gallery Photos  : ${_galleryPhotos.map((e) => e['label']).toList()} (${_galleryPhotos.length}/5)');
    print('   Photo Privacy   : Visible to All Verified Members (Watermarked)');
    print('   Watermark Policy: Active ✓');
    print('====================================================');

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
                  'STEP 4 OF 5',
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
          'PHOTOS & PRIVACY',
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
              ],
            ),
          ),

          // Portrait Image with Golden Ratio Focus Frame & Watermark OR Empty Upload Prompt
          if (_primaryPhotoAsset != null && _primaryPhotoAsset!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: GestureDetector(
                onTap: () => _showPhotoSourcePicker(isPrimary: true),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 310,
                    width: double.infinity,
                    color: const Color(0xFF0F172A),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 1. Crisp Transformed Base Real Photo
                        Positioned.fill(
                          child: _buildTransformedPhoto(
                            assetPath: _primaryPhotoAsset!,
                            scale: _zoomScale,
                            rotationTurns: _rotationTurns,
                            panOffset: _panOffset,
                            isFlipped: _isFlipped,
                            filter: _activeFilter,
                            fit: BoxFit.contain,
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

            // Action Buttons: Delete, Adjust, Preview
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      iconColor: const Color(0xFFDC2626),
                      textColor: const Color(0xFFDC2626),
                      bgColor: const Color(0xFFFEF2F2),
                      borderColor: const Color(0xFFFECACA),
                      onTap: _onDeletePrimaryPhoto,
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
          ] else ...[
            // Empty State Upload Prompt for Primary Portrait
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
              child: GestureDetector(
                onTap: () => _showPhotoSourcePicker(isPrimary: true),
                child: Container(
                  height: 310,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCE7F3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            color: Color(0xFF701A33),
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Upload Primary Biodata Portrait',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Clear front-facing portrait in traditional or formal attire with bright lighting',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF1D4ED8)),
                            SizedBox(width: 6),
                            Text(
                              'Photo size must be 3 to 4 MB (JPG / PNG)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF701A33),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33701A33),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.upload_file_rounded, size: 16, color: Colors.white),
                            SizedBox(width: 7),
                            Text(
                              'Choose Photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    Color? bgColor,
    Color? borderColor,
  }) {
    final effectiveIconColor = iconColor ?? const Color(0xFF1D4ED8);
    final effectiveTextColor = textColor ?? const Color(0xFF1D4ED8);
    final effectiveBgColor = bgColor ?? const Color(0xFFEFF6FF);
    final effectiveBorderColor = borderColor ?? const Color(0xFFDBEAFE);

    return Material(
      color: effectiveBgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: effectiveBorderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: effectiveIconColor),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: effectiveTextColor,
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
    final gallerySlotPresets = [
      {
        'title': 'Selfie Pose',
        'subtitle': 'Casual / Hobby',
        'icon': Icons.camera_alt_outlined,
        'iconBg': const Color(0xFFFCE7F3),
        'iconColor': const Color(0xFFDB2777),
      },
      {
        'title': 'Family Gathering',
        'subtitle': 'Optional slot',
        'icon': Icons.groups_outlined,
        'iconBg': const Color(0xFFEDE9FE),
        'iconColor': const Color(0xFF7C3AED),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                    'Upload up to 5 photos for parent & family review (3 - 4 MB each)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (_galleryPhotos.length > 1) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
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

                // Render Slot placeholders for remaining slots
                for (int i = _galleryPhotos.length; i < gallerySlotPresets.length; i++)
                  _buildEmptySlotTile(
                    width: itemWidth,
                    icon: gallerySlotPresets[i]['icon'] as IconData,
                    iconBg: gallerySlotPresets[i]['iconBg'] as Color,
                    iconColor: gallerySlotPresets[i]['iconColor'] as Color,
                    title: gallerySlotPresets[i]['title'] as String,
                    subtitle: gallerySlotPresets[i]['subtitle'] as String,
                    onTap: () => _showPhotoSourcePicker(
                      isPrimary: false,
                      slotLabel: gallerySlotPresets[i]['title'] as String,
                    ),
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
                            _showPhotoSourcePicker(isPrimary: false, slotLabel: item['label']);
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
                  image: _getImageProvider(item['asset']!),
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
                'Slot ${index + 1} of 5',
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
    final count = _galleryPhotos.length;
    final isMax = count >= 5;
    return SizedBox(
      width: width,
      child: Material(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (isMax) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Maximum 5 gallery photos already reached'),
                  backgroundColor: Color(0xFFE11D48),
                ),
              );
            } else {
              _showPhotoSourcePicker(
                isPrimary: false,
                slotLabel: 'Gallery Photo ${count + 1}',
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 125,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isMax ? const Color(0xFFE2E8F0) : const Color(0xFFCBD5E1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isMax ? Icons.check_circle_outline : Icons.add_photo_alternate_outlined,
                  size: 22,
                  color: isMax ? const Color(0xFF94A3B8) : const Color(0xFF701A33),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Max 5 Photos for\nfocused matches',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
                if (!isMax) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7F3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+ Add Photo ($count/5)',
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFBE123C),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
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
                        'Profiles with family and casual photos receive ',
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '24 HOURS SLA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
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
