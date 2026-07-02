part of '../main.dart';

class _CommunityScreen extends StatefulWidget {
  const _CommunityScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  State<_CommunityScreen> createState() => _CommunityScreenState();
}

class CommentItem {
  const CommentItem({
    required this.initials,
    required this.name,
    required this.text,
    this.time = 'เมื่อสักครู่',
    this.likes = 0,
    this.replies = const [],
  });

  final String initials;
  final String name;
  final String text;
  final String time;
  final int likes;
  final List<CommentItem> replies;
}

class PlaceDiscussion {
  PlaceDiscussion({
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.ratingLabel,
    required this.statusLabel,
    required this.comments,
    this.rating = 4,
  });

  final IconData icon;
  final String name;
  final String subtitle;
  final String ratingLabel;
  final String statusLabel;
  final List<CommentItem> comments;
  final int rating;
}

class _CommunityScreenState extends State<_CommunityScreen> {
  final TextEditingController _controller = TextEditingController();
  int? _selectedPlaceIndex;
  late final List<PlaceDiscussion> _places = [
    PlaceDiscussion(
      icon: Icons.restaurant_outlined,
      name: 'โรงอาหารกลาง',
      subtitle: '4.2 ดาว · เปิดอยู่ · คนหนาแน่นปานกลางจาก user online',
      ratingLabel: '128 รีวิว',
      statusLabel: 'เปิดอยู่',
      rating: 4,
      comments: [
        const CommentItem(
          initials: 'นศ',
          name: 'นศ.ปี 1',
          text: 'ตอนเที่ยงแถวร้านข้าวมันไก่สั้นสุด มีโต๊ะว่างฝั่งซ้าย',
          time: '5 นาทีที่แล้ว',
          likes: 18,
          replies: [
            CommentItem(
              initials: 'จน',
              name: 'เจน',
              text: 'จริง วันนี้ฝั่งซ้ายโล่งกว่า',
              time: '2 นาทีที่แล้ว',
              likes: 3,
            ),
            CommentItem(
              initials: 'มข',
              name: 'มิ้น',
              text: 'ขอบคุณมาก เดี๋ยวแวะไปตรงนั้นเลย',
              time: 'เมื่อสักครู่',
              likes: 1,
            ),
          ],
        ),
      ],
    ),
    PlaceDiscussion(
      icon: Icons.local_library_outlined,
      name: 'ห้องสมุดกลาง',
      subtitle: '4.7 ดาว · เงียบ · ปลั๊กว่างชั้น 2',
      ratingLabel: '64 รีวิว',
      statusLabel: 'เปิดอยู่',
      rating: 5,
      comments: const [
        CommentItem(
          initials: 'อศ',
          name: 'ออย',
          text: 'ชั้น 2 ฝั่งหน้าต่างเงียบมาก เหมาะกับอ่านหนังสือยาวๆ',
          time: '12 นาทีที่แล้ว',
          likes: 11,
        ),
      ],
    ),
    PlaceDiscussion(
      icon: Icons.wc_outlined,
      name: 'ห้องน้ำอาคาร 15',
      subtitle: '3.9 ดาว · ทำความสะอาดล่าสุด 09:20',
      ratingLabel: '22 รีวิว',
      statusLabel: 'ตรวจล่าสุด',
      rating: 4,
      comments: const [
        CommentItem(
          initials: 'ปท',
          name: 'ปาล์ม',
          text: 'ฝั่งขวาสะอาดกว่า และมีทิชชู่ครบ',
          time: '28 นาทีที่แล้ว',
          likes: 6,
        ),
      ],
    ),
  ];

