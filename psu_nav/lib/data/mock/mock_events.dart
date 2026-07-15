import 'package:flutter/material.dart';

import '../../models/event_item.dart';

final List<EventItem> mockEvents = [
  EventItem(
    id: 'evt-001',
    title: 'Hackathon: Smart Campus',
    subtitle: 'กิจกรรมจริง · ปักหมุดที่วิศวกรรม 1 · หมดเวลาโพสต์ 18:00',
    kind: EventKind.official,
    pillLabel: 'เข้าร่วม',
    icon: Icons.event_outlined,
    tags: const ['official', 'hackathon', 'tech'],
    startsAt: DateTime.now().add(const Duration(hours: 3)),
    popularityScore: 4.9,
    interestedCount: 124,
  ),
  EventItem(
    id: 'evt-002',
    title: 'หาเพื่อนไปกินข้าวเที่ยง',
    subtitle: 'Plan mode · รอคนสนใจ 4/6 · ถ้าหมดเวลาจะเก็บไว้ 2 ชม. แล้วลบ',
    kind: EventKind.plan,
    actionLabel: 'สนใจ',
    icon: Icons.groups_outlined,
    tags: const ['plan', 'food', 'lunch'],
    startsAt: DateTime.now().add(const Duration(hours: 2)),
    popularityScore: 4.2,
    interestedCount: 4,
  ),
  EventItem(
    id: 'evt-003',
    title: 'สุ่มหาเพื่อนแชทชั่วคราว',
    subtitle: 'จับคู่จากผู้ใช้ online ใน campus · แชทจะลบหลังออกครบ 5 นาที',
    kind: EventKind.activity,
    actionLabel: 'สุ่ม',
    icon: Icons.chat_bubble_outline,
    tags: const ['activity', 'chat', 'random'],
    startsAt: DateTime.now().add(const Duration(minutes: 30)),
    popularityScore: 4.5,
    interestedCount: 87,
  ),
  EventItem(
    id: 'evt-004',
    title: 'เปิดรับสมัครชมรมถ่ายภาพ',
    subtitle: 'Official · ประชุมครั้งแรก 17:00 · ไม่มีค่าใช้จ่าย',
    kind: EventKind.official,
    pillLabel: 'สมัคร',
    icon: Icons.photo_camera_outlined,
    tags: const ['official', 'club', 'photo'],
    startsAt: DateTime.now().add(const Duration(days: 2)),
    popularityScore: 4.3,
    interestedCount: 56,
  ),
];
