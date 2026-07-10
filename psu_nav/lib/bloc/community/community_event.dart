abstract class CommunityEvent {}

class SelectPlace extends CommunityEvent {
  final int index;
  SelectPlace(this.index);
}

class DeselectPlace extends CommunityEvent {}

class PostComment extends CommunityEvent {
  final String text;
  PostComment(this.text);
}
