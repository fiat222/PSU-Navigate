import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    required this.studentId,
    required this.faculty,
    this.initials = '',
  });

  final String id;
  final String email;
  final String fullName;
  final String studentId;
  final String faculty;
  final String initials;

  String get displayInitials {
    if (initials.isNotEmpty) return initials;
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1);
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}';
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? studentId,
    String? faculty,
    String? initials,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      faculty: faculty ?? this.faculty,
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    studentId,
    faculty,
    initials,
  ];
}
