import 'package:flutter/material.dart';

import '../common/search_field.dart';

class PlaceSearchField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SearchField(value: value, onChanged: onChanged, hint: hint);
  }
}
