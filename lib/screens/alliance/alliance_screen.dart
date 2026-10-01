import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'alliance_filter_screen.dart';

// ─────────────────────────────────────────────────────────────
// Model: AuspiciousProfile
// ─────────────────────────────────────────────────────────────
class AuspiciousProfile {
  final String id;
  final String name;
  final String activeStatus;
  final String education;
  final String ageHeight;
  final String occupation;
  final String nativeLocation;
  final String caste;
  final String kulam;
  final String gothram;
  final String rasi;
  final String nakshatram;
  final String dosham;
  final String rajjuPorutham;
  final List<String> keyPoruthams;
  final String familyStatus;
  final String father;
  final String mother;
  final String siblings;
  final List<String> photos;
  int shortlistCount;
  bool isShortlisted;
  bool isInterestSent;

  AuspiciousProfile({
    required this.id,
    required this.name,
    required this.activeStatus,
    required this.education,
    required this.ageHeight,
    required this.occupation,
    required this.nativeLocation,
    required this.caste,
    required this.kulam,
    required this.gothram,
    required this.rasi,
    required this.nakshatram,
    required this.dosham,
    required this.rajjuPorutham,
    required this.keyPoruthams,
    required this.familyStatus,
    required this.father,
    required this.mother,
    required this.siblings,
    required this.photos,
    required this.shortlistCount,
    this.isShortlisted = false,
    this.isInterestSent = false,
  });
}

class AllianceScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;
  final int initialProfileIndex;
  final String? initialProfileId;

  const AllianceScreen({
    super.key,
    this.onNavigateToHome,
    this.initialProfileIndex = 0,
    this.initialProfileId,
  });

  @override
  State<AllianceScreen> createState() => _AllianceScreenState();
}

class _AllianceScreenState extends State<AllianceScreen> with TickerProviderStateMixin {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // 5 Auspicious Match Profiles (Stacked / Swipeable Cards)
  List<AuspiciousProfile>? _profilesList;
  List<AuspiciousProfile> get _profiles => _profilesList ??= _getInitialProfiles();
  int _currentProfileIndex = 0;
  int _currentPhotoIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollHint = true;
  bool _isBottomBarHidden = false;

  // Swipe Animation state
  double _dragDx = 0.0;
  bool _isAnimatingSwipe = false;
  AnimationController? _swipeAnimController;
  Animation<double>? _swipeAnim;
  AnimationController? _entryAnimController;
  Animation<double>? _entryFadeAnim;
  Animation<Offset>? _entrySlideAnim;

  final List<Map<String, dynamic>> _filters = [
    {'title': 'All', 'isSpecial': false},
    {
      'title': 'Uthama Match',
      'subtitle': '(For premium only)',
      'isSpecial': true,
      'icon': Icons.workspace_premium_rounded,
    },
    {
      'title': 'Govt ID Verified',
      'isSpecial': false,
      'icon': Icons.shield_outlined,
    },
    {
      'title': 'Mutual Alliance',
      'isSpecial': false,
      'icon': Icons.handshake_outlined,
    },
  ];

  static List<AuspiciousProfile> _getInitialProfiles() {
    return [
      // 1. Soundarya R. (Recent Matches Handpicked)
      AuspiciousProfile(
        id: '#TA-F-74345',
        name: 'Soundarya R.',
        activeStatus: 'Active Today',
        education: 'M.S, MBA (Finance & Product)',
        ageHeight: "27 Yrs, 5' 5\" (165 cm)",
        occupation: "Product Lead • ₹32L, Zoho Corp",
        nativeLocation: 'Coimbatore / Chennai',
        caste: 'Brahmin',
        kulam: 'Cheran Kulam',
        gothram: 'Shiva Gothram',
        rasi: 'Simha (Leo)',
        nakshatram: 'Hastham (Padam 2)',
        dosham: 'No Dosham (செவ்வாய் தோஷம் இல்லை)',
        rajjuPorutham: '★ 94% Supreme Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Yoni ✓', 'Mahendra ✓'],
        familyStatus: 'Upper Middle Class • Nuclear Family',
        father: 'Chief Civil Engineer (Retd. TNEB, Coimbatore)',
        mother: 'Homemaker, MA Tamil Literature',
        siblings: '1 Younger Brother (Software Architect, Bengaluru)',
        photos: [
          'assets/images/bride_portrait.jpg',
          'assets/images/wedding_hero.jpg',
        ],
        shortlistCount: 342,
      ),

      // 1B. Priyadarshini S. (Daily Recommendations Match)
      AuspiciousProfile(
        id: '#TA-F-78341',
        name: 'Priyadarshini S.',
        activeStatus: 'Active Today',
        education: '28 Yrs • 5\'6" • M.S, MBA',
        ageHeight: "28 Yrs, 5' 6\" (168 cm)",
        occupation: "Product Manager • ₹32L, Tech Mahindra",
        nativeLocation: 'Chennai',
        caste: 'Brahmin',
        kulam: 'Kashyapa Gothram',
        gothram: 'Vishnu Gothram',
        rasi: 'Simha (Leo)',
        nakshatram: 'Hastham (Padam 3)',
        dosham: 'No Dosham (சுத்த ஜாதகம்)',
        rajjuPorutham: '★ 94% Supreme Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Yoni ✓', 'Mahendra ✓'],
        familyStatus: 'Upper Middle Class • Nuclear Family',
        father: 'Senior Director, Cognizant (Retd)',
        mother: 'Homemaker',
        siblings: '1 Younger Sister (Pursuing MS in UK)',
        photos: [
          'assets/images/home_priyadarshini.jpg',
          'assets/images/alliance_priyadarshini.jpg',
        ],
        shortlistCount: 388,
      ),

