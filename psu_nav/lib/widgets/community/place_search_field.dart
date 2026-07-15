import 'package:flutter/material.dart';

import '../../app/app_colors.dart';
import '../../app/app_theme.dart';

class PlaceSearchField extends StatefulWidget {
  const PlaceSearchField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = 'ค้นหาสถานที่ เช่น โรงอาหาร, ห้องสมุด',
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  State<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends State<PlaceSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant PlaceSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(AppLayout.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.ink, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                ),
              ),
              style: const TextStyle(fontSize: 13, color: AppColors.ink),
            ),
          ),
          if (_controller.text.isNotEmpty)
            InkWell(
              onTap: () {
                _controller.clear();
                widget.onChanged('');
              },
              borderRadius: BorderRadius.circular(99),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 16, color: AppColors.muted),
              ),
            ),
        ],
      ),
    );
  }
}
