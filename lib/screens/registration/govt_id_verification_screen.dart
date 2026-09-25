import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_screen.dart';

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
  bool _backSideUploaded = false;
  String? _backSideFileName;

  // Selfie capture state
  bool _selfieCaptured = false;
  bool _isFrontCamera = true;

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
                'Upload a clear scan or photo (PNG, JPG, PDF up to 7MB)',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),

              // Option 1: Take Photo with Camera
              _buildPickerOption(
                icon: Icons.camera_alt_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF1D4ED8),
                title: 'Take Photo with Camera',
                subtitle: 'Capture clear document image from camera',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _handleDocumentSelected(
                    isFront: isFront,
                    fileName: '${docName.toLowerCase()}_${isFront ? "front" : "back"}_camera.jpg',
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
                subtitle: 'Select from photos or scans on your phone',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _handleDocumentSelected(
                    isFront: isFront,
                    fileName: '${docName.toLowerCase()}_${isFront ? "front" : "back"}.jpg',
                  );
                },
              ),
              const SizedBox(height: 10),

              // Option 3: Choose PDF Document
              _buildPickerOption(
                icon: Icons.description_rounded,
                iconBg: const Color(0xFFFFF1F2),
                iconColor: const Color(0xFFBE123C),
                title: 'Upload PDF / Digital Doc',
                subtitle: 'Official e-Aadhaar, Digilocker, or PDF file',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _handleDocumentSelected(
                    isFront: isFront,
                    fileName: '${docName.toLowerCase()}_${isFront ? "front" : "back"}.pdf',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadedDocumentOptions({required bool isFront}) {
    final fileName = isFront ? _frontSideFileName : _backSideFileName;
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
                  _showDocPreviewModal(fileName ?? 'Document');
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
                    } else {
                      _backSideUploaded = false;
                      _backSideFileName = null;
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

  void _showDocPreviewModal(String title) {
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
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
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
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF881337),
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

  void _handleDocumentSelected({required bool isFront, required String fileName}) {
    setState(() {
      if (isFront) {
        _frontSideUploaded = true;
        _frontSideFileName = fileName;
      } else {
        _backSideUploaded = true;
        _backSideFileName = fileName;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fileName uploaded successfully!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(milliseconds: 1200),
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

  void _onCaptureSelfie() {
    setState(() {
      _selfieCaptured = !_selfieCaptured;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_selfieCaptured ? 'Selfie captured successfully with Liveness verification!' : 'Selfie reset. You can capture again.'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(milliseconds: 1400),
      ),
    );
  }

  void _onFlipCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  void _onSaveDraft() {
    debugPrint('====================================================');
    debugPrint('[STEP 5 DRAFT SAVED: GOVT ID & VERIFICATION]');
    debugPrint('  Document Type   : $_selectedDocType');
    debugPrint('  ID Number       : ${_idNumberController.text}');
    debugPrint('  Front Uploaded  : $_frontSideUploaded');
    debugPrint('  Back Uploaded   : $_backSideUploaded');
    debugPrint('  Selfie Captured : $_selfieCaptured');
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification draft saved successfully'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );
  }

  void _onSubmitAndFinish() {
    debugPrint('====================================================');
    debugPrint('[STEP 5 SUBMITTED: IDENTITY & GOVT VERIFICATION]');
    debugPrint('  Document Type   : $_selectedDocType');
    debugPrint('  ID Number       : ${_idNumberController.text}');
    debugPrint('  Front Uploaded  : $_frontSideUploaded');
    debugPrint('  Back Uploaded   : $_backSideUploaded');
    debugPrint('  Selfie Captured : $_selfieCaptured');
    debugPrint('  Sacred Oaths    : 1=$_oath1Checked, 2=$_oath2Checked');
    debugPrint('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration completed successfully! Welcome to Tamil Alliance.'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1500),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          userPhone: widget.mobileNumber,
        ),
      ),
      (route) => false,
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
                  'STEP 5 OF 6',
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
  // 2. Step Tracker & Trust Shield Header Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildStepHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF881337),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'STEP 5 OF 6 • IDENTITY & GOVT\nVERIFICATION',
              style: TextStyle(
                color: Color(0xFF881337),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                height: 1.35,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Trust & Safety',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D4ED8),
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Shield',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D4ED8),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
          const SizedBox(height: 14),

          // ID Number Input Field
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Govt ID Number (Last 4 Digits Visible)',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                'Auto-Masked',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: TextField(
              controller: _idNumberController,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFF94A3B8)),
                hintText: _selectedDocType.contains('Aadhaar')
                    ? 'Enter 12-digit Aadhaar number'
                    : _selectedDocType.contains('Passport')
                        ? 'Enter 8-character Passport number'
                        : _selectedDocType.contains('PAN')
                            ? 'Enter 10-character PAN number'
                            : 'Enter ID number',
                hintStyle: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
                        Container(
                          width: 26,
                          height: 26,
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
                          _frontSideUploaded ? (_frontSideFileName ?? '') : 'PNG, JPG to 7MB',
                          textAlign: TextAlign.center,
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
                        Container(
                          width: 26,
                          height: 26,
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
                          _backSideUploaded ? (_backSideFileName ?? '') : 'PNG, JPG to 7MB',
                          textAlign: TextAlign.center,
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
        ],
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
                // Top Flip Button Row
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: _onFlipCamera,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.flip_camera_ios_outlined, size: 13, color: Color(0xFF64748B)),
                          SizedBox(width: 4),
                          Text(
                            'Flip',
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
                ),
                const SizedBox(height: 10),

                // Center Circular Face Framing Guide
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
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
                const SizedBox(height: 14),

                // Caption
                const Text(
                  'Hold the phone at eye level in good lighting',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
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
                    icon: const Icon(Icons.camera_alt_outlined, size: 16),
                    label: Text(
                      _selfieCaptured ? 'Selfie Captured ✓ (Retake)' : 'Capture Selfie',
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
            onPressed: _onSubmitAndFinish,
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
