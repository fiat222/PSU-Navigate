import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class ResponsiveList extends StatelessWidget {
  const ResponsiveList({
    super.key,
    required this.device,
    required this.children,
  });

  final DeviceType device;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final padding = device == DeviceType.phone
        ? const EdgeInsets.fromLTRB(16, 0, 16, 12)
        : const EdgeInsets.fromLTRB(22, 0, 22, 12);

    if (device == DeviceType.phone) {
      return ListView.separated(
        padding: padding,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemCount: children.length,
      );
    }

    final crossAxisCount = device == DeviceType.desktop ? 3 : 2;
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: device == DeviceType.desktop ? 1.65 : 2.2,
      ),
      itemBuilder: (context, index) => children[index],
      itemCount: children.length,
    );
  }
}
