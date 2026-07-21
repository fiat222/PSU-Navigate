import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'comment_item.dart';

enum PlaceCategory { food, study, activity, sport, service }

extension PlaceCategoryX on PlaceCategory {
  String get label {
    switch (this) {
      case PlaceCategory.food:
        return 'อาหาร';
      case PlaceCategory.study:
        return 'ที่นั่ง';
      case PlaceCategory.activity:
        return 'กิจกรรม';
      case PlaceCategory.sport:
        return 'กีฬา';
      case PlaceCategory.service:
        return 'บริการ';
    }
  }

  IconData get icon {
    switch (this) {
      case PlaceCategory.food:
        return Icons.restaurant_outlined;
      case PlaceCategory.study:
        return Icons.menu_book_outlined;
      case PlaceCategory.activity:
        return Icons.local_activity_outlined;
      case PlaceCategory.sport:
        return Icons.sports_basketball_outlined;
      case PlaceCategory.service:
        return Icons.local_cafe_outlined;
    }
  }
}

class PlaceDiscussion extends Equatable {
  const PlaceDiscussion({
    required this.id,
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.ratingLabel,
    required this.statusLabel,
    required this.comments,
    required this.category,
    required this.tags,
    required this.popularityScore,
    required this.updatedAt,
    this.rating = 4,
  });

  final String id;
  final IconData icon;
  final String name;
  final String subtitle;
  final String ratingLabel;
  final String statusLabel;
  final List<CommentItem> comments;
  final PlaceCategory category;
  final List<String> tags;
  final double popularityScore;
  final DateTime updatedAt;
  final int rating;

  int get totalComments {
    var total = comments.length;
    for (final c in comments) {
      total += c.replies.length;
    }
    return total;
  }

  PlaceDiscussion copyWith({
    String? id,
    IconData? icon,
    String? name,
    String? subtitle,
    String? ratingLabel,
    String? statusLabel,
    List<CommentItem>? comments,
    PlaceCategory? category,
    List<String>? tags,
    double? popularityScore,
    DateTime? updatedAt,
    int? rating,
  }) {
    return PlaceDiscussion(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      ratingLabel: ratingLabel ?? this.ratingLabel,
      statusLabel: statusLabel ?? this.statusLabel,
      comments: comments ?? this.comments,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      popularityScore: popularityScore ?? this.popularityScore,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
    id,
    icon,
    name,
    subtitle,
    ratingLabel,
    statusLabel,
    comments,
    category,
    tags,
    popularityScore,
    updatedAt,
    rating,
  ];
}
