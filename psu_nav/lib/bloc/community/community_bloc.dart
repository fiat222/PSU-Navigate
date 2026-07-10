import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/comment_item.dart';
import '../../models/place_discussion.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(CommunityState(places: _initialPlaces)) {
    on<SelectPlace>((event, emit) {
      final place = state.places[event.index];
      emit(state.copyWith(
        selectedPlace: place,
        toastMessage: 'เข้าสู่สถานที่: ${place.name}',
      ));
    });

    on<DeselectPlace>((event, emit) {
      emit(state.copyWith(clearSelectedPlace: true));
    });

    on<PostComment>((event, emit) {
      if (event.text.trim().isEmpty) {
        emit(state.copyWith(toastMessage: 'กรุณาพิมพ์ข้อความก่อนส่ง'));
        return;
      }
      if (state.selectedPlace == null) return;

      final updatedPlace = _addCommentToPlace(state.selectedPlace!, event.text);
      final updatedPlaces = state.places.map((p) {
        return p.name == updatedPlace.name ? updatedPlace : p;
      }).toList();

      emit(state.copyWith(
        places: updatedPlaces,
        selectedPlace: updatedPlace,
        toastMessage: 'ส่งคอมเมนต์สำเร็จ',
      ));
    });
  }

  PlaceDiscussion _addCommentToPlace(PlaceDiscussion place, String text) {
    final newComment = CommentItem(
      initials: 'ตค',
      name: 'ตัวคุณ',
      time: 'เมื่อสักครู่',
      text: text,
      likes: 0,
      replies: const [],
    );
    return PlaceDiscussion(
      name: place.name,
      subtitle: place.subtitle,
      icon: place.icon,
      ratingLabel: place.ratingLabel,
      statusLabel: place.statusLabel,
      comments: [newComment, ...place.comments],
    );
  }
}

final List<PlaceDiscussion> _initialPlaces = [
  PlaceDiscussion(
    name: 'โรงอาหารกลาง (ลานอิฐ)',
    subtitle: '1.2km · เปิดอยู่',
    icon: Icons.restaurant_outlined,
    ratingLabel: '4.8',
    statusLabel: 'คนเยอะมาก',
    comments: [
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
            replies: [],
          ),
        ],
      ),
      CommentItem(
        initials: 'อม',
        name: 'อามีน',
        time: '1 ชั่วโมงที่แล้ว',
        text: 'ร้านน้ำปั่นเปิดแล้วนะทุกคนน',
        likes: 8,
        replies: [],
      ),
    ],
  ),
  PlaceDiscussion(
    name: 'ห้องสมุดคุณหญิงหลง',
    subtitle: '500m · เปิดอยู่',
    icon: Icons.menu_book_outlined,
    ratingLabel: '4.9',
    statusLabel: 'ที่นั่งว่างเยอะ',
    comments: [
      CommentItem(
        initials: 'ปท',
        name: 'ปฐมพร',
        time: '30 นาทีที่แล้ว',
        text: 'โซนเงียบชั้น 3 แอร์เย็นมากครับ เตรียมเสื้อกันหนาวมาด้วย',
        likes: 24,
        replies: [],
      ),
    ],
  ),
];
