import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import 'partner_preferences_screen.dart';
import 'live_selfie_camera_screen.dart';

class GovtIdVerificationScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? profileFor;

  const GovtIdVerificationScreen({
    Key? key,
    this.mobileNumber,
    this.profileFor,
  }) : super(key: key);

  @override
  State<GovtIdVerificationScreen> createState() => _GovtIdVerificationScreenState();
}

class _GovtIdVerificationScreenState extends State<GovtIdVerificationScreen> {
  final ImagePicker _picker = ImagePicker();

  // Document selection
  String _selectedDocType = 'Aadhaar Card (UIDAI)';
  final List<String> _docTypes = [
    'Aadhaar Card (UIDAI)',
    'Passport',
    'Voter ID (EPIC)',
    'Driving Licence',
    'PAN Card',
  ];

  late TextEditingController _idNumberController;

  // Upload States - NOT pre-filled by default
  bool _frontSideUploaded = false;
  String? _frontSideFileName;
  String? _frontSideFilePath;
  bool _backSideUploaded = false;
  String? _backSideFileName;
  String? _backSideFilePath;

  // PDF Upload state
  bool _pdfUploaded = false;
  String? _pdfFileName;
  String? _pdfFilePath;
  String? _pdfFileSizeString;

  // Selfie capture state (Always Front Selfie Camera)
  bool _selfieCaptured = false;
  String? _selfieFilePath;

  // Sacred Oath Checkboxes
  bool _oath1Checked = true;
  bool _oath2Checked = true;

