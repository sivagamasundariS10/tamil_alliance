import 'package:flutter/material.dart';

class EditAstrologyHoroscopeScreen extends StatefulWidget {
  final String? initialRasi;
  final String? initialNakshatram;
  final String? initialLagnam;
  final String? initialDosham;
  final String? initialPdf;
  final String? initialBirthTime;
  final String? initialBirthPlace;
  final String? initialGothram;
  final String? initialKuladeivam;

  const EditAstrologyHoroscopeScreen({
    super.key,
    this.initialRasi,
    this.initialNakshatram,
    this.initialLagnam,
    this.initialDosham,
    this.initialPdf,
    this.initialBirthTime,
    this.initialBirthPlace,
    this.initialGothram,
    this.initialKuladeivam,
  });

  @override
  State<EditAstrologyHoroscopeScreen> createState() => _EditAstrologyHoroscopeScreenState();
}

class _EditAstrologyHoroscopeScreenState extends State<EditAstrologyHoroscopeScreen> {
  // Theme Colors
  static const Color primaryMaroon = Color(0xFF701A31);

  // 12 Rasis
  final List<String> _rasiList = [
    'Mesham (Aries)',
    'Rishabham (Taurus)',
    'Mithunam (Gemini)',
    'Kadagam (Cancer)',
    'Simmam (Leo)',
    'Kanni (Virgo)',
    'Thulam (Libra)',
    'Vrischikam (Scorpio)',
    'Dhanusu (Sagittarius)',
    'Makaram (Capricorn)',
    'Kumbam (Aquarius)',
    'Meenam (Pisces)',
  ];

  // 27 Nakshatras
  final List<String> _nakshatraList = [
    'Aswini (Ashwini)',
    'Bharani',
    'Krithigai (Krittika)',
    'Rohini',
    'Mrigashirsha',
    'Thiruvathirai (Ardra)',
    'Punarpoosam (Punarvasu)',
    'Poosam (Pushya)',
    'Ayilyam (Ashlesha)',
    'Makam (Magha)',
    'Pooram (Purva Phalguni)',
    'Uthiram (Uttara Phalguni)',
    'Hastham (Hasta)',
    'Chithirai (Chitra)',
    'Swathi (Swati)',
    'Visakam (Vishakha)',
    'Anusham (Anuradha)',
    'Kettai (Jyeshtha)',
    'Moolam (Mula)',
    'Pooradam (Purva Ashadha)',
    'Uthiradam (Uttara Ashadha)',
    'Thiruvonam (Shravana)',
    'Avittam (Dhanishta)',
    'Sathayam (Shatabhisha)',
    'Poorattathi (Purva Bhadrapada)',
    'Uthirattathi (Uttara Bhadrapada)',
    'Revathi (Revati)',
  ];

  // 12 Lagnams
  final List<String> _lagnamList = [
    'Mesham (Aries)',
    'Rishabham (Taurus)',
    'Mithunam (Gemini)',
    'Kadagam (Cancer)',
    'Simmam (Leo)',
    'Kanni (Virgo)',
    'Thulam (Libra)',
    'Vrischikam (Scorpio)',
    'Dhanusu (Sagittarius)',
    'Makaram (Capricorn)',
    'Kumbam (Aquarius)',
    'Meenam (Pisces)',
  ];

  // Dosham options
  final List<String> _doshamList = [
    'No Dosham (Shuddha)',
    'Chevvai Dosham (Mars)',
    'Rahu / Ketu Dosham',
    'Chevvai & Rahu / Ketu',
    'Sarpa Dosham',
    'Not Known',
  ];

  // Padam list
  final List<String> _padamList = ['Padam 1', 'Padam 2', 'Padam 3', 'Padam 4'];

  // State Variables
  late String _selectedRasi;
  late String _selectedNakshatra;
  late String _selectedPadam;
  late String _selectedLagnam;
  late String _selectedDosham;
  late String _attachedPdf;

  @override
  void initState() {
    super.initState();
    _selectedRasi = widget.initialRasi ?? 'Makaram (Capricorn)';
    if (!_rasiList.contains(_selectedRasi)) {
      _selectedRasi = _rasiList.firstWhere(
        (r) => r.toLowerCase().contains(_selectedRasi.split(' ').first.toLowerCase()),
        orElse: () => 'Makaram (Capricorn)',
      );
    }

    String initialNak = widget.initialNakshatram ?? 'Uthiradam (Padam 2)';
    _selectedPadam = 'Padam 2';
    if (initialNak.contains('Padam 1')) _selectedPadam = 'Padam 1';
    if (initialNak.contains('Padam 2')) _selectedPadam = 'Padam 2';
    if (initialNak.contains('Padam 3')) _selectedPadam = 'Padam 3';
    if (initialNak.contains('Padam 4')) _selectedPadam = 'Padam 4';

    _selectedNakshatra = 'Uthiradam (Uttara Ashadha)';
    for (var n in _nakshatraList) {
      if (initialNak.toLowerCase().contains(n.split(' ').first.toLowerCase())) {
        _selectedNakshatra = n;
        break;
      }
    }

    _selectedLagnam = widget.initialLagnam ?? 'Mesham (Aries)';
    if (!_lagnamList.contains(_selectedLagnam)) {
      _selectedLagnam = _lagnamList.firstWhere(
        (l) => l.toLowerCase().contains(_selectedLagnam.split(' ').first.toLowerCase()),
        orElse: () => 'Mesham (Aries)',
      );
    }

    _selectedDosham = widget.initialDosham?.replaceAll('\n', ' ') ?? 'No Dosham (Shuddha)';
    if (!_doshamList.contains(_selectedDosham)) {
      _selectedDosham = _doshamList.firstWhere(
        (d) => d.toLowerCase().contains('shuddha') || d.toLowerCase().contains('no dosham'),
        orElse: () => 'No Dosham (Shuddha)',
      );
    }

    _attachedPdf = widget.initialPdf ?? 'Certified_Jathagam_Karthik.pdf';
  }

