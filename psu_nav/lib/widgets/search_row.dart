import 'package:flutter/material.dart' hide IconButton;

import '../app/app_colors.dart';
import 'icon_button.dart';

class SearchRow extends StatelessWidget {
  const SearchRow({
    super.key,
    required this.value,
    this.leading,
    this.trailing,
    this.onLeading,
    this.onTrailing,
  });

  final String value;
  final IconData? leading;
  final IconData? trailing;
  final VoidCallback? onLeading;
  final VoidCallback? onTrailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (leading != null) ...[
            IconButton(icon: leading!, onTap: onLeading),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.ink, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            IconButton(icon: trailing!, onTap: onTrailing),
          ],
        ],
      ),
    );
  }
}
