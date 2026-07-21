import 'package:flutter/material.dart';

import '../../app/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 22,
    this.strokeWidth = 2.4,
    this.label,
    this.color = AppColors.campus,
  });

  final double size;
  final double strokeWidth;
  final String? label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 10),
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(child: LoadingIndicator(label: label));
  }
}

class InlineLoading extends StatelessWidget {
  const InlineLoading({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(child: LoadingIndicator(label: label)),
    );
  }
}

class RouteTransitionOverlay extends StatelessWidget {
  const RouteTransitionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: .55),
      child: const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.4),
        ),
      ),
    );
  }
}