  PlaceDiscussion? get _selectedPlace =>
      _selectedPlaceIndex == null ? null : _places[_selectedPlaceIndex!];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _post() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      widget.onToast('พิมพ์คอมเมนต์ก่อนส่ง');
      return;
    }
    final place = _selectedPlace;
    if (place == null) {
      widget.onToast('เลือกสถานที่ก่อนส่งคอมเมนต์');
      return;
    }
    setState(() {
      place.comments.insert(
        0,
        CommentItem(initials: 'คุณ', name: 'คุณ', text: text, likes: 0),
      );
      _controller.clear();
    });
    widget.onToast('คอมเมนต์ใหม่แสดงทันทีผ่าน live feed');
  }

  @override
  Widget build(BuildContext context) {
    final place = _selectedPlace;

    if (place == null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Segmented(
                    labels: const ['สถานที่', 'ยอดนิยม', 'ล่าสุด'],
                    selected: 0,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icons.star_border,
                  onTap: () =>
                      widget.onToast('ให้คะแนนสถานที่เมื่อเปิดหน้ารายละเอียด'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              itemCount: _places.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == _places.length) {
                  return const _ModerationCard();
                }

                return _PlaceDiscussionCard(
                  place: _places[index],
                  onTap: () => setState(() => _selectedPlaceIndex = index),
                );
              },
            ),
          ),
        ],
      );
    }

    final children = [
      InfoCard(
        icon: place.icon,
        title: place.name,
        subtitle: place.subtitle,
        trailing: RightPill(place.ratingLabel),
      ),
      for (final comment in place.comments) _CommentCard(comment: comment),
      const _ModerationCard(),
    ];

    return Column(
      children: [
        SearchRow(
          value: place.name,
          leading: Icons.arrow_back,
          onLeading: () => setState(() => _selectedPlaceIndex = null),
          trailing: Icons.star_border,
          onTrailing: () => widget.onToast('ให้คะแนนสถานที่นี้ 5 ดาว'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Segmented(
                  labels: const ['ล่าสุด', 'ยอดนิยม', 'รูปภาพ'],
                  selected: 0,
                ),
              ),
              const SizedBox(width: 10),
              StatusChip(place.statusLabel),
            ],
          ),
        ),
        Expanded(
          child: ResponsiveList(desktop: widget.desktop, children: children),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icons.image_outlined,
                onTap: () =>
                    widget.onToast('เลือกรูปได้สูงสุด 3 รูปต่อคอมเมนต์'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'แชร์ข้อมูลสถานที่นี้...',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                  ),
                  onSubmitted: (_) => _post(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(icon: Icons.send_outlined, onTap: _post),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceDiscussionCard extends StatelessWidget {
  const _PlaceDiscussionCard({required this.place, required this.onTap});

  final PlaceDiscussion place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final previewComments = place.comments.take(2).toList();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MiniIcon(place.icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFF3B443),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              place.subtitle,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RightPill(place.ratingLabel),
                    const SizedBox(height: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.muted,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            if (previewComments.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'รีวิวล่าสุด',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              for (final comment in previewComments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar(comment.initials),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${comment.name} · ${comment.time}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment});

  final CommentItem comment;

  @override
  Widget build(BuildContext context) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(comment.initials),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${comment.name} · ${comment.time}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        Text('ถูกใจ ${comment.likes}', style: _toolText),
                        const Text('ตอบกลับ', style: _toolText),
                        const Text('รายงาน', style: _toolText),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(
                children: [
                  for (final reply in comment.replies)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Avatar(reply.initials),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F8FC),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${reply.name} · ${reply.time}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    reply.text,
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 11,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 12,
                                    children: [
                                      Text(
                                        'ถูกใจ ${reply.likes}',
                                        style: _toolText,
                                      ),
                                      const Text('ตอบกลับ', style: _toolText),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ModerationCard extends StatelessWidget {
  const _ModerationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F6),
        border: Border.all(color: AppColors.alert.withValues(alpha: .32)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar('--'),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ระบบตรวจจับ',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'คอมเมนต์หนึ่งถูกซ่อนชั่วคราว เพราะ dislike/report สูงผิดปกติ รอ admin ตรวจสอบ',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    Text('auto moderation', style: _toolText),
                    Text('WebSocket update', style: _toolText),
                  ],
                ),
              ],
            ),
          ),
          RightPill('hidden', alert: true),
        ],
      ),
    );
  }
}

const _toolText = TextStyle(color: AppColors.muted, fontSize: 11);
