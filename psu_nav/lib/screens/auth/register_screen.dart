import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../models/place_discussion.dart';
import '../../widgets/auth/auth_form_fields.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _studentIdCtrl = TextEditingController();
  PlaceCategory? _faculty;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _nameCtrl.dispose();
    _studentIdCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_faculty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาเลือกคณะ'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    context.read<AuthBloc>().add(
      RegisterRequested(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        fullName: _nameCtrl.text.trim(),
        studentId: _studentIdCtrl.text.trim(),
        faculty: _faculty!.label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'สมัครสมาชิก',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (p, c) => c.errorMessage != p.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.read<AuthBloc>().add(const AuthErrorShown());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state.errorMessage != null) ...[
                            _ErrorBanner(message: state.errorMessage!),
                            const SizedBox(height: 12),
                          ],
                          AuthTextField(
                            label: 'ชื่อ-นามสกุล',
                            controller: _nameCtrl,
                            hint: 'เช่น ธนพล สันพิทักษ์',
                            enabled: !state.submitting,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              if ((v ?? '').trim().isEmpty) {
                                return 'กรุณากรอกชื่อ-นามสกุล';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'รหัสนักศึกษา',
                            controller: _studentIdCtrl,
                            hint: 'เช่น 6510110xxx',
                            enabled: !state.submitting,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if ((v ?? '').trim().isEmpty) {
                                return 'กรุณากรอกรหัสนักศึกษา';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _FacultyPicker(
                            value: _faculty,
                            enabled: !state.submitting,
                            onChanged: (v) => setState(() => _faculty = v),
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'PSU Email',
                            controller: _emailCtrl,
                            hint: 'name@email.psu.ac.th',
                            enabled: !state.submitting,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              final value = (v ?? '').trim();
                              if (value.isEmpty) return 'กรุณากรอกอีเมล';
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'รูปแบบอีเมลไม่ถูกต้อง';
                              }
                              if (!value.toLowerCase().endsWith('.ac.th') &&
                                  !value.toLowerCase().endsWith('.psu.ac.th')) {
                                return 'ควรใช้อีเมลของมหาวิทยาลัย';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'รหัสผ่าน',
                            controller: _passwordCtrl,
                            obscure: _obscure,
                            enabled: !state.submitting,
                            textInputAction: TextInputAction.next,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 18,
                                color: AppColors.muted,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) {
                              if ((v ?? '').isEmpty) return 'กรุณากรอกรหัสผ่าน';
                              if ((v ?? '').length < 6) {
                                return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'ยืนยันรหัสผ่าน',
                            controller: _confirmCtrl,
                            obscure: _obscure,
                            enabled: !state.submitting,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(context),
                            validator: (v) {
                              if ((v ?? '') != _passwordCtrl.text) {
                                return 'รหัสผ่านยืนยันไม่ตรงกัน';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AuthPrimaryButton(
                            label: 'สมัครสมาชิก',
                            loading: state.submitting,
                            icon: Icons.person_add_alt_1_outlined,
                            onPressed: () => _submit(context),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'มีบัญชีอยู่แล้ว? ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                ),
                              ),
                              GestureDetector(
                                onTap: state.submitting
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                child: const Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.campus,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FacultyPicker extends StatelessWidget {
  const _FacultyPicker({
    required this.value,
    required this.onChanged,
    required this.enabled,
  });

  final PlaceCategory? value;
  final ValueChanged<PlaceCategory?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'คณะ',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppLayout.radiusMd),
            border: Border.all(
              color: value == null ? AppColors.alert : AppColors.line,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PlaceCategory>(
              value: value,
              isExpanded: true,
              iconEnabledColor: AppColors.muted,
              hint: const Text(
                'เลือกคณะของคุณ',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              items: [
                for (final c in PlaceCategory.values)
                  DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Icon(c.icon, size: 16, color: AppColors.campus),
                        const SizedBox(width: 8),
                        Text(
                          c.label,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.softWarn,
        border: Border.all(color: AppColors.alert.withValues(alpha: .32)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.alert, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.alert,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
