import 'package:flutter/material.dart';

import '../../models/comment_item.dart';
import '../../models/place_discussion.dart';

final List<CommentItem> _p1Comments = [
  CommentItem(
    initials: 'ภต',
    name: 'ภูริต',
    time: '5 นาทีที่แล้ว',
    text: 'ร้านข้าวแกงป้าพรแถวยาวมากก ใครหิวจัดแนะนำร้านอื่นเลย',
    likes: 12,
    replies: [
      CommentItem(
        initials: 'วจ',
        name: 'วิจิตร',
        time: '2 นาทีที่แล้ว',
        text: 'จริงครับ วันนี้คนแน่นเป็นพิเศษ',
        likes: 3,
        replies: const [],
      ),
    ],
  ),
  CommentItem(
    initials: 'อม',
    name: 'อามีน',
    time: '1 ชั่วโมงที่แล้ว',
    text: 'ร้านน้ำปั่นเปิดแล้วนะทุกคนน',
    likes: 8,
    replies: const [],
  ),
];

final List<CommentItem> _p2Comments = [
  CommentItem(
    initials: 'ปท',
    name: 'ปฐมพร',
    time: '30 นาทีที่แล้ว',
    text: 'โซนเงียบชั้น 3 แอร์เย็นมากครับ เตรียมเสื้อกันหนาวมาด้วย',
    likes: 24,
    replies: const [],
  ),
  CommentItem(
    initials: 'นภ',
    name: 'นภา',
    time: '2 ชั่วโมงที่แล้ว',
    text: 'ชั้น 1 ใกล้จะเต็มแล้ว แนะนำชั้น 4 ค่ะ',
    likes: 11,
    replies: const [],
  ),
];

final List<CommentItem> _p3Comments = [
  CommentItem(
    initials: 'ธน',
    name: 'ธนพล',
    time: 'เมื่อวาน',
    text: 'มีดนตรีสดทุกศุกร์ บรรยากาศดีมาก',
    likes: 15,
    replies: const [],
  ),
  CommentItem(
    initials: 'ปน',
    name: 'ปนัดดา',
    time: '3 วันที่แล้ว',
    text: 'ช่วงเย็นๆ นั่งชิลได้สบายเลย',
    likes: 9,
    replies: const [],
  ),
];

final List<CommentItem> _p4Comments = [
  CommentItem(
    initials: 'กฤ',
    name: 'กฤษณ์',
    time: '15 นาทีที่แล้ว',
    text: 'สนามหลังตึกวิศวกรรมคนเยอะช่วงเย็น เปิดถึง 21:00',
    likes: 7,
    replies: const [],
  ),
];

final List<PlaceDiscussion> mockPlaces = [
  PlaceDiscussion(
    id: 'p-001',
    name: 'โรงอาหารกลาง (ลานอิฐ)',
    subtitle: 'อาหารราคาถูก · เปิดอยู่ · คนหนาแน่นปานกลาง',
    icon: Icons.restaurant_outlined,
    ratingLabel: '4.8',
    statusLabel: 'คนเยอะมาก',
    comments: _p1Comments,
    category: PlaceCategory.food,
    tags: const ['food', 'cheap', 'busy'],
    popularityScore: 4.8,
    updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    rating: 4,
  ),
  PlaceDiscussion(
    id: 'p-002',
    name: 'ห้องสมุดคุณหญิงหลง',
    subtitle: 'ที่นั่งเยอะ · เปิดอยู่ · แอร์เย็นฉ่ำ',
    icon: Icons.menu_book_outlined,
    ratingLabel: '4.9',
    statusLabel: 'ที่นั่งว่างเยอะ',
    comments: _p2Comments,
    category: PlaceCategory.study,
    tags: const ['study', 'quiet', 'ac'],
    popularityScore: 4.9,
    updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    rating: 5,
  ),
  PlaceDiscussion(
    id: 'p-003',
    name: 'ลานกิจกรรมกลางคืน',
    subtitle: 'ดนตรีสดทุกศุกร์ · ปิด 22:00',
    icon: Icons.local_activity_outlined,
    ratingLabel: '4.4',
    statusLabel: 'เปิด 17:00',
    comments: _p3Comments,
    category: PlaceCategory.activity,
    tags: const ['activity', 'music', 'evening'],
    popularityScore: 4.4,
    updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
    rating: 4,
  ),
  PlaceDiscussion(
    id: 'p-004',
    name: 'สนามบาสเกตบอลหลังตึกวิศวกรรม',
    subtitle: 'เปิดทุกวัน 16:00-21:00',
    icon: Icons.sports_basketball_outlined,
    ratingLabel: '4.2',
    statusLabel: 'เปิด 16:00',
    comments: _p4Comments,
    category: PlaceCategory.sport,
    tags: const ['sport', 'evening', 'free'],
    popularityScore: 4.2,
    updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    rating: 4,
  ),
];
