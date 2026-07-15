import '../../models/user_profile.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({Duration? delay})
    : _delay = delay ?? const Duration(milliseconds: 700);

  final Duration _delay;

  UserProfile? _current;
  final Map<String, _StoredAccount> _accounts = {
    'thanapon@email.psu.ac.th': const _StoredAccount(
      user: UserProfile(
        id: 'u-001',
        email: 'thanapon@email.psu.ac.th',
        fullName: 'ธนพล สันพิทักษ์',
        studentId: '6510110xxx',
        faculty: 'คณะวิศวกรรมศาสตร์',
        initials: 'ธน',
      ),
      password: 'psu1234',
    ),
  };

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_delay);
    final normalized = email.trim().toLowerCase();
    final account = _accounts[normalized];
    if (account == null) {
      throw const AuthFailure('ไม่พบบัญชีผู้ใช้นี้ในระบบ');
    }
    if (account.password != password) {
      throw const AuthFailure('รหัสผ่านไม่ถูกต้อง');
    }
    _current = account.user;
    return AuthSession(
      user: account.user,
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
    required String faculty,
  }) async {
    await Future<void>.delayed(_delay);
    final normalized = email.trim().toLowerCase();
    if (_accounts.containsKey(normalized)) {
      throw const AuthFailure('อีเมลนี้ถูกใช้แล้ว');
    }
    final user = UserProfile(
      id: 'u-${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      fullName: fullName.trim(),
      studentId: studentId.trim(),
      faculty: faculty,
    );
    _accounts[normalized] = _StoredAccount(user: user, password: password);
    _current = user;
    return AuthSession(
      user: user,
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<UserProfile> updateProfile({
    required String fullName,
    required String studentId,
    required String faculty,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final current = _current;
    if (current == null) {
      throw const AuthFailure('กรุณาเข้าสู่ระบบก่อน');
    }
    final updated = current.copyWith(
      fullName: fullName.trim(),
      studentId: studentId.trim(),
      faculty: faculty,
    );
    _current = updated;
    _accounts[updated.email.toLowerCase()] = _StoredAccount(
      user: updated,
      password: 'psu1234',
    );
    return updated;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _current = null;
  }
}

class _StoredAccount {
  const _StoredAccount({required this.user, required this.password});
  final UserProfile user;
  final String password;
}
