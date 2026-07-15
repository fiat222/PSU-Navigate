import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../models/place_discussion.dart';
import '../../models/user_profile.dart';
import 'auth_form_fields.dart';
import 'faculty_picker.dart';
import 'profile_avatar.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.user});

  final UserProfile user;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _studentIdCtrl;
  PlaceCategory? _faculty;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName);
    _studentIdCtrl = TextEditingController(text: widget.user.studentId);
    _faculty = _facultyFromName(widget.user.faculty);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _studentIdCtrl.dispose();
    super.dispose();
  }

  PlaceCategory? _facultyFromName(String name) {
    for (final c in PlaceCategory.values) {
      if (c.label == name) return c;
    }
    return null;
  }

  void _submit(BuildContext context) {
    if (_faculty == null) {
      setState(() => _localError = 'กรุณาเลือกคณะ');
      return;
    }
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _localError = 'กรุณากรอกชื่อ-นามสกุล');
      return;
    }
    setState(() => _localError = null);
    context.read<AuthBloc>().add(
      ProfileUpdated(
        fullName: _nameCtrl.text.trim(),
        studentId: _studentIdCtrl.text.trim(),
        faculty: _faculty!.label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileAvatar(user: state.user ?? widget.user),
            const SizedBox(height: 16),
            _ReadOnlyField(
              icon: Icons.alternate_email,
              label: 'PSU Email',
              value: widget.user.email,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              label: 'ชื่อ-นามสกุล',
              controller: _nameCtrl,
              enabled: !state.submitting,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              label: 'รหัสนักศึกษา',
              controller: _studentIdCtrl,
              enabled: !state.submitting,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            FacultyPicker(
              value: _faculty,
              enabled: !state.submitting,
              onChanged: (v) => setState(() => _faculty = v),
            ),
            if (_localError != null) ...[
              const SizedBox(height: 12),
              Text(
                _localError!,
                style: const TextStyle(
                  color: AppColors.alert,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: state.submitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppLayout.radiusMd,
                        ),
                      ),
                      side: const BorderSide(color: AppColors.line),
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: AuthPrimaryButton(
                    label: 'บันทึกการเปลี่ยนแปลง',
                    loading: state.submitting,
                    icon: Icons.save_outlined,
                    onPressed: () => _submit(context),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.segBg,
        borderRadius: BorderRadius.circular(AppLayout.radiusMd),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.muted),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
