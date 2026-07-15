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

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final columns = device == DeviceType.desktop ? 3 : 2;
        final availableWidth = constraints.maxWidth - padding.horizontal;
        final itemWidth = (availableWidth - gap * (columns - 1)) / columns;

        return SingleChildScrollView(
          padding: padding,
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final child in children)
                SizedBox(width: itemWidth, child: child),
            ],
          ),
        );
      },
    );
  }
}
