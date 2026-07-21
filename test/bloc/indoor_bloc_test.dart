import 'package:flutter_test/flutter_test.dart';
import 'package:psu_nav/bloc/indoor/indoor_bloc.dart';

void main() {
  test('room search selects matching room and floor', () async {
    final bloc = IndoorBloc();
    addTearDown(bloc.close);

    bloc.add(const ChangeFloor(1));
    await bloc.stream.firstWhere((state) => state.floor == 1);
    bloc.add(const SearchRoomRequested('eng-301'));

    final state = await bloc.stream.firstWhere(
      (state) => state.selectedCode == 'ENG-301',
    );
    expect(state.floor, 3);
    expect(state.selectedCode, 'ENG-301');
    expect(state.searchFeedback, contains('ENG-301'));
  });

  test('unknown room search preserves current selection', () async {
    final bloc = IndoorBloc();
    addTearDown(bloc.close);
    final initial = bloc.state;

    bloc.add(const SearchRoomRequested('UNKNOWN'));

    final state = await bloc.stream.first;
    expect(state.floor, initial.floor);
    expect(state.selectedCode, initial.selectedCode);
    expect(state.searchFeedback, 'ไม่พบในข้อมูลตัวอย่าง');
  });
}