  void _resetToDefault() {
    setState(() {
      _selectedRasi = 'Makaram (Capricorn)';
      _selectedNakshatra = 'Uthiradam (Uttara Ashadha)';
      _selectedPadam = 'Padam 2';
      _selectedLagnam = 'Mesham (Aries)';
      _selectedDosham = 'No Dosham (Shuddha)';
      _attachedPdf = 'Certified_Jathagam_Karthik.pdf';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Astrology details reset to default.'),
        backgroundColor: primaryMaroon,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _saveAstrologyDetails() {
    FocusScope.of(context).unfocus();

    // Nakshatram formatted with padam
    final nakshatraName = _selectedNakshatra.split(' ').first;
    final formattedNakshatram = '$nakshatraName ($_selectedPadam)';

    final result = {
      'rasi': _selectedRasi,
      'nakshatram': formattedNakshatram,
      'lagnam': _selectedLagnam,
      'dosham': _selectedDosham,
      'pdf': _attachedPdf,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Astrology & Horoscope updated successfully!'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(milliseconds: 1200),
      ),
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeader(),
            const SizedBox(height: 14),

            // 1. Rasi & Nakshatram Card
            _buildRasiNakshatramCard(),
            const SizedBox(height: 14),

            // 2. Lagnam & Dosham Card
            _buildLagnamDoshamCard(),
            const SizedBox(height: 14),

            // 3. Jathagam PDF & Document Card
            _buildJathagamDocumentCard(),
            const SizedBox(height: 14),

            // 4. Security Footer Badge
            _buildSecurityFooterBadge(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top Custom App Bar
  // ─────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: primaryMaroon,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Astrology & Horoscope',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _resetToDefault,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'RESET',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Subheader
  Widget _buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF881337),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'VEDIC HOROSCOPE & NATAL VITALS',
              style: TextStyle(
                color: Color(0xFF881337),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header Helper for Cards
  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF881337).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF881337).withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF881337),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFF1F3FB)),
      ],
    );
  }

  // Mandatory Label
  Widget _buildMandatoryLabel(String label) {
    return Text.rich(
      TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Rasi & Nakshatram Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildRasiNakshatramCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.wb_sunny_rounded,
            title: 'RASI & NAKSHATRAM',
            subtitle: 'Moon sign, birth star & padam vitals',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Text(
                'JATHAGAM',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF92400E),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Rasi (Moon Sign) *
          _buildMandatoryLabel('Rasi (Moon Sign)'),
          const SizedBox(height: 6),
          _buildDropdownField(
            value: _selectedRasi,
            items: _rasiList,
            icon: Icons.brightness_3_rounded,
            onChanged: (val) {
              if (val != null) setState(() => _selectedRasi = val);
            },
          ),
          const SizedBox(height: 14),

          // Nakshatram (Star) *
          _buildMandatoryLabel('Nakshatram (Birth Star)'),
          const SizedBox(height: 6),
          _buildDropdownField(
            value: _selectedNakshatra,
            items: _nakshatraList,
            icon: Icons.star_rounded,
            onChanged: (val) {
              if (val != null) setState(() => _selectedNakshatra = val);
            },
          ),
          const SizedBox(height: 14),

          // Padam *
          _buildMandatoryLabel('Padam (Quarter)'),
          const SizedBox(height: 6),
          Row(
            children: _padamList.map((padam) {
              final isSelected = _selectedPadam == padam;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: InkWell(
                    onTap: () => setState(() => _selectedPadam = padam),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF881337) : const Color(0xFFF1F3FB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF881337) : const Color(0xFFE8EBFA),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        padam,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Lagnam & Dosham Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildLagnamDoshamCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.shield_rounded,
            title: 'LAGNAM & DOSHAM ALIGNMENT',
            subtitle: 'Ascendant rising sign & planetary doshas',
          ),
          const SizedBox(height: 14),

          // Lagnam (Ascendant) *
          _buildMandatoryLabel('Lagnam (Ascendant Rising Sign)'),
          const SizedBox(height: 6),
          _buildDropdownField(
            value: _selectedLagnam,
            items: _lagnamList,
            icon: Icons.auto_awesome_rounded,
            onChanged: (val) {
              if (val != null) setState(() => _selectedLagnam = val);
            },
          ),
          const SizedBox(height: 14),

          // Dosham Status *
          _buildMandatoryLabel('Chevvai / Rahu-Kethu Dosham Status'),
          const SizedBox(height: 6),
          _buildDropdownField(
            value: _selectedDosham,
            items: _doshamList,
            icon: Icons.verified_user_outlined,
            onChanged: (val) {
              if (val != null) setState(() => _selectedDosham = val);
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Jathagam Document & Chart Card with Phone Upload
  // ─────────────────────────────────────────────────────────────
  Widget _buildJathagamDocumentCard() {
    final bool isPdf = _attachedPdf.toLowerCase().endsWith('.pdf');
    final String badgeLabel = isPdf ? 'PDF' : 'IMG';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEDFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(
            icon: Icons.picture_as_pdf_rounded,
            title: 'JATHAGAM CHART & PDF DOCUMENT',
            subtitle: 'Validated 12-house Vedic chart attachment',
          ),
          const SizedBox(height: 14),

          // Current Document Box
          Material(
            color: const Color(0xFFFAF7F2),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _showJathagamUploadPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEDE4D5)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                      decoration: BoxDecoration(
                        color: isPdf ? const Color(0xFF881337) : const Color(0xFF1D4ED8),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _attachedPdf,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Validated 12-House Rasi & Navamsa Chart • Phone uploaded',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: _showJathagamUploadPicker,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF881337).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.file_upload_outlined, size: 14, color: Color(0xFF881337)),
                            SizedBox(width: 4),
                            Text(
                              'Replace',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF881337),
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
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Phone Upload Modal Bottom Sheet
  // ─────────────────────────────────────────────────────────────
  void _showJathagamUploadPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cloud_upload_rounded,
                      color: Color(0xFF881337),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Jathagam Chart',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Upload horoscope file from your phone storage or camera',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Option 1: PDF Document from Phone Storage
              _buildPickerOption(
                icon: Icons.picture_as_pdf_rounded,
                iconBg: const Color(0xFFFFF1F2),
                iconColor: const Color(0xFFBE123C),
                title: 'Choose PDF from Phone Files',
                subtitle: 'Browse downloads, documents or e-Jathagam PDF',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _showFileSelectionDialog();
                },
              ),
              const SizedBox(height: 12),

              // Option 2: Gallery Image
              _buildPickerOption(
                icon: Icons.photo_library_rounded,
                iconBg: const Color(0xFFFAF5FF),
                iconColor: const Color(0xFF7E22CE),
                title: 'Choose from Phone Gallery',
                subtitle: 'Select Horoscope chart photo or scan (JPG / PNG)',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _selectDocument('Jathagam_Scan_Gallery.jpg', isPdf: false);
                },
              ),
              const SizedBox(height: 12),

              // Option 3: Camera Capture
              _buildPickerOption(
                icon: Icons.camera_alt_rounded,
                iconBg: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF1D4ED8),
                title: 'Take Photo with Camera',
                subtitle: 'Capture clear snapshot of paper Jathagam chart',
                onTap: () {
                  Navigator.of(ctx).pop();
                  _selectDocument('Jathagam_Camera_Snap.jpg', isPdf: false);
                },
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  // Device File Selection Dialog for PDF
  void _showFileSelectionDialog() {
    final sampleFiles = [
      'Certified_Jathagam_Karthik.pdf',
      'Jathagam_Vedic_Chart_Updated.pdf',
      'Thirumana_Porutham_Horoscope.pdf',
      'Karthik_Birth_Horoscope_2026.pdf',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
              const Text(
                'Select PDF from Phone Storage',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose a file from Phone / Downloads / Documents:',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              ...sampleFiles.map((fileName) {
                final isSelected = _attachedPdf == fileName;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF881337) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBE123C).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFBE123C), size: 20),
                    ),
                    title: Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: const Text('Phone Storage / Downloads', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF881337), size: 20)
                        : const Icon(Icons.file_upload_outlined, color: Color(0xFF64748B), size: 20),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _selectDocument(fileName, isPdf: true);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDocument(String fileName, {required bool isPdf}) {
    setState(() {
      _attachedPdf = fileName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Jathagam chart updated from device: $fileName',
                style: const TextStyle(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
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
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Security Footer Badge
  Widget _buildSecurityFooterBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFEF3C7), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.verified_user_rounded,
              size: 15,
              color: Color(0xFFD97706),
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                '256-Bit Encrypted Vedic Astro Data Privacy Protected',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF92400E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown Field Helper
  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EBFA), width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: const Color(0xFF881337)),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Bottom Actions Bar
  Widget _buildBottomActionBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            offset: Offset(0, -3),
            blurRadius: 10,
          ),
        ],
        border: Border(
          top: BorderSide(color: Color(0xFFF1E5E9), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saveAstrologyDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryMaroon,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: const Color(0x33701A31),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Astrology Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
