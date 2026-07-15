import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repo}) : super(const AuthState()) {
    on<CheckSession>(_onCheck);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<ProfileUpdated>(_onUpdateProfile);
    on<LogoutRequested>(_onLogout);
    on<AuthErrorShown>((e, emit) {
      emit(state.copyWith(clearError: true));
    });
    on<AuthToastShown>((e, emit) {
      emit(state.copyWith(toastMessage: null));
    });
  }

  final AuthRepository repo;

  Future<void> _onCheck(CheckSession e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onLogin(LoginRequested e, Emitter<AuthState> emit) async {
    if (state.submitting) return;
    emit(
      state.copyWith(
        status: AuthStatus.authenticating,
        submitting: true,
        clearError: true,
      ),
    );
    try {
      final session = await repo.login(email: e.email, password: e.password);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: session.user,
          token: session.token,
          submitting: false,
          toastMessage:
              'เข้าสู่ระบบสำเร็จ ยินดีต้อนรับ ${session.user.fullName}',
        ),
      );
    } on AuthFailure catch (err) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          submitting: false,
          errorMessage: err.message,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          submitting: false,
          errorMessage: 'ไม่สามารถเข้าสู่ระบบได้: $err',
        ),
      );
    }
  }

  Future<void> _onRegister(RegisterRequested e, Emitter<AuthState> emit) async {
    if (state.submitting) return;
    emit(
      state.copyWith(
        status: AuthStatus.authenticating,
        submitting: true,
        clearError: true,
      ),
    );
    try {
      final session = await repo.register(
        email: e.email,
        password: e.password,
        fullName: e.fullName,
        studentId: e.studentId,
        faculty: e.faculty,
      );
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: session.user,
          token: session.token,
          submitting: false,
          toastMessage:
              'สมัครสมาชิกสำเร็จ ยินดีต้อนรับ ${session.user.fullName}',
        ),
      );
    } on AuthFailure catch (err) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          submitting: false,
          errorMessage: err.message,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          submitting: false,
          errorMessage: 'สมัครสมาชิกไม่สำเร็จ: $err',
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    ProfileUpdated e,
    Emitter<AuthState> emit,
  ) async {
    if (state.submitting) return;
    emit(state.copyWith(submitting: true, clearError: true));
    try {
      final updated = await repo.updateProfile(
        fullName: e.fullName,
        studentId: e.studentId,
        faculty: e.faculty,
      );
      emit(
        state.copyWith(
          user: updated,
          submitting: false,
          toastMessage: 'บันทึกข้อมูลโปรไฟล์เรียบร้อย',
        ),
      );
    } on AuthFailure catch (err) {
      emit(state.copyWith(submitting: false, errorMessage: err.message));
    } catch (err) {
      emit(
        state.copyWith(
          submitting: false,
          errorMessage: 'ไม่สามารถบันทึกโปรไฟล์ได้: $err',
        ),
      );
    }
  }

  Future<void> _onLogout(LogoutRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(submitting: true));
    await repo.logout();
    emit(
      const AuthState(
        status: AuthStatus.unauthenticated,
        toastMessage: 'ออกจากระบบเรียบร้อย',
      ),
    );
  }
}
