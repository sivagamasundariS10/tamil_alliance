import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';

class InterestsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const InterestsScreen({
    super.key,
    this.onNavigateToHome,
  });

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  String _selectedFilter = 'Received';
  final List<String> _filters = [
    'All Activity',
    'Received',
    'Sent',
    'Mutual Alliance',
    'Declined',
  ];

  bool _karthikAccepted = false;
  bool _karthikDeclined = false;

  void _handleAcceptInterest(String name, String id) {
    setState(() {
      _karthikAccepted = true;
    });

    print('====================================================');
    print('🤝 [USER ACTION: ACCEPT INTEREST]');
    print('   Candidate Name : $name');
    print('   Candidate ID   : $id');
    print('   Status         : Mutual Alliance Established ✓');
    print('====================================================');

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Alliance Interest accepted with $name! Family contacts unlocked.',
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
  }

  void _handleDeclineInterest(String name, String id) {
    setState(() {
      _karthikDeclined = true;
    });

    print('====================================================');
    print('🚫 [USER ACTION: DECLINE INTEREST]');
    print('   Candidate Name : $name');
    print('   Candidate ID   : $id');
    print('   Status         : Interest Declined politely');
    print('====================================================');

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Interest from $name has been removed.'),
        backgroundColor: const Color(0xFF475569),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showChakramPreviewDialog() {
    print('====================================================');
    print('🪐 [USER ACTION: VIEW HOROSCOPE CHAKRAM PREVIEW]');
    print('   Candidate : Karthik Chidambaram');
    print('   Porutham  : 9 / 10 Match (Rasi, Ganam, Yoni, Mahendram)');
    print('====================================================');

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFBE123C), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      '12-House Chakram Preview',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Rasi: Makaram', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1E293B))),
                        Text('Star: Thiruvonam (Pada 2)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0F766E))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Chevvai Dosham: Nil (No Dosham)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        Text('Compatibility: 9/10 Poruthams', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFFBE123C))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF701A33),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Close Preview', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title + Subtitle + Action Buttons (Search & Filter)
          _buildHeaderSection(),
          const SizedBox(height: 14),

          // 2. Filter Pills Row
          _buildFilterPillsRow(),
          const SizedBox(height: 18),

          // 3. Conditional Content based on _selectedFilter
          if (_selectedFilter == 'All Activity') ...[
            if (!_karthikDeclined) ...[
              _buildReceivedInterestsSection(),
              const SizedBox(height: 22),
            ],
            _buildSentInterestsSection(),
            const SizedBox(height: 22),
            _buildMutualAllianceSection(),
          ] else if (_selectedFilter == 'Received') ...[
            if (!_karthikDeclined) ...[
              _buildReceivedInterestsSection(),
              const SizedBox(height: 22),
            ] else ...[
              _buildEmptyState('No pending received interests.', Icons.mark_email_read_rounded),
            ],
          ] else if (_selectedFilter == 'Sent') ...[
            _buildSentInterestsSection(),
          ] else if (_selectedFilter == 'Mutual Alliance') ...[
            _buildMutualAllianceSection(),
          ] else if (_selectedFilter == 'Declined') ...[
            if (_karthikDeclined) ...[
              _buildDeclinedCard('Karthik Chidambaram', 'TA-2026-KC88', 'Declined on your request'),
            ] else ...[
              _buildEmptyState('No declined proposals. All active alliances are healthy.', Icons.check_circle_outline_rounded),
            ],
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: const Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclinedCard(String name, String id, String reason) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.block_rounded, color: Color(0xFFDC2626), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text('$id • $reason', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Sent Proposals Section (Delivered, Viewed, Accepted Status Tracker)
  // ─────────────────────────────────────────────────────────────
  Widget _buildSentInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(Icons.send_rounded, color: Color(0xFF701A33), size: 18),
            const SizedBox(width: 8),
            const Text(
              'Sent Proposals & Status',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Text(
                '3 ACTIVE SENT',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFB45309),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Proposal 1: Viewed Status
        _buildSentProposalCard(
          name: 'Dr. Priyadarshini Sundaram',
          allianceId: 'TA-882194',
          details: '26 Yrs • 5\' 4" • MBBS, MD (Pediatrics)',
          location: 'Iyer / Vadama • Chennai, TN',
          sentTime: 'Sent Yesterday, 4:30 PM',
          status: 'Viewed',
          statusText: 'Viewed by Family',
          statusColor: const Color(0xFF2563EB),
          statusBg: const Color(0xFFEFF6FF),
          stage: 2, // 1: Delivered, 2: Viewed, 3: Accepted
          avatarAsset: 'assets/images/priya_doctor.jpg',
        ),
        const SizedBox(height: 12),

        // Proposal 2: Accepted Status
        _buildSentProposalCard(
          name: 'Ananya Natarajan',
          allianceId: 'TA-991204',
          details: '25 Yrs • 5\' 6" • Senior Software Engineer',
          location: 'Kongu Vellalar • Coimbatore / Bangalore',
          sentTime: 'Sent 3 days ago',
          status: 'Accepted',
          statusText: 'Interest Accepted ✓',
          statusColor: const Color(0xFF059669),
          statusBg: const Color(0xFFECFDF5),
          stage: 3,
          avatarAsset: 'assets/images/ananya_engineer.jpg',
        ),
        const SizedBox(height: 12),

        // Proposal 3: Delivered Status
        _buildSentProposalCard(
          name: 'Meenakshi Krishnan',
          allianceId: 'TA-773412',
          details: '27 Yrs • 5\' 5" • Chartered Accountant (CA)',
          location: 'Brahmin / Deshastha • Madurai, TN',
          sentTime: 'Sent 5 hours ago',
          status: 'Delivered',
          statusText: 'Delivered to In-app & SMS',
          statusColor: const Color(0xFFD97706),
          statusBg: const Color(0xFFFFFBEB),
          stage: 1,
          avatarAsset: 'assets/images/deepa_architect.jpg',
        ),
      ],
    );
  }

  Widget _buildSentProposalCard({
    required String name,
    required String allianceId,
    required String details,
    required String location,
    required String sentTime,
    required String status,
    required String statusText,
    required Color statusColor,
    required Color statusBg,
    required int stage,
    required String avatarAsset,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar + Info + Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    avatarAsset,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 60,
                      height: 60,
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(Icons.person, color: Color(0xFF94A3B8), size: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: statusColor.withAlpha(60)),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$allianceId • $details',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        location,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Live Status Tracker (Delivered -> Viewed -> Accepted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sentTime,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                      Text(
                        stage == 3 ? 'Mutual Match Established' : (stage == 2 ? 'Profile Reviewed' : 'Awaiting Opening'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: stage == 3 ? const Color(0xFF059669) : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Stage Dots & Progress Line
                  Row(
                    children: [
                      _buildStageStep('1. Delivered', stage >= 1, isCurrent: stage == 1),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: stage >= 2 ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      _buildStageStep('2. Viewed', stage >= 2, isCurrent: stage == 2),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: stage >= 3 ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      _buildStageStep('3. Accepted', stage >= 3, isCurrent: stage == 3),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Action Buttons Row (Remind, View Match, Withdraw)
            Row(
              children: [
                if (stage == 3) ...[
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Opening chat with $name...')),
                          );
                        },
                        icon: const Icon(Icons.chat_rounded, size: 14, color: Colors.white),
                        label: const Text('Start Sacred Chat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF701A33),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Polite Muhurtham Reminder sent to $name ✓')),
                          );
                        },
                        icon: const Icon(Icons.notifications_active_outlined, size: 14, color: Color(0xFF701A33)),
                        label: const Text('Send Reminder', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF701A33))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFECDD3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageStep(String title, bool isDone, {bool isCurrent = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFF10B981) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDone ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
              width: 1.5,
            ),
          ),
          child: isDone
              ? const Icon(Icons.check, size: 9, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isCurrent || isDone ? FontWeight.w800 : FontWeight.w500,
            color: isDone ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Header Section: Title, Subtitle, Search & Filter Buttons
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Activity & Connections',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Track sacred interests, family responses & shortlists',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Search Circular Button
        InkWell(
          onTap: () {
            print('🔍 [USER ACTION: SEARCH INTERESTS]');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_rounded, color: Color(0xFF475569), size: 19),
          ),
        ),
        const SizedBox(width: 8),

        // Filter / Tune Circular Button (Opens SettingsScreen)
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded, color: Color(0xFF475569), size: 19),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Filter Pills Row
  // ─────────────────────────────────────────────────────────────
  Widget _buildFilterPillsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: _filters.map((filter) {
          final bool isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                setState(() => _selectedFilter = filter);
                print('🔖 [USER ACTION: SWITCH FILTER TAB] -> $filter');
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF701A33) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Section 1: New Received Interests (Karthik Chidambaram)
  // ─────────────────────────────────────────────────────────────
  Widget _buildReceivedInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(Icons.mail_outline_rounded, color: Color(0xFFBE123C), size: 18),
            const SizedBox(width: 8),
            const Text(
              'New Received Interests',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF701A33),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '3 PENDING',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Received Interest Card (Karthik Chidambaram)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Info + Time
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with verified badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/karthik_interest.jpg',
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Image.asset(
                              'assets/images/groom_avatar.jpg',
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -3,
                          bottom: -3,
                          child: Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF2563EB),
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Karthik Chidambaram',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '2d ago',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '28 Yrs • 5\' 11" • Software Architect',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'B.Tech (NIT Trichy) • MS (Austin, TX)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1D4ED8),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Badges Row
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              _buildPillTag('Kongu Vellalar'),
                              _buildPillTag('Sivayam Kulam'),
                              _buildPillTag('Thiruvonam'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Verification Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF2563EB)),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Aadhaar & Photo 100% Verified',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Active Parent Managed',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Family Message Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Row(
                            children: [
                              Text(
                                '❝',
                                style: TextStyle(
                                  color: Color(0xFFBE123C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'FAMILY MESSAGE',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFBE123C),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF64748B)),
                              SizedBox(width: 2),
                              Text(
                                'Seattle, USA',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '“Vanakkam. Our family reviewed Karthik & your daughter\'s Jathagam. Porutham aligns excellently. Seeking alliance from respectable family. - S. Chidambaram (Father)”',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          height: 1.35,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Chakram Link
                      InkWell(
                        onTap: _showChakramPreviewDialog,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'View 12-House Chakram Preview',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.north_east_rounded, size: 13, color: Color(0xFF2563EB)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Accept & Decline Action Row
                if (!_karthikAccepted) ...[
                  Row(
                    children: [
                      // Accept Interest Button
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: () => _handleAcceptInterest('Karthik Chidambaram', 'TA-2026-KC88'),
                            icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: Colors.white),
                            label: const Text(
                              'Accept Interest',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF701A33),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Decline Button
                      InkWell(
                        onTap: () => _handleDeclineInterest('Karthik Chidambaram', 'TA-2026-KC88'),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.close_rounded, color: Color(0xFF64748B), size: 18),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                        SizedBox(width: 6),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Alliance Interest Accepted • Mutual Alliance Established',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF047857),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Bottom Link
                Center(
                  child: InkWell(
                    onTap: () {
                      print('📄 [USER ACTION: VIEW COMPLETE BIODATA] -> Karthik Chidambaram');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'View Complete Biodata & Family Tree',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF475569),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 13, color: Color(0xFF475569)),
                      ],
                    ),
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
  // 4. Section 2: Mutual Alliance Matches (Dr. Siddharth Sundaresan)
  // ─────────────────────────────────────────────────────────────
  Widget _buildMutualAllianceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(Icons.diamond_outlined, color: Color(0xFF2563EB), size: 18),
            const SizedBox(width: 8),
            const Text(
              'Mutual Alliance Matches',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '5 Unlocked',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E40AF),
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Mutual Match Card (Dr. Siddharth Sundaresan)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with verified badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/siddharth_doctor.jpg',
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Image.asset(
                              'assets/images/groom_avatar.jpg',
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -3,
                          bottom: -3,
                          child: Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF2563EB),
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dr. Siddharth Sundaresan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '29 Yrs • 6\' 0" • M.D., D.N.B (Cardiology)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Apollo Hospitals, Chennai',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Badges Row
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              _buildPillTag('Iyer / Vadama'),
                              _buildPillTag('Kaundinya Gothram'),
                              _buildPillTag('Hastham'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Direct Contacts Unlocked Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lock_open_rounded, size: 14, color: Color(0xFF2563EB)),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'DIRECT FAMILY CONTACTS UNLOCKED',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1D4ED8),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFCCFBF1)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.verified_rounded, size: 11, color: Color(0xFF0F766E)),
                                SizedBox(width: 3),
                                Text(
                                  'Verified OTP',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F766E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Contact 1: Father
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Father: R. Sundaresan (Retd. Dy GM, SBI)',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '+91 98410 44219',
                                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('📞 [USER ACTION: CALL PARENT] -> +91 98410 44219');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Dialing Father: +91 98410 44219...'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDBEAFE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.call_rounded, color: Color(0xFF2563EB), size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Contact 2: Candidate
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Candidate Mobile: Dr. Siddharth',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '+91 94440 21892',
                                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('✉️ [USER ACTION: MESSAGE CANDIDATE] -> +91 94440 21892');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Opening Chat with Dr. Siddharth...'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDBEAFE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF2563EB), size: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // WhatsApp and Secure Chat Action Buttons
                Row(
                  children: [
                    // WhatsApp Button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            print('💬 [USER ACTION: OPEN WHATSAPP CHAT] -> Dr. Siddharth Sundaresan (+91 94440 21892)');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Connecting via Tamil Alliance Verified WhatsApp...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.forum_outlined, size: 16, color: Color(0xFF1E293B)),
                          label: const Text(
                            'WhatsApp',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEFF6FF),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Secure Chat Button
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            print('🔒 [USER ACTION: OPEN SECURE CHAT] -> Dr. Siddharth Sundaresan');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening End-to-End Encrypted Family Chat...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_rounded, size: 16, color: Colors.white),
                          label: const Text(
                            'Secure Chat',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF701A33),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
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

  Widget _buildPillTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF475569),
        ),
      ),
    );
  }
}
