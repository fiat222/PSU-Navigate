import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum EventKind { official, plan, activity }

extension EventKindX on EventKind {
  String get label {
    switch (this) {
      case EventKind.official:
        return 'กิจกรรมทางการ';
      case EventKind.plan:
        return 'Plan';
      case EventKind.activity:
        return 'Activity';
    }
  }
}

class EventItem extends Equatable {
  const EventItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.tags,
    required this.startsAt,
    required this.popularityScore,
    required this.interestedCount,
    this.icon,
    this.pillLabel,
    this.actionLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData? icon;
  final EventKind kind;
  final List<String> tags;
  final DateTime startsAt;
  final double popularityScore;
  final int interestedCount;
  final String? pillLabel;
  final String? actionLabel;

  bool get isToday {
    final now = DateTime.now();
    return startsAt.year == now.year &&
        startsAt.month == now.month &&
        startsAt.day == now.day;
  }

  bool isThisWeek(DateTime reference) {
    final now = reference;
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return startsAt.isAfter(start.subtract(const Duration(seconds: 1))) &&
        startsAt.isBefore(end);
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    icon,
    kind,
    tags,
    startsAt,
    popularityScore,
    interestedCount,
    pillLabel,
    actionLabel,
  ];
}