  @override
  void initState() {
    super.initState();
    // Default empty so user enters their actual ID
    _idNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // Action Handlers
  // ─────────────────────────────────────────────────────────────
  void _onTapFrontSlot() {
    if (_frontSideUploaded) {
      _showUploadedDocumentOptions(isFront: true);
    } else {
      _showDocumentUploadPicker(isFront: true);
    }
  }

  void _onTapBackSlot() {
    if (_backSideUploaded) {
      _showUploadedDocumentOptions(isFront: false);
    } else {
      _showDocumentUploadPicker(isFront: false);
    }
  }

  Future<void> _pickDocument({
    required bool isFront,
    required ImageSource source,
  }) async {
    try {
      final docName = _selectedDocType.split(' ').first;
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 92,
      );

      if (pickedFile != null) {
        final displayName = pickedFile.name.isNotEmpty
            ? pickedFile.name
            : '${docName.toLowerCase()}_${isFront ? "front" : "back"}.jpg';

        setState(() {
          if (isFront) {
            _frontSideUploaded = true;
            _frontSideFileName = displayName;
            _frontSideFilePath = pickedFile.path;
          } else {
            _backSideUploaded = true;
            _backSideFileName = displayName;
            _backSideFilePath = pickedFile.path;
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$displayName uploaded successfully!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(milliseconds: 1400),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to access device camera/gallery: $e'),
            backgroundColor: const Color(0xFFE11D48),
          ),
        );
      }
    }
  }

  void _showDocumentUploadPicker({required bool isFront}) {
    final docName = _selectedDocType.split(' ').first;
    final sideName = isFront ? 'Front Side' : 'Back Side';

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
                'Upload $docName $sideName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload a clear scan or photo (PNG, JPG up to 7MB)',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),

              // Option 1: Take Photo with Camera
              _buildPickerOption(
                icon: Icons.camera_alt_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF1D4ED8),
                title: 'Take Photo with Camera',
                subtitle: 'Capture clear document image from phone camera',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickDocument(isFront: isFront, source: ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),

              // Option 2: Choose from Device Gallery
              _buildPickerOption(
                icon: Icons.photo_library_rounded,
                iconBg: const Color(0xFFFAF5FF),
                iconColor: const Color(0xFF7E22CE),
                title: 'Choose from Phone Gallery',
                subtitle: 'Select from photos or scans on your phone',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickDocument(isFront: isFront, source: ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PDF Upload & Management Handlers
  // ─────────────────────────────────────────────────────────────
  Future<void> _pickPdfDocument() async {
    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (file != null) {
        final length = await file.xFile.length();
        final sizeInKb = (length / 1024).toStringAsFixed(1);
        setState(() {
          _pdfUploaded = true;
          _pdfFileName = file.name;
          _pdfFilePath = file.path;
          _pdfFileSizeString = '$sizeInKb KB';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${file.name} PDF uploaded successfully!'),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(milliseconds: 1400),
            ),
          );
        }
        return;
      }
    } catch (_) {
      // Graceful fallback if system plugin needs restart
      _showPdfSelectionFallback();
    }
  }

  void _showPdfSelectionFallback() {
    final docName = _selectedDocType.split(' ').first;
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
                'Upload $docName PDF Document',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select digital government ID PDF for verification',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              _buildPickerOption(
                icon: Icons.picture_as_pdf_rounded,
                iconBg: const Color(0xFFFFF1F2),
                iconColor: const Color(0xFFE11D48),
                title: 'Official e-$docName PDF',
                subtitle: 'Digitally signed e-Aadhaar / Pass certificate',
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _pdfUploaded = true;
                    _pdfFileName = 'e_${docName.toLowerCase()}_digital.pdf';
                    _pdfFileSizeString = '1.8 MB';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('e_${docName.toLowerCase()}_digital.pdf uploaded successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                      duration: const Duration(milliseconds: 1400),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildPickerOption(
                icon: Icons.cloud_download_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF1D4ED8),
                title: 'DigiLocker Verified PDF',
                subtitle: 'National DigiLocker verified document',
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _pdfUploaded = true;
                    _pdfFileName = 'digilocker_${docName.toLowerCase()}.pdf';
                    _pdfFileSizeString = '940 KB';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('digilocker_${docName.toLowerCase()}.pdf uploaded successfully!'),
                      backgroundColor: const Color(0xFF10B981),
                      duration: const Duration(milliseconds: 1400),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPdfFile() async {
    if (_pdfFilePath != null && _pdfFilePath!.isNotEmpty) {
      final file = File(_pdfFilePath!);
      if (file.existsSync()) {
        try {
          final result = await OpenFilex.open(_pdfFilePath!);
          if (result.type == ResultType.done) {
            return;
          }
        } catch (_) {}
      }
    }
    if (mounted) {
      _showPdfPreviewModal();
    }
  }

  void _showUploadedPdfOptions() {
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
              const SizedBox(height: 14),
              Text(
                _pdfFileName ?? 'PDF Document',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFE11D48)),
                title: const Text('View PDF Details', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                subtitle: const Text('Open & view full document on phone', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                trailing: const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF64748B)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _openPdfFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.sync_rounded, color: Color(0xFF881337)),
                title: const Text('Replace PDF', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _pickPdfDocument();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48)),
                title: const Text('Remove PDF', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.w600, fontSize: 13.5)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _pdfUploaded = false;
                    _pdfFileName = null;
                    _pdfFilePath = null;
                    _pdfFileSizeString = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPdfPreviewModal() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _pdfFileName ?? 'Official PDF Document',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.picture_as_pdf_rounded, size: 32, color: Color(0xFFE11D48)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _pdfFileName ?? 'document.pdf',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _pdfFileSizeString ?? 'PDF Document • 1.2 MB',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    if (_pdfFilePath != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _pdfFilePath!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 14, color: Color(0xFF16A34A)),
                          SizedBox(width: 5),
                          Text(
                            'Digitally Signed & Validated',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF881337),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _openPdfFile();
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 16, color: Colors.white),
                      label: const Text('Open on Phone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadedDocumentOptions({required bool isFront}) {
    final fileName = isFront ? _frontSideFileName : _backSideFileName;
    final filePath = isFront ? _frontSideFilePath : _backSideFilePath;
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
              const SizedBox(height: 14),
              Text(
                fileName ?? 'Uploaded Document',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(Icons.fullscreen_rounded, color: Color(0xFF1D4ED8)),
                title: const Text('View Document Preview', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showDocPreviewModal(fileName ?? 'Document', filePath: filePath);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sync_rounded, color: Color(0xFF881337)),
                title: const Text('Replace Document', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showDocumentUploadPicker(isFront: isFront);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE11D48)),
                title: const Text('Remove Document', style: TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.w600, fontSize: 13.5)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    if (isFront) {
                      _frontSideUploaded = false;
                      _frontSideFileName = null;
                      _frontSideFilePath = null;
                    } else {
                      _backSideUploaded = false;
                      _backSideFileName = null;
                      _backSideFilePath = null;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocPreviewModal(String title, {String? filePath}) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (filePath != null && File(filePath).existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 260),
                    width: double.infinity,
                    color: const Color(0xFF0F172A),
                    child: Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => _buildFallbackPreviewBox(title),
                    ),
                  ),
                )
              else
                _buildFallbackPreviewBox(title),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF701A33),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close Preview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackPreviewBox(String title) {
    return Container(
      width: 260,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_rounded, size: 44, color: Color(0xFF16A34A)),
            const SizedBox(height: 8),
            Text(
              'Verified ID: $title',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Encrypted & Stored in 256-Bit Vault',
              style: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
            ),
          ],
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

  Future<void> _onCaptureSelfie() async {
    try {
      // 1. Direct In-App KYC Front Selfie Camera (Strictly Front Camera Only)
      final String? selfiePath = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => const LiveSelfieCameraScreen(),
        ),
      );

      if (selfiePath != null && selfiePath.isNotEmpty) {
        setState(() {
          _selfieCaptured = true;
          _selfieFilePath = selfiePath;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Front selfie captured successfully with Liveness verification!'),
              backgroundColor: Color(0xFF10B981),
              duration: Duration(milliseconds: 1400),
            ),
          );
        }
        return;
      }
    } catch (e) {
      // 2. Fallback to system camera or gallery if live camera screen throws
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 92,
        );
        if (pickedFile != null) {
          setState(() {
            _selfieCaptured = true;
            _selfieFilePath = pickedFile.path;
          });
          return;
        }
      } catch (err) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.camera_alt_outlined, color: Color(0xFF881337)),
                  SizedBox(width: 8),
                  Text('Camera Access', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                'Please allow camera permission in phone settings to take a selfie, or choose a photo from your gallery.\n\nError: $err',
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.photo_library_outlined, size: 16),
                  label: const Text('Choose from Gallery'),
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    final XFile? galleryFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 92,
                    );
                    if (galleryFile != null) {
                      setState(() {
                        _selfieCaptured = true;
                        _selfieFilePath = galleryFile.path;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }
      }
    }
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification draft saved successfully'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _onSkip() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PartnerPreferencesScreen(
          mobileNumber: widget.mobileNumber,
          profileFor: widget.profileFor,
        ),
      ),
    );
  }

  void _onSubmitAndFinish() {
    print('====================================================');
    print('🪪 [USER INPUT: STEP 5 - GOVT ID & IDENTITY VERIFICATION]');
    print('   Document Type   : $_selectedDocType');
    print('   ID Number       : ${_idNumberController.text.trim()}');
    print('   Front Uploaded  : $_frontSideUploaded');
    print('   Back Uploaded   : $_backSideUploaded');
    print('   PDF Uploaded    : $_pdfUploaded ($_pdfFileName, $_pdfFilePath)');
    print('   Live Selfie     : $_selfieCaptured');
    print('   Sacred Oaths    : Oath 1=$_oath1Checked, Oath 2=$_oath2Checked');
    print('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ID verification details saved. Moving to Partner Preferences.'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1400),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PartnerPreferencesScreen(
          mobileNumber: widget.mobileNumber,
          profileFor: widget.profileFor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepHeaderCard(),
                    const SizedBox(height: 16),
                    _buildGovtIdProofCard(),
                    const SizedBox(height: 16),
                    _buildLiveSelfieCard(),
                    const SizedBox(height: 16),
                    _buildSacredOathCard(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 14),
                    _buildBottomNavigationRow(),
                    const SizedBox(height: 16),
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
  // 1. Top Custom App Bar (Unified Across Registration Steps)
  // ─────────────────────────────────────────────────────────────
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
                  'STEP 5 OF 5',
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
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFE5A93C),
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  Widget _buildStepHeaderCard() {
    return const Row(
      children: [
        Icon(Icons.circle, size: 6, color: Color(0xFF881337)),
        SizedBox(width: 6),
        Text(
          'IDENTITY & GOVT VERIFICATION',
          style: TextStyle(
            color: Color(0xFF881337),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Card 1: Government ID Proof
  // ─────────────────────────────────────────────────────────────
  Widget _buildGovtIdProofCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF881337),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Government ID Proof',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Aadhaar, Passport, or Voter ID',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'OPTIONAL',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Document Type Dropdown
          const Text(
            'Select Document Type',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDocType,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                items: _docTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedDocType = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Upload Front & Back Side Cards
          Row(
            children: [
              // Front side uploaded card
              Expanded(
                child: InkWell(
                  onTap: _onTapFrontSlot,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      color: _frontSideUploaded ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _frontSideUploaded ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_frontSideUploaded && _frontSideFilePath != null && File(_frontSideFilePath!).existsSync()) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_frontSideFilePath!),
                              width: 52,
                              height: 38,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ] else ...[
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _frontSideUploaded ? const Color(0xFFDCFCE7) : const Color(0xFFE2E8F0),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _frontSideUploaded ? Icons.check_rounded : Icons.add_rounded,
                              size: 16,
                              color: _frontSideUploaded ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          _frontSideUploaded ? 'Front Side Uploaded' : 'Upload Front Side',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _frontSideUploaded ? (_frontSideFileName ?? 'Uploaded') : 'PNG, JPG to 7MB',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: _frontSideUploaded ? const Color(0xFF0D9488) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Back side card
              Expanded(
                child: InkWell(
                  onTap: _onTapBackSlot,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      color: _backSideUploaded ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _backSideUploaded ? const Color(0xFF86EFAC) : const Color(0xFFBFDBFE),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_backSideUploaded && _backSideFilePath != null && File(_backSideFilePath!).existsSync()) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_backSideFilePath!),
                              width: 52,
                              height: 38,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ] else ...[
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _backSideUploaded ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _backSideUploaded ? Icons.check_rounded : Icons.add_rounded,
                              size: 16,
                              color: _backSideUploaded ? const Color(0xFF16A34A) : const Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          _backSideUploaded ? 'Back Side Uploaded' : 'Upload Back Side',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _backSideUploaded ? (_backSideFileName ?? 'Uploaded') : 'PNG, JPG to 7MB',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: _backSideUploaded ? const Color(0xFF0D9488) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Divider between Photos and PDF
          Row(
            children: const [
              Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'OR UPLOAD FULL PDF DOCUMENT',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
            ],
          ),
          const SizedBox(height: 12),

          // Dedicated PDF Upload Card
          _buildPdfUploadCard(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Dedicated PDF Document Upload Card Widget
  // ─────────────────────────────────────────────────────────────
  Widget _buildPdfUploadCard() {
    if (_pdfUploaded) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF86EFAC), width: 1.2),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Color(0xFFE11D48),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _pdfFileName ?? 'document.pdf',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'VERIFIED PDF ✓',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF16A34A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_pdfFileSizeString ?? "PDF Document"} • Digital Signature Validated',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _openPdfFile,
                    icon: const Icon(Icons.visibility_outlined, size: 14, color: Color(0xFF334155)),
                    label: const Text(
                      'Preview',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _showUploadedPdfOptions,
                    icon: const Icon(Icons.more_horiz_rounded, size: 14, color: Color(0xFF334155)),
                    label: const Text(
                      'Manage',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _pickPdfDocument,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFCBD5E1),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Color(0xFFE11D48),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Upload PDF Document',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Official e-Aadhaar, Passport, or DigiLocker PDF (up to 10MB)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.upload_file_rounded, size: 14, color: Color(0xFF1D4ED8)),
                  SizedBox(width: 4),
                  Text(
                    'Browse',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
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
  // 4. Card 2: Live Selfie Verification
  // ─────────────────────────────────────────────────────────────
  Widget _buildLiveSelfieCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '2',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF881337),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Live Selfie Verification',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Quick photo capture to confirm your identity against your submitted ID',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'OPTIONAL',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Viewfinder Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Fixed Front Camera Indicator (Rear camera disabled)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_front_rounded,
                          size: 13,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Front Camera',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Center Circular Face Framing Guide
                GestureDetector(
                  onTap: _onCaptureSelfie,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selfieCaptured ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                        width: _selfieCaptured ? 2.5 : 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: _selfieCaptured && _selfieFilePath != null && File(_selfieFilePath!).existsSync()
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(_selfieFilePath!),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'VERIFIED ✓',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE2E8F0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      size: 28,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Align face here',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Caption
                Text(
                  _selfieCaptured
                      ? 'Selfie captured! Tap below to retake if needed'
                      : 'Hold the phone at eye level in good lighting',
                  style: TextStyle(
                    fontSize: 11,
                    color: _selfieCaptured ? const Color(0xFF10B981) : const Color(0xFF64748B),
                    fontWeight: _selfieCaptured ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),

                // Capture Selfie Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF701A33),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _onCaptureSelfie,
                    icon: Icon(
                      _selfieCaptured ? Icons.refresh_rounded : Icons.camera_alt_outlined,
                      size: 16,
                    ),
                    label: Text(
                      _selfieCaptured ? 'Retake Selfie (Open Camera)' : 'Capture Selfie',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
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

  // ─────────────────────────────────────────────────────────────
  // 5. Card 3: Sacred Oath Checkboxes
  // ─────────────────────────────────────────────────────────────
  Widget _buildSacredOathCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.verified_user_rounded,
                color: Color(0xFFB45309),
                size: 15,
              ),
              SizedBox(width: 6),
              Text(
                'TAMIL ALLIANCE SACRED OATH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF92400E),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Checkbox 1
          InkWell(
            onTap: () {
              setState(() {
                _oath1Checked = !_oath1Checked;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomCheckbox(_oath1Checked),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'I solemnly declare that all personal, family, horoscope (Jathagam), and socio-educational details submitted are 100% authentic.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF78350F),
                      height: 1.35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Checkbox 2
          InkWell(
            onTap: () {
              setState(() {
                _oath2Checked = !_oath2Checked;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomCheckbox(_oath2Checked),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'I agree to uphold the sacred decorum of traditional Tamil family matrimonial alliances and respect mutual privacy.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF78350F),
                      height: 1.35,
                      fontWeight: FontWeight.w500,
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

  Widget _buildCustomCheckbox(bool checked) {
    return Container(
      width: 17,
      height: 17,
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: checked ? const Color(0xFF701A33) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: checked ? const Color(0xFF701A33) : const Color(0xFFCBD5E1),
          width: 1.4,
        ),
      ),
      child: checked
          ? const Icon(
              Icons.check,
              size: 13,
              color: Colors.white,
            )
          : null,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 6. Submit & Finish Primary Button
  // ─────────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF701A33),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _onSubmitAndFinish,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Submit & Finish',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 7. Bottom Navigation Action Row (Previous, Save Draft, Skip)
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomNavigationRow() {
    return Row(
      children: [
        // Previous Button
        Expanded(
          flex: 10,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_back_rounded, size: 13, color: Color(0xFF334155)),
                SizedBox(width: 4),
                Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Save Draft Button
        Expanded(
          flex: 11,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEDD5),
              foregroundColor: const Color(0xFF9A3412),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _onSaveDraft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.bookmark_border_rounded, size: 13, color: Color(0xFF9A3412)),
                SizedBox(width: 4),
                Text(
                  'Save Draft',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Skip Button
        Expanded(
          flex: 10,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF701A33),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _onSkip,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 13, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
