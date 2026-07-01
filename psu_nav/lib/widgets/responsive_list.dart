import 'package:flutter/material.dart';

class ResponsiveList extends StatelessWidget {
  const ResponsiveList({super.key, required this.desktop, required this.children});

  final bool desktop;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!desktop) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemCount: children.length,
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.35,
      ),
      itemBuilder: (context, index) => children[index],
      itemCount: children.length,
    );
  }
}
