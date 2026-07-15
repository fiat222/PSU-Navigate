import 'package:equatable/equatable.dart';

enum ShuttleStatus { onTime, delayed, full, arriving }

extension ShuttleStatusX on ShuttleStatus {
  String get label {
    switch (this) {
      case ShuttleStatus.onTime:
        return 'ตรงเวลา';
      case ShuttleStatus.delayed:
        return 'ดีเลย์';
      case ShuttleStatus.full:
        return 'เต็ม';
      case ShuttleStatus.arriving:
        return 'กำลังมา';
    }
  }
}

class ShuttleStop extends Equatable {
  const ShuttleStop({
    required this.name,
    required this.time,
    this.passed = false,
  });
  final String name;
  final String time;
  final bool passed;

  @override
  List<Object?> get props => [name, time, passed];
}

class ShuttleRoute extends Equatable {
  const ShuttleRoute({
    required this.id,
    required this.label,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.etaMinutes,
    required this.stops,
    required this.tags,
    required this.crowdedness,
    required this.status,
    this.cacheNote,
  });

  final String id;
  final String label;
  final int busNumber;
  final String from;
  final String to;
  final int etaMinutes;
  final List<ShuttleStop> stops;
  final List<String> tags;
  final double crowdedness;
  final ShuttleStatus status;
  final String? cacheNote;

  @override
  List<Object?> get props => [
    id,
    label,
    busNumber,
    from,
    to,
    etaMinutes,
    stops,
    tags,
    crowdedness,
    status,
    cacheNote,
  ];
}
