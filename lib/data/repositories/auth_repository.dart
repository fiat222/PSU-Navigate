import '../../models/user_profile.dart';

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

class AuthSession {
  const AuthSession({required this.user, required this.token});
  final UserProfile user;
  final String token;
}

abstract class AuthRepository {
  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> register({
    required String email,
    required String password,
    required String fullName,
    required String studentId,
    required String faculty,
  });

  Future<UserProfile> updateProfile({
    required String fullName,
    required String studentId,
    required String faculty,
  });

  Future<void> logout();
}
