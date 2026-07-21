import 'package:flutter/material.dart' hide IconButton;

import '../../app/app_colors.dart';
import '../icon_button.dart';

class CommunityComposer extends StatelessWidget {
  const CommunityComposer({
    super.key,
    required this.controller,
    required this.posting,
    required this.replying,
    required this.onSubmit,
    required this.onImage,
    this.replyTargetName,
    this.onCancelReply,
  });

  final TextEditingController controller;
  final bool posting;
  final bool replying;
  final String? replyTargetName;
  final VoidCallback? onCancelReply;
  final VoidCallback onSubmit;
  final VoidCallback onImage;

  @override
  Widget build(BuildContext context) {
    final busy = posting || replying;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyTargetName != null)
            Row(
              children: [
                Expanded(child: Text('กำลังตอบกลับ $replyTargetName')),
                TextButton(
                  onPressed: busy ? null : onCancelReply,
                  child: const Text('ยกเลิก'),
                ),
              ],
            ),
          if (busy) const LinearProgressIndicator(minHeight: 2),
          if (busy) const SizedBox(height: 8),
          Row(
            children: [
              IconButton(icon: Icons.image_outlined, onTap: onImage),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !busy,
                  decoration: InputDecoration(
                    hintText: replyTargetName == null
                        ? 'แชร์ข้อมูลสถานที่นี้...'
                        : 'เขียนคำตอบ...',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                  ),
                  onSubmitted: (_) => onSubmit(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: busy ? Icons.hourglass_top : Icons.send_outlined,
                onTap: busy ? null : onSubmit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
