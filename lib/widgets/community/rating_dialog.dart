import 'package:flutter/material.dart';

class RatingDialog extends StatelessWidget {
  const RatingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ให้คะแนนสถานที่'),
      content: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: [
          for (var rating = 1; rating <= 5; rating++)
            TextButton(
              key: Key('rating-$rating'),
              onPressed: () => Navigator.of(context).pop(rating),
              child: Text('$rating'),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก'),
        ),
      ],
    );
  }
}
