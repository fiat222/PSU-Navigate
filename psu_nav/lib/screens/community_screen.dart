part of '../main.dart';

class _CommunityScreen extends StatelessWidget {
  const _CommunityScreen({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityBloc(),
      child: _CommunityBody(desktop: desktop, onToast: onToast),
    );
  }
}

class _CommunityBody extends StatefulWidget {
  const _CommunityBody({required this.desktop, required this.onToast});

  final bool desktop;
  final ValueChanged<String> onToast;

  @override
  State<_CommunityBody> createState() => _CommunityBodyState();
}

class _CommunityBodyState extends State<_CommunityBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommunityBloc, CommunityState>(
      listenWhen: (prev, curr) => curr.toastMessage != prev.toastMessage && curr.toastMessage != null,
      listener: (context, state) {
        if (state.toastMessage != null) {
          widget.onToast(state.toastMessage!);
        }
      },
      child: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          final place = state.selectedPlace;

          if (place == null) {
            return _PlaceListView(
              places: state.places,
              onToast: widget.onToast,
            );
          }

          return _PlaceDetailView(
            place: place,
            desktop: widget.desktop,
            controller: _controller,
            onToast: widget.onToast,
          );
        },
      ),
    );
  }
}

class _PlaceListView extends StatelessWidget {
  const _PlaceListView({required this.places, required this.onToast});

  final List<PlaceDiscussion> places;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
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
                    onToast('ให้คะแนนสถานที่เมื่อเปิดหน้ารายละเอียด'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            itemCount: places.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == places.length) {
                return const _ModerationCard();
              }

              return _PlaceDiscussionCard(
                place: places[index],
                onTap: () => context.read<CommunityBloc>().add(SelectPlace(index)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlaceDetailView extends StatelessWidget {
  const _PlaceDetailView({
    required this.place,
    required this.desktop,
    required this.controller,
    required this.onToast,
  });

  final PlaceDiscussion place;
  final bool desktop;
  final TextEditingController controller;
  final ValueChanged<String> onToast;

  void _post(BuildContext context) {
    context.read<CommunityBloc>().add(PostComment(controller.text));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
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
          onLeading: () => context.read<CommunityBloc>().add(DeselectPlace()),
          trailing: Icons.star_border,
          onTrailing: () => onToast('ให้คะแนนสถานที่นี้ 5 ดาว'),
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
          child: ResponsiveList(desktop: desktop, children: children),
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
                    onToast('เลือกรูปได้สูงสุด 3 รูปต่อคอมเมนต์'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
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
                  onSubmitted: (_) => _post(context),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(icon: Icons.send_outlined, onTap: () => _post(context)),
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
                  child: CommentBubble(
                    initials: comment.initials,
                    name: comment.name,
                    time: comment.time,
                    text: comment.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
          CommentBubble(
            initials: comment.initials,
            name: comment.name,
            time: comment.time,
            text: comment.text,
            boxed: false,
            avatarGap: 10,
            metaStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
            textStyle: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.45,
            ),
            actions: [
              Text('ถูกใจ ${comment.likes}', style: _toolText),
              const Text('ตอบกลับ', style: _toolText),
              const Text('รายงาน', style: _toolText),
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
                      child: CommentBubble(
                        initials: reply.initials,
                        name: reply.name,
                        time: reply.time,
                        text: reply.text,
                        actions: [
                          Text('ถูกใจ ${reply.likes}', style: _toolText),
                          const Text('ตอบกลับ', style: _toolText),
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
