import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/app_colors.dart';
import '../app/app_theme.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../widgets/auth/edit_profile_modal.dart';
import '../widgets/common/responsive_list.dart';
import '../widgets/info_card.dart';
import '../widgets/right_pill.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.device, required this.onToast});

  final DeviceType device;
  final ValueChanged<String> onToast;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return Column(
          children: [
            Expanded(
              child: ResponsiveList(
                device: device,
                children: [
                  ProfileHeader(
                    onEdit: () {
                      if (user != null) {
                        EditProfileModal.show(context, user);
                      }
                    },
                    onLogout: () {
                      context.read<AuthBloc>().add(const LogoutRequested());
                    },
                  ),
                  InfoCard(
                    icon: Icons.notifications_outlined,
                    title: 'ตารางเรียนและกิจกรรม',
                    subtitle:
                        'ENG-302 เริ่ม 09:00 · เตือนในแอปและอีเมลก่อน 15 นาที',
                    trailing: IconButton(
                      onPressed: () =>
                          onToast('บันทึก notification preference แล้ว'),
                      icon: const Icon(Icons.settings_outlined, size: 18),
                    ),
                  ),
                  const InfoCard(
                    icon: Icons.cloud_done_outlined,
                    title: 'Offline cache',
                    subtitle:
                        'ตารางรถ, floor plan, place summary และรีวิวล่าสุดถูก cache ในเครื่อง',
                    trailing: RightPill('ready'),
                  ),
                  const InfoCard(
                    icon: Icons.lock_outline,
                    title: 'ความปลอดภัย',
                    subtitle:
                        'JWT session · mock SSO สำหรับ demo · ไม่มีการเก็บ password จริง',
                    trailing: RightPill('student'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.onEdit,
    required this.onLogout,
  });

  final VoidCallback onEdit;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final initials = user?.displayInitials ?? '?';
        final name = user?.fullName ?? 'ผู้ใช้งาน';
        final studentInfo = user == null
            ? '—'
            : '${user.studentId} · ${user.faculty}';
        final email = user?.email ?? '—';
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.campus,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.campus2, AppColors.deepBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          studentInfo,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .75),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .60),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _ProfileButton(
                      label: 'แก้ไขโปรไฟล์',
                      onTap: onEdit,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.campus,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ProfileButton(
                      label: 'ออกจากระบบ',
                      onTap: onLogout,
                      backgroundColor: Colors.white.withValues(alpha: .12),
                      foregroundColor: Colors.white,
                      borderColor: Colors.white.withValues(alpha: .30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: borderColor == null ? null : Border.all(color: borderColor!),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: foregroundColor,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
