import 'package:flutter/material.dart';

import '../common/search_field.dart';

class EventSearchField extends StatelessWidget {
  const EventSearchField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = 'ค้นหากิจกรรม เช่น hackathon, อาหาร',
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SearchField(value: value, onChanged: onChanged, hint: hint);
  }
}