      // 2. Samyuktha K. (Daily Recommendation Match)
      AuspiciousProfile(
        id: '#TA-F-7634',
        name: 'Samyuktha K.',
        activeStatus: 'Online Now',
        education: 'B.Tech (CSE), M.S Cloud',
        ageHeight: "26 Yrs, 5' 4\" (163 cm)",
        occupation: 'Software Architect • ₹22L, Microsoft',
        nativeLocation: 'Salem / Chennai',
        caste: 'Iyer - Vadama',
        kulam: 'Kaundinya Gothram',
        gothram: 'Shiva Gothram',
        rasi: 'Rishaba (Taurus)',
        nakshatram: 'Rohini (Padam 4)',
        dosham: 'No Dosham (சுத்த ஜாதகம்)',
        rajjuPorutham: '★ 92% Auspicious Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Mahendra ✓', 'Adhipathi ✓'],
        familyStatus: 'Upper Middle Class • Nuclear Family',
        father: 'General Manager, Indian Bank (Retd)',
        mother: 'Homemaker',
        siblings: '1 Elder Brother (VP, Tech, Singapore)',
        photos: [
          'assets/images/home_samyuktha.jpg',
          'assets/images/wedding_hero.jpg',
        ],
        shortlistCount: 378,
      ),

      // 3. Dr. Siddharth S. (Recent Matches Handpicked)
      AuspiciousProfile(
        id: '#TA-M-76436',
        name: 'Dr. Siddharth S.',
        activeStatus: 'Active Today',
        education: 'M.B.B.S, M.D (Cardiology)',
        ageHeight: "31 Yrs, 5' 11\" (180 cm)",
        occupation: 'Cardiologist • ₹35L, Apollo Multispeciality',
        nativeLocation: 'Chennai',
        caste: 'Iyer - Vadama',
        kulam: 'Haritha Gothram',
        gothram: 'Shiva Gothram',
        rasi: 'Rishaba (Taurus)',
        nakshatram: 'Rohini (Padam 2)',
        dosham: 'No Dosham (சுத்த ஜாதகம்)',
        rajjuPorutham: '★ 92% Supreme Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Yoni ✓', 'Mahendra ✓'],
        familyStatus: 'Upper Middle Class • Nuclear Family',
        father: 'Senior Director, Anna University (Retd)',
        mother: 'Professor of Mathematics (Retd)',
        siblings: '1 Elder Sister (Married, Architect in Singapore)',
        photos: [
          'assets/images/groom_avatar.jpg',
          'assets/images/groom_full.jpg',
        ],
        shortlistCount: 428,
      ),

      // 4. Karthik V. (Newly Joined Match)
      AuspiciousProfile(
        id: '#TA-M-81923',
        name: 'Karthik V.',
        activeStatus: 'New • 2d ago',
        education: 'B.Tech (NIT), M.S Cloud Architecture',
        ageHeight: "28 Yrs, 5' 11\" (180 cm)",
        occupation: 'Lead Architect • ₹30L, Amazon Web Services',
        nativeLocation: 'Chennai',
        caste: 'Vadama',
        kulam: 'Kashyapa Gothram',
        gothram: 'Vishnu Gothram',
        rasi: 'Meenam (Pisces)',
        nakshatram: 'Revathi (Padam 3)',
        dosham: 'No Dosham (சுத்த ஜாதகம்)',
        rajjuPorutham: '★ 95% Supreme Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Vasya ✓', 'Sthree ✓'],
        familyStatus: 'Affluent • Traditional Family',
        father: 'General Manager, BHEL (Retd)',
        mother: 'Homemaker',
        siblings: '1 Younger Sister (Software Engineer, Chennai)',
        photos: [
          'assets/images/groom_full.jpg',
          'assets/images/groom_avatar.jpg',
        ],
        shortlistCount: 365,
      ),

      // 5. Bhavani S. (Newly Joined Match)
      AuspiciousProfile(
        id: '#TA-F-82014',
        name: 'Bhavani S.',
        activeStatus: 'New • 5d ago',
        education: 'M.S (Data Science, IISc Bangalore)',
        ageHeight: "27 Yrs, 5' 6\" (168 cm)",
        occupation: 'Data Scientist • ₹26L, Walmart Labs',
        nativeLocation: 'Bangalore / Chennai',
        caste: 'Iyer',
        kulam: 'Bharadvaja Gothram',
        gothram: 'Shiva Gothram',
        rasi: 'Vrischikam (Scorpio)',
        nakshatram: 'Anusham (Padam 2)',
        dosham: 'No Dosham',
        rajjuPorutham: '★ 94% Uthama Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Yoni ✓', 'Vedhai ✓'],
        familyStatus: 'Upper Middle Class • Nuclear Family',
        father: 'Chief Engineer, ISRO (Retd)',
        mother: 'Carnatic Music Vocalist & Teacher',
        siblings: '1 Younger Brother (Fintech Analyst, London)',
        photos: [
          'assets/images/home_priyadarshini.jpg',
          'assets/images/bride_portrait.jpg',
        ],
        shortlistCount: 298,
      ),

      // 6. Nithya M. (Newly Joined Match)
      AuspiciousProfile(
        id: '#TA-F-83921',
        name: 'Nithya M.',
        activeStatus: 'New • 1w ago',
        education: 'M.Phil, Ph.D (Tamil Literature)',
        ageHeight: "26 Yrs, 5' 3\" (160 cm)",
        occupation: 'Assistant Professor • ₹12L, PSG College',
        nativeLocation: 'Coimbatore',
        caste: 'Mudaliar',
        kulam: 'Srivatsa Gothram',
        gothram: 'Murugan Gothram',
        rasi: 'Mesham (Aries)',
        nakshatram: 'Aswini (Padam 4)',
        dosham: 'Chevvai Parikaram Done (Friendly Dosham)',
        rajjuPorutham: '★ 91% Uthama Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Mahendra ✓', 'Adhipathi ✓'],
        familyStatus: 'Respected Traditional Family',
        father: 'Textile Business Owner, Coimbatore',
        mother: 'Homemaker',
        siblings: '1 Elder Brother (Married, Textile Exporter)',
        photos: [
          'assets/images/bride_portrait.jpg',
          'assets/images/alliance_priyadarshini.jpg',
        ],
        shortlistCount: 310,
      ),

      // 7. Ananya Ramachandran
      AuspiciousProfile(
        id: 'TA-82910',
        name: 'Ananya Ramachandran',
        activeStatus: 'Active 2h ago',
        education: 'B.Tech (ECE), MBA (IIM-B)',
        ageHeight: "27 Yrs, 5' 4\" (163 cm)",
        occupation: 'Senior Product Manager, Google Bengaluru',
        nativeLocation: 'Erode',
        caste: 'Kongu Vellalar',
        kulam: 'Perungudi Kulam',
        gothram: 'Vishnu Gothram',
        rasi: 'Kumbha (Aquarius)',
        nakshatram: 'Sadayam (Padam 1)',
        dosham: 'No Dosham',
        rajjuPorutham: '★ 91% Auspicious Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Vasya ✓', 'Sthree ✓'],
        familyStatus: 'Affluent • Traditional Family',
        father: 'Industrialist (Textile Exports, Erode)',
        mother: 'Correspondent, Matriculation School',
        siblings: '1 Elder Sister (Married, Settled in USA)',
        photos: [
          'assets/images/home_priyadarshini.jpg',
          'assets/images/bride_portrait.jpg',
        ],
        shortlistCount: 289,
      ),

      // 8. Dr. Keerthana Sivakumar
      AuspiciousProfile(
        id: 'TA-65412',
        name: 'Dr. Keerthana Sivakumar',
        activeStatus: 'Active Today',
        education: 'B.D.S, M.D.S (Orthodontics)',
        ageHeight: "25 Yrs, 5' 3\" (160 cm)",
        occupation: 'Consultant Orthodontist, Multispeciality Clinic',
        nativeLocation: 'Tiruppur',
        caste: 'Kongu Vellalar',
        kulam: 'Thoodhan Kulam',
        gothram: 'Brahma Gothram',
        rasi: 'Thula (Libra)',
        nakshatram: 'Swathi (Padam 3)',
        dosham: 'Chevvai Parikaram Done (Friendly Dosham)',
        rajjuPorutham: '★ 94% Uthama Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Yoni ✓', 'Vedhai ✓'],
        familyStatus: 'Upper Middle Class • Joint Family',
        father: 'Textile Garments Manufacturer, Tiruppur',
        mother: 'Teacher (Govt Hr Sec School)',
        siblings: '1 Younger Sister (Pursuing B.Tech, Coimbatore)',
        photos: [
          'assets/images/soundarya_chat.jpg',
          'assets/images/alliance_priyadarshini.jpg',
        ],
        shortlistCount: 415,
      ),

      // 9. Harini Soundararajan
      AuspiciousProfile(
        id: 'TA-58321',
        name: 'Harini Soundararajan',
        activeStatus: 'Active Yesterday',
        education: 'Chartered Accountant (FCA), B.Com',
        ageHeight: "26 Yrs, 5' 4\" (162 cm)",
        occupation: 'Senior Manager - Audit & Tax, Deloitte Chennai',
        nativeLocation: 'Pollachi',
        caste: 'Kongu Vellalar',
        kulam: 'Pavalam Kulam',
        gothram: 'Agastya Gothram',
        rasi: 'Makara (Capricorn)',
        nakshatram: 'Uthiradam (Padam 2)',
        dosham: 'No Dosham',
        rajjuPorutham: '★ 93% Auspicious Match',
        keyPoruthams: ['Dina ✓', 'Gana ✓', 'Rasi ✓', 'Rajju ★', 'Yoni ✓', 'Vasya ✓'],
        familyStatus: 'Agricultural & Business Family',
        father: 'Coconut & Organic Farm Owner, Pollachi',
        mother: 'Homemaker',
        siblings: 'None (Only Daughter)',
        photos: [
          'assets/images/wedding_hero.jpg',
          'assets/images/bride_portrait.jpg',
        ],
        shortlistCount: 512,
      ),
    ];
  }

  int _resolveInitialIndex() {
    if (widget.initialProfileId != null) {
      final q = widget.initialProfileId!.toLowerCase().replaceAll('#', '').trim();
      final idx = _profiles.indexWhere((p) =>
        p.id.toLowerCase().replaceAll('#', '').trim() == q ||
        p.name.toLowerCase().contains(q) ||
        q.contains(p.name.toLowerCase())
      );
      if (idx != -1) return idx;
    }
    return widget.initialProfileIndex.clamp(0, _profiles.length - 1);
  }

  @override
  void initState() {
    super.initState();
    _currentProfileIndex = _resolveInitialIndex();

    _scrollController.addListener(() {
      if (_scrollController.hasClients && _scrollController.position.hasContentDimensions) {
        final double offset = _scrollController.offset;
        final double max = _scrollController.position.maxScrollExtent;
        final bool shouldShow = offset < 80;
        if (shouldShow != _showScrollHint) {
          setState(() {
            _showScrollHint = shouldShow;
          });
        }

        // When scrolled near the bottom where in-card buttons are shown, hide the floating bar
        if (max > 100 && offset >= max - 220) {
          if (!_isBottomBarHidden) {
            setState(() {
              _isBottomBarHidden = true;
            });
          }
        } else if (offset <= 60) {
          if (_isBottomBarHidden) {
            setState(() {
              _isBottomBarHidden = false;
            });
          }
        }
      }
    });

    // Card entry animation
    _entryAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entryFadeAnim = CurvedAnimation(parent: _entryAnimController!, curve: Curves.easeOut);
    _entrySlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryAnimController!, curve: Curves.easeOutCubic));

    // Swipe fly-out / reset animation
    _swipeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryAnimController?.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AllianceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialProfileId != oldWidget.initialProfileId ||
        widget.initialProfileIndex != oldWidget.initialProfileIndex) {
      final newIdx = _resolveInitialIndex();
      if (newIdx != _currentProfileIndex) {
        setState(() {
          _currentProfileIndex = newIdx;
          _currentPhotoIndex = 0;
          _isBottomBarHidden = false;
        });
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _entryAnimController?.dispose();
    _swipeAnimController?.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // Swipe Logic
  // ─────────────────────────────────────────────────────────────
  void _swipeNext() {
    if (_isAnimatingSwipe) return;
    _isAnimatingSwipe = true;

    final double start = _dragDx;
    final double target = -MediaQuery.of(context).size.width * 1.15;

    _swipeAnim = Tween<double>(begin: start, end: target).animate(
      CurvedAnimation(parent: _swipeAnimController!, curve: Curves.easeOutCubic),
    )..addListener(() {
        setState(() {
          _dragDx = _swipeAnim!.value;
        });
      });

    _swipeAnimController!.forward(from: 0.0).then((_) {
      setState(() {
        _currentProfileIndex = (_currentProfileIndex + 1) % _profiles.length;
        _currentPhotoIndex = 0;
        _dragDx = 0.0;
        _isAnimatingSwipe = false;
        _isBottomBarHidden = false;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _swipePrev() {
    if (_isAnimatingSwipe) return;
    _isAnimatingSwipe = true;

    final double start = _dragDx;
    final double target = MediaQuery.of(context).size.width * 1.15;

    _swipeAnim = Tween<double>(begin: start, end: target).animate(
      CurvedAnimation(parent: _swipeAnimController!, curve: Curves.easeOutCubic),
    )..addListener(() {
        setState(() {
          _dragDx = _swipeAnim!.value;
        });
      });

    _swipeAnimController!.forward(from: 0.0).then((_) {
      setState(() {
        _currentProfileIndex = (_currentProfileIndex - 1 + _profiles.length) % _profiles.length;
        _currentPhotoIndex = 0;
        _dragDx = 0.0;
        _isAnimatingSwipe = false;
        _isBottomBarHidden = false;
      });
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _springBack() {
    if (_dragDx == 0.0) return;
    _isAnimatingSwipe = true;

    final double start = _dragDx;
    _swipeAnim = Tween<double>(begin: start, end: 0.0).animate(
      CurvedAnimation(parent: _swipeAnimController!, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _dragDx = _swipeAnim!.value;
        });
      });

    _swipeAnimController!.forward(from: 0.0).then((_) {
      setState(() {
        _dragDx = 0.0;
        _isAnimatingSwipe = false;
      });
    });
  }

  void _nextPhoto(AuspiciousProfile profile) {
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % profile.photos.length;
    });
  }

  void _prevPhoto(AuspiciousProfile profile) {
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex - 1 + profile.photos.length) % profile.photos.length;
    });
  }

  void _handleSendInterestFor(AuspiciousProfile profile) {
    setState(() {
      profile.isInterestSent = !profile.isInterestSent;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (profile.isInterestSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sacred Interest Sent to ${profile.name}! Tap button again anytime to Unsend.',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.undo_rounded, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sacred Interest withdrawn for ${profile.name}.',
                  style: const TextStyle(fontWeight: FontWeight.w700),
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
  }

  void _handleShortlistFor(AuspiciousProfile profile) {
    setState(() {
      profile.isShortlisted = !profile.isShortlisted;
      profile.shortlistCount += profile.isShortlisted ? 1 : -1;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          profile.isShortlisted
              ? '${profile.name} added to your shortlisted matches.'
              : '${profile.name} removed from your shortlist.',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 12-House Chakram & Jathagam Bottom Sheet
  // ─────────────────────────────────────────────────────────────
  void _showJathagamChakramModal(AuspiciousProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: Color(0xFF4338CA), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '12-House Rasi & Navamsam Chakram',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            '${profile.name} • 10 Porutham Analysis',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // Rasi Grid Visual
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'ராசி கட்டம் (Rasi Chart)',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF78350F)),
                            ),
                            const SizedBox(height: 10),
                            Table(
                              border: TableBorder.all(color: const Color(0xFFD97706), width: 1.5),
                              children: [
                                TableRow(children: [
                                  _buildChakramCell('மீனம்\nபுதன்'),
                                  _buildChakramCell('மேஷம்\nசூரியன்'),
                                  _buildChakramCell('ரிஷபம்\nசுக்ரன்'),
                                  _buildChakramCell('மிதுனம்\nராகு'),
                                ]),
                                TableRow(children: [
                                  _buildChakramCell('கும்பம்'),
                                  Container(
                                    height: 54,
                                    color: const Color(0xFFFEF3C7),
                                    child: Center(
                                      child: Text(
                                        'லக்னம்\n${profile.rasi.split(" ").first}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 54,
                                    color: const Color(0xFFFEF3C7),
                                    child: Center(
                                      child: Text(
                                        'ராசி:\n${profile.nakshatram.split(" ").first}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                                      ),
                                    ),
                                  ),
                                  _buildChakramCell('கடகம்\nசந்திரன்'),
                                ]),
                                TableRow(children: [
                                  _buildChakramCell('மகரம்\nசனி'),
                                  _buildChakramCell('தனுசு\nகுரு'),
                                  _buildChakramCell('விருச்சி\nகேது'),
                                  _buildChakramCell('கன்னி\nசெவ்வாய்'),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 10 Porutham Summary Table
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'பத்து பொருத்தங்கள் விவரம் (10 Porutham Results)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 10),
                            _buildPoruthamRow('1. தினப் பொருத்தம் (Dina)', 'உத்தமம் (Uthamam)', true),
                            _buildPoruthamRow('2. கணப் பொருத்தம் (Gana)', 'உத்தமம் (Uthamam)', true),
                            _buildPoruthamRow('3. மகேந்திரப் பொருத்தம் (Mahendra)', 'பொருத்தம் உண்டு', true),
                            _buildPoruthamRow('4. ஸ்திரீ தீர்க்கப் பொருத்தம் (Sthree)', 'உத்தமம்', true),
                            _buildPoruthamRow('5. யோனிப் பொருத்தம் (Yoni)', 'உத்தமம் (பகை இல்லை)', true),
                            _buildPoruthamRow('6. ராசிப் பொருத்தம் (Rasi)', 'சுபப் பொருத்தம்', true),
                            _buildPoruthamRow('7. ராசியாதிபதி பொருத்தம் (Adhipathi)', 'மித்ரு பாவம்', true),
                            _buildPoruthamRow('8. வசியப் பொருத்தம் (Vasya)', 'உண்டு', true),
                            _buildPoruthamRow('9. ரஜ்ஜுப் பொருத்தம் (Rajju)', 'உத்தமம் (${profile.rajjuPorutham})', true),
                            _buildPoruthamRow('10. வேதைப் பொருத்தம் (Vedhai)', 'வேதை இல்லை', true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChakramCell(String text) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
      ),
    );
  }

  Widget _buildPoruthamRow(String title, String result, bool isMatch) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: [
              Icon(
                isMatch ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 16,
                color: isMatch ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Text(
                result,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isMatch ? const Color(0xFF059669) : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Build Screen
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final currentProfile = _profiles[_currentProfileIndex];

    return Stack(
      children: [
        // 1. Scrollable Upper Area (Filters + Search + Auspicious Cards with Details & Action Buttons)
        Positioned.fill(
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (!_scrollController.hasClients || !_scrollController.position.hasContentDimensions) {
                return false;
              }
              final double offset = _scrollController.offset;
              final double max = _scrollController.position.maxScrollExtent;

              // If scrolled near bottom where card's own buttons are visible, hide floating bar
              if (max > 100 && offset >= max - 220) {
                if (!_isBottomBarHidden) {
                  setState(() => _isBottomBarHidden = true);
                }
                return false;
              }

              // If near the top, always show floating bar
              if (offset <= 80) {
                if (_isBottomBarHidden) {
                  setState(() => _isBottomBarHidden = false);
                }
                return false;
              }

              // In middle range: hide when scrolling down, show when scrolling up
              if (notification.direction == ScrollDirection.reverse) {
                if (!_isBottomBarHidden) {
                  setState(() => _isBottomBarHidden = true);
                }
              } else if (notification.direction == ScrollDirection.forward) {
                if (_isBottomBarHidden) {
                  setState(() => _isBottomBarHidden = false);
                }
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Filter Pills Row
                  _buildFilterPillsRow(),
                  const SizedBox(height: 10),

                  // 2. Search & Filter Bar
                  _buildSearchFilterBar(),
                  const SizedBox(height: 14),

                  // 3. Stacked Auspicious Cards Deck ("Pinadi Pinadi")
                  FadeTransition(
                    opacity: _entryFadeAnim ?? const AlwaysStoppedAnimation(1.0),
                    child: SlideTransition(
                      position: _entrySlideAnim ?? const AlwaysStoppedAnimation(Offset.zero),
                      child: _buildStackedDeck(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. Floating Next Card Arrow (>) on right side
        Positioned(
          right: 4,
          top: 290,
          child: InkWell(
            onTap: _swipeNext,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ),

        // 3. Floating "Scroll ⌄" indicator at bottom-right
        Positioned(
          right: 18,
          bottom: 16,
          child: AnimatedOpacity(
            opacity: _showScrollHint ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(235),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
                    Text(
                      'Scroll',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 4. FLOATING STATIC BOTTOM ACTION BAR (Smoothly slides and hides when scrolling to bottom)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSlide(
            offset: _isBottomBarHidden ? const Offset(0, 1.2) : Offset.zero,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              opacity: _isBottomBarHidden ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: IgnorePointer(
                ignoring: _isBottomBarHidden,
                child: _buildStaticBottomActionBar(currentProfile),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Static Bottom Action Bar (Shortlist, Share Biodata, Send Sacred Interest)
  // ─────────────────────────────────────────────────────────────
  Widget _buildStaticBottomActionBar(AuspiciousProfile profile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _buildActionButtonsContent(profile),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Action Buttons Content (Shortlist + Share Biodata + Send Sacred Interest)
  // Used both in the static bottom bar & inside the card below Family Heritage (Image 3)
  // ─────────────────────────────────────────────────────────────
  Widget _buildActionButtonsContent(AuspiciousProfile profile) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Shortlist (342) & Share Biodata
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleShortlistFor(profile),
                icon: Icon(
                  profile.isShortlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 15,
                  color: profile.isShortlisted ? const Color(0xFFE11D48) : const Color(0xFF6366F1),
                ),
                label: Text(
                  'Shortlist (${profile.shortlistCount})',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: profile.isShortlisted ? const Color(0xFFE11D48) : const Color(0xFF4338CA),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFEEF2FF),
                  side: const BorderSide(color: Color(0xFFC7D2FE)),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Biodata of ${profile.name} copied to clipboard for sharing.'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.share_outlined, size: 15, color: Color(0xFF0D9488)),
                label: const Text(
                  'Share Biodata',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F766E),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0FDFA),
                  side: const BorderSide(color: Color(0xFF99F6E4)),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),

        // Row 2: Send Sacred Interest Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleSendInterestFor(profile),
            style: ElevatedButton.styleFrom(
              backgroundColor: profile.isInterestSent ? const Color(0xFF0F766E) : const Color(0xFF701A33),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      profile.isInterestSent ? Icons.undo_rounded : Icons.favorite_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      profile.isInterestSent ? 'Sacred Interest Sent (Tap to Unsend)' : 'Send Sacred Interest',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  profile.isInterestSent
                      ? 'Tap this button to withdraw / unsend your interest'
                      : 'Instant SMS & App notification sent to registered users',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Filter Pills Row
  // ─────────────────────────────────────────────────────────────
  Widget _buildFilterPillsRow() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (ctx, idx) {
          final filter = _filters[idx];
          final isSelected = _selectedFilterIndex == idx;
          final bool isSpecial = filter['isSpecial'] == true;

          return InkWell(
            onTap: () => setState(() => _selectedFilterIndex = idx),
            borderRadius: BorderRadius.circular(22),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF701A33)
                    : (isSpecial ? const Color(0xFFFFFBEB) : Colors.white),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF701A33)
                      : (isSpecial ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
                  width: 1,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFF701A33).withAlpha(40),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (filter['icon'] != null) ...[
                    Icon(
                      filter['icon'] as IconData,
                      size: isSpecial ? 16 : 14,
                      color: isSelected
                          ? Colors.white
                          : (isSpecial ? const Color(0xFFD97706) : const Color(0xFF2563EB)),
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (isSpecial) ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filter['title'] as String,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF92400E),
                            height: 1.15,
                          ),
                        ),
                        if (filter['subtitle'] != null)
                          Text(
                            filter['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white.withAlpha(210) : const Color(0xFFB45309),
                              height: 1.15,
                            ),
                          ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      filter['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Search by ID & Filter Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildSearchFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllianceFilterScreen(),
                ),
              );

              if (result != null && mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filters applied! Updating Alliance matches...',
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
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.tune_rounded, size: 14, color: Color(0xFF475569)),
                  SizedBox(width: 4),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                decoration: const InputDecoration(
                  hintText: 'search by ID Number',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.search, size: 16, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Stacked Auspicious Cards Deck ("Pinadi Pinadi")
  // ─────────────────────────────────────────────────────────────
  Widget _buildStackedDeck() {
    final currentProfile = _profiles[_currentProfileIndex];
    final nextProfile = _profiles[(_currentProfileIndex + 1) % _profiles.length];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Layer 3 (Deepest Background Card Header - peeking highest, narrower)
        Positioned(
          top: 0,
          left: 32,
          right: 32,
          height: 36,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, -1),
                ),
              ],
            ),
          ),
        ),

        // Layer 2 (Middle Card - peeking at top + visible background when front card is swiped)
        Positioned(
          top: 7,
          left: 22,
          right: 22,
          bottom: 0,
          child: _buildCardBackdrop(nextProfile),
        ),

        // Layer 1 (Front Interactive Card - starts at top: 14)
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _dragDx += details.delta.dx;
              });
            },
            onHorizontalDragEnd: (details) {
              if (_dragDx < -45) {
                // Swipe Left -> Next profile
                _swipeNext();
              } else if (_dragDx > 45) {
                // Swipe Right -> Previous profile
                _swipePrev();
              } else {
                _springBack();
              }
            },
            child: Transform.translate(
              offset: Offset(_dragDx, 0),
              child: Transform.rotate(
                angle: _dragDx * 0.00045,
                child: _buildMainProfileCard(currentProfile),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Visual Card Backdrop shown behind the active card
  Widget _buildCardBackdrop(AuspiciousProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              profile.photos.first,
              height: 360,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (ctx, err, stack) => Container(color: const Color(0xFFF1F5F9)),
            ),
            Container(color: Colors.black.withAlpha(35)),
            // Top ID badge of card behind
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(160),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. Main Profile Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildMainProfileCard(AuspiciousProfile profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 5A. Hero Photo with Overlays & Photo Switching
          _buildHeroPhotoWithOverlays(profile),

          // 5B. Details Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Active Badge + Menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              profile.name,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontSize: 17.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              profile.activeStatus,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6D28D9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert_rounded, size: 20, color: Color(0xFF64748B)),
                  ],
                ),
                const SizedBox(height: 6),

                // Degree & Age
                Text.rich(
                  TextSpan(
                    text: profile.education,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF701A33),
                    ),
                    children: [
                      TextSpan(
                        text: ' • ${profile.ageHeight}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Job & Native
                Text(
                  '${profile.occupation} • Native: ${profile.nativeLocation}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),

                // 5C. Lineage Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'Lineage: ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      _LineagePill(label: profile.caste),
                      _LineagePill(label: profile.kulam),
                      _LineagePill(label: profile.gothram),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 5D. Vedic Astrology Porutham Card
                _buildVedicAstrologyCard(profile),
                const SizedBox(height: 14),

                // 5E. Family Heritage & Background
                _buildFamilyHeritageCard(profile),
                const SizedBox(height: 14),

                // 5F. Action Buttons below Family Heritage (Image 3)
                _buildActionButtonsContent(profile),
                const SizedBox(height: 6),


              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5A. Hero Photo with Overlays & Tap Navigation
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroPhotoWithOverlays(AuspiciousProfile profile) {
    final int safePhotoIdx = _currentPhotoIndex.clamp(0, profile.photos.length - 1);
    final String currentPhotoPath = profile.photos[safePhotoIdx];
    final int totalPhotos = profile.photos.length + 3; // pretend 5 photos

    return Stack(
      children: [
        // Main Photo
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SizedBox(
            height: 360,
            width: double.infinity,
            child: Image.asset(
              currentPhotoPath,
              height: 360,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (ctx, err, stack) => Container(
                height: 360,
                color: const Color(0xFFF1F5F9),
                child: const Icon(Icons.person_rounded, size: 80, color: Color(0xFFCBD5E1)),
              ),
            ),
          ),
        ),

        // Watermark in Center
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Transform.rotate(
                angle: -0.2,
                child: Text(
                  'Tamil Alliance ${profile.id}',
                  style: TextStyle(
                    color: Colors.white.withAlpha(45),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Photo tap zones: Left half = Previous photo, Right half = Next photo
        Positioned.fill(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _prevPhoto(profile),
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _nextPhoto(profile),
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),

        // Overlay Top-Left: 100% ID Verified & Vedic Horoscope Match
        Positioned(
          top: 12,
          left: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified_rounded, size: 13, color: Color(0xFF0284C7)),
                    SizedBox(width: 4),
                    Text(
                      '100% ID Verified',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0369A1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF701A33).withAlpha(230),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.auto_awesome, size: 12, color: Color(0xFFFDE68A)),
                    SizedBox(width: 4),
                    Text(
                      'Vedic Horoscope Match',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Overlay Top-Right: Photos counter (Shortlist button removed as requested)
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 11),
                const SizedBox(width: 4),
                Text(
                  '${safePhotoIdx + 1}/$totalPhotos Photos',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom photo indicator dots
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPhotos, (i) {
              final bool isActive = i == safePhotoIdx;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white.withAlpha(120),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5D. Vedic Astrology Porutham Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildVedicAstrologyCard(AuspiciousProfile profile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, size: 16, color: Color(0xFFD97706)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Vedic Astrology & Porutham',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '10 / 10 Match',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Rasi & Nakshatram Grid
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rasi (Moon Sign)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      profile.rasi,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nakshatram', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      profile.nakshatram,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Chevvai Dosham
          Row(
            children: [
              const Icon(Icons.check_circle_outline, size: 14, color: Color(0xFF059669)),
              const SizedBox(width: 5),
              const Text(
                'Chevvai Dosham: ',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
              ),
              Expanded(
                child: Text(
                  profile.dosham,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Rajju Porutham
          Row(
            children: [
              const Text(
                'Rajju Porutham: ',
                style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
              ),
              Expanded(
                child: Text(
                  profile.rajjuPorutham,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Key Poruthams Badges
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: profile.keyPoruthams.map((p) => _PoruthamPill(title: p)).toList(),
          ),
          const SizedBox(height: 10),

          // Clickable Link to Full Jathagam Bottomsheet
          InkWell(
            onTap: () => _showJathagamChakramModal(profile),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: Text(
                      'View Full 12-House Chakram & Jathagam',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4338CA),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF4338CA)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5E. Family Heritage & Background
  // ─────────────────────────────────────────────────────────────
  Widget _buildFamilyHeritageCard(AuspiciousProfile profile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.family_restroom_rounded, size: 16, color: Color(0xFFBE185D)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Family Heritage & Background',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          _buildHeritageRow('Status:', profile.familyStatus),
          _buildHeritageRow('Father:', profile.father),
          _buildHeritageRow('Mother:', profile.mother),
          _buildHeritageRow('Siblings:', profile.siblings),
          const SizedBox(height: 8),

          // Lifestyle Pills
          Wrap(
            spacing: 6,
            runSpacing: 5,
            children: const [
              _LifestylePill(
                icon: Icons.eco_outlined,
                label: 'Vegetarian',
                color: Color(0xFF059669),
                bgColor: Color(0xFFECFDF5),
              ),
              _LifestylePill(
                icon: Icons.smoke_free_rounded,
                label: 'Non-Smoker',
                color: Color(0xFFDC2626),
                bgColor: Color(0xFFFEF2F2),
              ),
              _LifestylePill(
                icon: Icons.no_drinks_outlined,
                label: 'Non-Drinker',
                color: Color(0xFF7C3AED),
                bgColor: Color(0xFFF5F3FF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeritageRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Sub-components
// ─────────────────────────────────────────────────────────────
class _LineagePill extends StatelessWidget {
  final String label;
  const _LineagePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF334155),
        ),
      ),
    );
  }
}

class _PoruthamPill extends StatelessWidget {
  final String title;
  const _PoruthamPill({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFA7F3D0)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF047857),
        ),
      ),
    );
  }
}

class _LifestylePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  const _LifestylePill({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
