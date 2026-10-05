import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LiveSelfieCameraScreen extends StatefulWidget {
  const LiveSelfieCameraScreen({Key? key}) : super(key: key);

  @override
  State<LiveSelfieCameraScreen> createState() => _LiveSelfieCameraScreenState();
}

class _LiveSelfieCameraScreenState extends State<LiveSelfieCameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitializing = true;
  String? _errorMessage;
  XFile? _capturedImage;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No camera hardware found on this device.';
          _isInitializing = false;
        });
        return;
      }

      // Strictly look for front selfie camera
      CameraDescription? frontCamera;
      for (final cam in _cameras) {
        if (cam.lensDirection == CameraLensDirection.front) {
          frontCamera = cam;
          break;
        }
      }

      // If no front camera found, fallback to first available
      final selectedCamera = frontCamera ?? _cameras.first;

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _controller = controller;
      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not access front camera: $e';
        _isInitializing = false;
      });
    }
  }

  Future<void> _takeSelfie() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    try {
      setState(() => _isCapturing = true);
      final XFile file = await controller.takePicture();
      if (!mounted) return;
      setState(() {
        _capturedImage = file;
        _isCapturing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take picture: $e'),
          backgroundColor: const Color(0xFFE11D48),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Preview or Captured Image
            if (_capturedImage != null)
              _buildCapturedPreview()
            else if (_isInitializing)
              _buildLoadingState()
            else if (_errorMessage != null)
              _buildErrorState()
            else if (_controller != null && _controller!.value.isInitialized)
              _buildLiveCamera()
            else
              _buildLoadingState(),

            // Top App Bar
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF701A33).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF43F5E).withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.face_retouching_natural_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'FRONT SELFIE ONLY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48), // balance space
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveCamera() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera stream
        Center(
          child: CameraPreview(_controller!),
        ),

        // Oval Cutout Mask & Guides
        Positioned.fill(
          child: CustomPaint(
            painter: _OvalFaceMaskPainter(),
          ),
        ),

        // Instruction Pill
        Positioned(
          top: 75,
          left: 20,
          right: 20,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: const Text(
                'Position your face inside the oval frame',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        // Bottom Controls
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Hold still & look directly at the front camera',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _isCapturing ? null : _takeSelfie,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE11D48),
                      ),
                      child: _isCapturing
                          ? const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              ),
                            )
                          : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCapturedPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(_capturedImage!.path),
          fit: BoxFit.cover,
        ),

        // Confirmation Overlay at Bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.95),
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Selfie Captured Successfully',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          setState(() {
                            _capturedImage = null;
                          });
                        },
                        icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 18),
                        label: const Text('Retake', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(_capturedImage!.path);
                        },
                        icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                        label: const Text(
                          'Confirm & Use',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFFE11D48)),
          SizedBox(height: 16),
          Text(
            'Starting Front Camera...',
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_rounded, color: Color(0xFFF43F5E), size: 48),
            const SizedBox(height: 14),
            Text(
              _errorMessage ?? 'Camera error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF701A33),
              ),
              onPressed: _initializeCamera,
              child: const Text('Retry Camera', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OvalFaceMaskPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double ovalWidth = size.width * 0.72;
    final double ovalHeight = ovalWidth * 1.35;
    final Rect ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.44),
      width: ovalWidth,
      height: ovalHeight,
    );

    // Darkened exterior mask
    final Path backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path ovalPath = Path()..addOval(ovalRect);
    final Path maskPath = Path.combine(PathOperation.difference, backgroundPath, ovalPath);

    final Paint maskPaint = Paint()
      ..color = Colors.black.withOpacity(0.60)
      ..style = PaintingStyle.fill;
    canvas.drawPath(maskPath, maskPaint);

    // Glowing Oval Guide Border
    final Paint borderPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6;
    canvas.drawOval(ovalRect, borderPaint);

    // Subtle golden inner guide
    final Paint innerGuidePaint = Paint()
      ..color = const Color(0xFFFDE68A).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawOval(ovalRect.deflate(10), innerGuidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
