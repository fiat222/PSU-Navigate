import 'package:equatable/equatable.dart';

import '../../models/place_discussion.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlaces extends CommunityEvent {
  const LoadPlaces();
}

class ChangeSegment extends CommunityEvent {
  const ChangeSegment(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}

class ChangeDetailSegment extends CommunityEvent {
  const ChangeDetailSegment(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}

class SearchPlaces extends CommunityEvent {
  const SearchPlaces(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

class ChangeCategoryFilter extends CommunityEvent {
  const ChangeCategoryFilter(this.category);
  final PlaceCategory? category;

  @override
  List<Object?> get props => [category];
}

class SelectPlace extends CommunityEvent {
  const SelectPlace(this.placeId);
  final String placeId;

  @override
  List<Object?> get props => [placeId];
}

class DeselectPlace extends CommunityEvent {
  const DeselectPlace();
}

class PostComment extends CommunityEvent {
  const PostComment(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

class ToastShown extends CommunityEvent {
  const ToastShown();
}

class ClearCommunityError extends CommunityEvent {
  const ClearCommunityError();
}
