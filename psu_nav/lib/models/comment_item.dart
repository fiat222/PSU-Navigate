import 'package:equatable/equatable.dart';

class CommentItem extends Equatable {
  const CommentItem({
    required this.id,
    required this.initials,
    required this.name,
    required this.text,
    this.time = 'เมื่อสักครู่',
    this.likes = 0,
    this.replies = const [],
  });

  final String id;
  final String initials;
  final String name;
  final String text;
  final String time;
  final int likes;
  final List<CommentItem> replies;

  CommentItem copyWith({
    String? id,
    String? initials,
    String? name,
    String? text,
    String? time,
    int? likes,
    List<CommentItem>? replies,
  }) {
    return CommentItem(
      id: id ?? this.id,
      initials: initials ?? this.initials,
      name: name ?? this.name,
      text: text ?? this.text,
      time: time ?? this.time,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
    );
  }

  @override
  List<Object?> get props => [id, initials, name, text, time, likes, replies];
}
