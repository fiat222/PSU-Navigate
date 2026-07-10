import 'package:flutter/material.dart';

import 'comment_item.dart';

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
