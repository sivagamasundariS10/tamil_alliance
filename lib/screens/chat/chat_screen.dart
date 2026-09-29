import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../settings/settings_screen.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const ChatScreen({
    super.key,
    this.onNavigateToHome,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allConversations = [
    {
      'handle': '@priya_doctor26',
      'name': 'Dr. Priyadharshini M.',
      'allianceId': 'Alliance ID - TA889123',
      'profession': 'Pediatrician (Chennai)',
      'avatar': 'assets/images/alliance_priyadarshini.jpg',
      'fallbackAvatar': 'assets/images/bride_portrait.jpg',
      'time': '10:45 AM',
      'lastMessage': 'Vanakkam! Parents agreed for the family',
      'isUnread': true,
      'unreadCount': 2,
      'isOnline': true,
      'tag': null,
      'statusRight': null,
      'isDoubleTick': false,
      'isSingleTick': false,
    },
    {
      'handle': '@siddharth_cardio',
      'name': 'Dr. Siddharth Sundaresan',
      'allianceId': 'Alliance ID - TA889123',
      'profession': 'Cardiologist (Madurai)',
      'avatar': 'assets/images/siddharth_doctor.jpg',
      'fallbackAvatar': 'assets/images/groom_avatar.jpg',
      'time': '9:12 AM',
      'lastMessage': 'Astrologer matched the 10 poruthams...',
      'isUnread': true,
      'unreadCount': 1,
      'isOnline': true,
      'tag': 'Managed by Father (Retd. AGM, SBI)',
      'statusRight': null,
      'isDoubleTick': false,
      'isSingleTick': false,
    },
    {
      'handle': '@karthik_arch',
      'name': 'Karthikeyan V.',
      'allianceId': 'Alliance ID - TA551288',
      'profession': 'Lead Enterprise Architect (Bangalore)',
      'avatar': 'assets/images/karthik_interest.jpg',
      'fallbackAvatar': 'assets/images/groom_avatar.jpg',
      'time': 'Yesterday',
      'lastMessage': 'Thanks for sharing the family horoscope',
      'isUnread': false,
      'unreadCount': 0,
      'isOnline': false,
      'tag': null,
      'statusRight': 'Chart Exchanged',
      'isDoubleTick': true,
      'isSingleTick': false,
    },
    {
      'handle': '@soundarya_family',
      'name': 'Soundarya R.',
      'allianceId': 'Alliance ID - TA993277',
      'profession': 'SDE-2 Amazon via Mrs. Meenakshi (Mother)',
      'avatar': 'assets/images/soundarya_chat.jpg',
      'fallbackAvatar': 'assets/images/bride_portrait.jpg',
      'time': 'Yesterday',
      'lastMessage': 'Namaskaram, our family would love to v',
      'isUnread': false,
      'unreadCount': 0,
      'isOnline': true,
      'tag': null,
      'statusRight': null,
      'isDoubleTick': true,
      'isSingleTick': false,
    },
    {
      'handle': '@anand_vfx',
      'name': 'Anandhan K.',
      'allianceId': 'Alliance ID - TA224490',
      'profession': 'Creative Director (Coimbatore)',
      'avatar': 'assets/images/anand_chat.jpg',
      'fallbackAvatar': 'assets/images/groom_avatar.jpg',
      'time': 'Tuesday',
      'lastMessage': 'Expressed Mutual Interest. Tap to unloc',
      'isUnread': false,
      'unreadCount': 0,
      'isOnline': false,
      'tag': null,
      'statusRight': null,
      'isDoubleTick': false,
      'isSingleTick': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredConversations {
    return _allConversations.where((conv) {
      if (_selectedFilter == 'Unread' && !conv['isUnread']) {
        return false;
      }
      if (_selectedFilter == 'read' && conv['isUnread']) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final handle = (conv['handle'] as String).toLowerCase();
        final name = (conv['name'] as String).toLowerCase();
        final profession = (conv['profession'] as String).toLowerCase();
        return handle.contains(query) || name.contains(query) || profession.contains(query);
      }
      return true;
    }).toList();
  }

  void _openChatDetail(Map<String, dynamic> item) {
    print('====================================================');
    print('💬 [USER ACTION: OPENED SACRED CHAT CONVERSATION]');
    print('   Handle     : ${item['handle']}');
    print('   Name       : ${item['name']}');
    print('   Profession : ${item['profession']}');
    print('   Status     : Unlocked & Encrypted ✓');
    print('====================================================');

    setState(() {
      item['isUnread'] = false;
      item['unreadCount'] = 0;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          handle: item['handle'] as String,
          name: item['name'] as String,
          allianceId: (item['allianceId'] ?? 'Alliance ID - TA889123') as String,
          profession: item['profession'] as String,
          avatarAsset: item['avatar'] as String,
          isOnline: item['isOnline'] as bool,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredConversations;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title + Subtitle + Action Icons
          _buildHeaderSection(),
          const SizedBox(height: 14),

          // 2. Search Bar with Mic
          _buildSearchBar(),
          const SizedBox(height: 14),

          // 3. Filter Pills Row: All (14), Unread (3), read (3)
          _buildFilterPillsRow(),
          const SizedBox(height: 16),

          // 4. Conversations List
          ...list.map((conv) => _buildConversationCard(conv)),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Header Section: Messages & Sacred Chats
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
                'Messages & Sacred Chats',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF701A33),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'உரையாடல்கள் & நேரடி தொடர்பு',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Settings / Tune Icon Button (Opens SettingsScreen)
        InkWell(
          onTap: () {
            print('⚙️ [USER ACTION: OPENED SETTINGS FROM CHAT SCREEN]');
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
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune_rounded, color: Color(0xFF3B82F6), size: 18),
          ),
        ),
        const SizedBox(width: 8),

        // Shield / Security Icon Button
        InkWell(
          onTap: () {
            print('🛡️ [USER ACTION: VIEW CHAT SECURITY & VERIFICATION PROTOCOL]');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All Sacred Chats are 100% ID Verified & Parent Protected.'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_outlined, color: Color(0xFF3B82F6), size: 18),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Search Bar
  // ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: const InputDecoration(
                hintText: 'Search conversations or handles (@)...',
                hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF64748B), size: 20),
            onPressed: () {
              print('🎙️ [USER ACTION: VOICE SEARCH FOR CHATS]');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listening for candidate name or handle...')),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Filter Pills Row (All 14, Unread 3, read 3)
  // ─────────────────────────────────────────────────────────────
  Widget _buildFilterPillsRow() {
    return Row(
      children: [
        // All 14
        _buildFilterChip(
          label: 'All',
          badgeText: '14',
          isSelected: _selectedFilter == 'All',
          onTap: () => setState(() => _selectedFilter = 'All'),
        ),
        const SizedBox(width: 10),

        // Unread 3
        _buildFilterChip(
          label: 'Unread',
          badgeText: '3',
          isSelected: _selectedFilter == 'Unread',
          onTap: () => setState(() => _selectedFilter = 'Unread'),
        ),
        const SizedBox(width: 10),

        // read 3
        _buildFilterChip(
          label: 'read',
          badgeText: '3',
          isSelected: _selectedFilter == 'read',
          onTap: () => setState(() => _selectedFilter = 'read'),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String badgeText,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF701A33) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF701A33) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF701A33).withAlpha(30),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withAlpha(50) : const Color(0xFFFDE8E8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? Colors.white : const Color(0xFF991B1B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. Conversation Card Component
  // ─────────────────────────────────────────────────────────────
  Widget _buildConversationCard(Map<String, dynamic> conv) {
    final isUnread = conv['isUnread'] as bool;
    final unreadCount = conv['unreadCount'] as int;
    final isOnline = conv['isOnline'] as bool;
    final tag = conv['tag'] as String?;
    final statusRight = conv['statusRight'] as String?;
    final isDoubleTick = conv['isDoubleTick'] as bool;
    final isSingleTick = conv['isSingleTick'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () => _openChatDetail(conv),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Online Status Indicator
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      conv['avatar'] as String,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Image.asset(
                        conv['fallbackAvatar'] as String,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isOnline ? const Color(0xFF10B981) : const Color(0xFFA1A1AA),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Conversation Info & Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle + Verified Badge + Timestamp
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            conv['handle'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, color: Color(0xFF2563EB), size: 14),
                        const Spacer(),
                        Text(
                          conv['time'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600,
                            color: isUnread ? const Color(0xFF701A33) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Name & Profession Subtitle
                    Text(
                      '${conv['name']} • ${conv['profession']}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Managed Tag (e.g. Managed by Father)
                    if (tag != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                    ],

                    // Message Snippet
                    Row(
                      children: [
                        if (isDoubleTick) ...[
                          const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF2563EB)),
                          const SizedBox(width: 4),
                        ] else if (isSingleTick) ...[
                          const Icon(Icons.done_rounded, size: 14, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            conv['lastMessage'] as String,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isUnread ? FontWeight.w800 : FontWeight.w500,
                              color: isUnread ? const Color(0xFF1E293B) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Bottom Status & Unread Badge Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Mutual Alliance Unlocked Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.diamond_outlined, size: 12, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text(
                                'Mutual Alliance Unlocked',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Trailing Unread Badge or Status text
                        if (unreadCount > 0) ...[
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF701A33),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ] else if (statusRight != null) ...[
                          Text(
                            statusRight,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
