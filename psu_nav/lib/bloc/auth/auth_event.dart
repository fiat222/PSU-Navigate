import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckSession extends AuthEvent {
  const CheckSession();
}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.studentId,
    required this.faculty,
  });
  final String email;
  final String password;
  final String fullName;
  final String studentId;
  final String faculty;

  @override
  List<Object?> get props => [email, password, fullName, studentId, faculty];
}

class ProfileUpdated extends AuthEvent {
  const ProfileUpdated({
    required this.fullName,
    required this.studentId,
    required this.faculty,
  });
  final String fullName;
  final String studentId;
  final String faculty;

  @override
  List<Object?> get props => [fullName, studentId, faculty];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthErrorShown extends AuthEvent {
  const AuthErrorShown();
}

class AuthToastShown extends AuthEvent {
  const AuthToastShown();
}
