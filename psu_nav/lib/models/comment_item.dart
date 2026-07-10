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
