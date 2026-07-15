import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndoorRoom extends Equatable {
  const IndoorRoom({
    required this.code,
    required this.title,
    required this.seats,
    required this.facilities,
    required this.openHours,
    required this.rating,
    required this.floor,
  });

  final String code;
  final String title;
  final String seats;
  final String facilities;
  final String openHours;
  final String rating;
  final int floor;

  @override
  List<Object?> get props =>
      [code, title, seats, facilities, openHours, rating, floor];
}

const List<IndoorRoom> kIndoorRooms = [
  IndoorRoom(
    code: 'ENG-301',
    title: 'ห้องบรรยาย 301',
    seats: '80 ที่นั่ง',
    facilities: 'Projector + AC',
    openHours: '08:00-17:00',
    rating: 'rating 4.4',
    floor: 3,
  ),
  IndoorRoom(
    code: 'ENG-302',
    title: 'ห้องบรรยายรวม 302',
    seats: '120 ที่นั่ง',
    facilities: 'Projector + AC + Mic',
    openHours: '08:00-17:00',
    rating: 'rating 4.6',
    floor: 3,
  ),
  IndoorRoom(
    code: 'ENG-LAB1',
    title: 'ห้องแล็บคอมพิวเตอร์',
    seats: '40 ที่นั่ง',
    facilities: 'PC 40 เครื่อง',
    openHours: '09:00-20:00',
    rating: 'rating 4.2',
    floor: 3,
  ),
  IndoorRoom(
    code: 'ENG-TOILET',
    title: 'ห้องน้ำชาย/หญิง',
    seats: '—',
    facilities: '—',
    openHours: 'ตลอด 24 ชม.',
    rating: '—',
    floor: 3,
  ),
  IndoorRoom(
    code: 'ENG-LIFT',
    title: 'ลิฟต์',
    seats: '—',
    facilities: 'รองรับวีลแชร์',
    openHours: 'ตลอด 24 ชม.',
    rating: '—',
    floor: 3,
  ),
  IndoorRoom(
    code: 'ENG-STAIR',
    title: 'บันได',
    seats: '—',
    facilities: 'ทางหนีไฟ',
    openHours: 'ตลอด 24 ชม.',
    rating: '—',
    floor: 3,
  ),
];

class IndoorState extends Equatable {
  const IndoorState({
    this.floor = 3,
    this.selectedCode = 'ENG-302',
  });

  final int floor;
  final String selectedCode;

  IndoorRoom? get selectedRoom {
    for (final r in kIndoorRooms) {
      if (r.code == selectedCode) return r;
    }
    return null;
  }

  IndoorState copyWith({int? floor, String? selectedCode}) {
    return IndoorState(
      floor: floor ?? this.floor,
      selectedCode: selectedCode ?? this.selectedCode,
    );
  }

  @override
  List<Object?> get props => [floor, selectedCode];
}

abstract class IndoorEvent extends Equatable {
  const IndoorEvent();
  @override
  List<Object?> get props => [];
}

class ChangeFloor extends IndoorEvent {
  const ChangeFloor(this.floor);
  final int floor;
  @override
  List<Object?> get props => [floor];
}

class SelectRoom extends IndoorEvent {
  const SelectRoom(this.code);
  final String code;
  @override
  List<Object?> get props => [code];
}

class IndoorBloc extends Bloc<IndoorEvent, IndoorState> {
  IndoorBloc() : super(const IndoorState()) {
    on<ChangeFloor>((e, emit) => emit(state.copyWith(floor: e.floor)));
    on<SelectRoom>((e, emit) => emit(state.copyWith(selectedCode: e.code)));
  }
}
