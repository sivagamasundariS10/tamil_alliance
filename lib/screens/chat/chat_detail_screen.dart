import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String handle;
  final String name;
  final String allianceId;
  final String profession;
  final String avatarAsset;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.handle,
    required this.name,
    this.allianceId = 'Alliance ID - TA889123',
    required this.profession,
    required this.avatarAsset,
    this.isOnline = true,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        'isMe': false,
        'hasRichText': true,
        'prefix': 'Vanakkam! My parents and I reviewed your daughter\'s profile and Jathagam. The 10 Poruthams show an ',
        'highlight': 'Uthama match (92%)',
        'suffix': ', especially with Raasi and Dina porutham in complete harmony. We would love to share our family astrologer\'s certified chart.',
        'time': '06:34 PM',
      },
      {
        'isMe': true,
        'hasRichText': false,
        'text': 'Vanakkam ${widget.name.split(' ').first}. Glad to connect. We are sharing our daughter\'s detailed 12-house natal chart and family biodata for your elders\' perusal.',
        'time': '06:42 PM',
      },
      {
        'isMe': false,
        'hasRichText': false,
        'text': 'My father Mr. R. Sundaresan would be glad to speak with your family over our masked secure call line tomorrow morning between 9:00 AM and 10:30 AM.',
        'time': '07:05 PM',
      },
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    print('====================================================');
    print('💬 [USER ACTION: SENT CHAT MESSAGE]');
    print('   Recipient  : ${widget.name} (${widget.allianceId})');
    print('   Handle     : ${widget.handle}');
    print('   Message    : "$text"');
    print('   Time       : ${DateTime.now().hour}:${DateTime.now().minute}');
    print('====================================================');

    setState(() {
      _messages.add({
        'isMe': true,
        'hasRichText': false,
        'text': text,
        'time': 'Just now',
      });
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleInstantReport() {
    print('====================================================');
    print('🚩 [USER ACTION: INSTANT REPORT SUBMITTED]');
    print('   Reported Candidate : ${widget.name}');
    print('   Alliance ID        : ${widget.allianceId}');
    print('   Reason Category    : Suspicious / Dowry / Misconduct');
    print('   Status             : Flagged for Sacred Trust Review ✓');
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
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.outlined_flag_rounded, color: Color(0xFFDC2626), size: 30),
              ),
              const SizedBox(height: 14),
              const Text(
                'Instant Safety Report',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Report submitted for ${widget.name} (${widget.allianceId}). Our Trust & Safety team will review this chat within 15 minutes.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.35),
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
                  child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSilentBlock() {
    print('====================================================');
    print('🚫 [USER ACTION: SILENT BLOCK EXECUTED]');
    print('   Blocked Candidate : ${widget.name}');
    print('   Alliance ID       : ${widget.allianceId}');
    print('   Status            : Communication Severed without alert ✓');
    print('====================================================');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.block_rounded, color: Color(0xFFEF4444), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.name} has been silently blocked. No alerts were sent.',
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

  void _handleSosDesk() {
    print('====================================================');
    print('🚨 [USER ACTION: 24x7 SOS DESK ESCALATION]');
    print('   Escalating User   : Sivagamasundari S');
    print('   Candidate In Chat : ${widget.name} (${widget.allianceId})');
    print('   SLA Target        : Under 15 Minutes Priority Review ✓');
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
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emergency_rounded, color: Color(0xFF701A33), size: 30),
              ),
              const SizedBox(height: 14),
              const Text(
                '24x7 Family SOS Escalation',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your request has been prioritized under SLA < 15 min review. A dedicated relationship counselor is assigned to assist your family.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.35),
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
                  child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w800)),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF701A33),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF4C0B1E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Color(0xFFF5D68B),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    widget.allianceId,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.white,
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
              offset: const Offset(0, 48),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              onSelected: (value) {
                if (value == 'report') {
                  _handleInstantReport();
                } else if (value == 'block') {
                  _handleSilentBlock();
                } else if (value == 'sos') {
                  _handleSosDesk();
                }
              },
              itemBuilder: (BuildContext ctx) => [
                // 1. Instant Report
                PopupMenuItem<String>(
                  value: 'report',
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.outlined_flag_rounded, color: Color(0xFFDC2626), size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Instant Report',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Silent Block
                PopupMenuItem<String>(
                  value: 'block',
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.block_rounded, color: Color(0xFF475569), size: 19),
                        SizedBox(width: 10),
                        Text(
                          'Silent Block',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. 24x7 SOS Desk
                PopupMenuItem<String>(
                  value: 'sos',
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.emergency_rounded, color: Color(0xFF701A33), size: 20),
                        SizedBox(width: 10),
                        Text(
                          '24x7 SOS Desk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
              children: [
                // 1. Top Mutual Interest Verification Card
                _buildVerificationCard(),
                const SizedBox(height: 20),

                // 2. Chat Messages
                ..._messages.map((msg) => _buildMessageItem(msg)),
              ],
            ),
          ),

          // 3. Bottom Input Bar with DRM Privacy Disclaimer
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. Top Mutual Interest Verification Card
  // ─────────────────────────────────────────────────────────────
  Widget _buildVerificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
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
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF701A33),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mutual Interest Accepted • Oct 14',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF701A33),
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description Text
          const Text(
            'Direct Chat & Verified Astrological Exchange unlocked. Both families verified via Aadhaar OTP. Protected under Sacred Privacy Charter with 256-bit encryption.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),

          // Badges Row
          Row(
            children: [
              // Badge 1: ID Certified
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.verified_rounded, size: 12, color: Color(0xFFBE123C)),
                    SizedBox(width: 4),
                    Text(
                      'ID Certified',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Badge 2: Zero Data Leakage
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.lock_rounded, size: 12, color: Color(0xFFB45309)),
                    SizedBox(width: 4),
                    Text(
                      'Zero Data Leakage',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. Chat Message Bubble
  // ─────────────────────────────────────────────────────────────
  Widget _buildMessageItem(Map<String, dynamic> msg) {
    final bool isMe = msg['isMe'] as bool;
    final bool hasRichText = msg['hasRichText'] as bool? ?? false;
    final String time = msg['time'] as String;

    if (isMe) {
      // Outgoing Message (Maroon bubble right aligned)
      return Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.76,
                ),
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: Color(0xFF701A33),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      msg['text'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.done_all_rounded, size: 13, color: Color(0xFF34D399)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Incoming Message (White bubble left aligned with candidate avatar)
      return Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular Avatar Icon
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => const Icon(
                    Icons.favorite,
                    size: 16,
                    color: Color(0xFFBE123C),
                  ),
                ),
              ),
            ),

            // Message Bubble
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.74,
                ),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasRichText) ...[
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: msg['prefix'] as String),
                            TextSpan(
                              text: msg['highlight'] as String,
                              style: const TextStyle(
                                color: Color(0xFF701A33),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(text: msg['suffix'] as String),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        msg['text'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                          height: 1.4,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.done_all_rounded, size: 13, color: Color(0xFF94A3B8)),
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
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 3. Bottom Input Bar with DRM Privacy Disclaimer
  // ─────────────────────────────────────────────────────────────
  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a respectful message.....',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Maroon Send Button
                InkWell(
                  onTap: _sendMessage,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFF701A33),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.near_me_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // DRM Privacy Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_outline_rounded, size: 11, color: Color(0xFF64748B)),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'DRM Watermark Active • Screenshot & Screen Recording Blocked for Dignity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
