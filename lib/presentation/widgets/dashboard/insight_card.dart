import 'package:flutter/material.dart';
import '../../../data/models/insight_model.dart';
import '../../../core/constants/app_colors.dart';

class InsightCard extends StatelessWidget {
  final InsightModel insight;
  final Animation<double>? animation;

  const InsightCard({
    super.key,
    required this.insight,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    insight.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildTrendIcon(),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                insight.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    insight.change,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getTrendColor(),
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _getTrendIcon(),
                  size: 14,
                  color: _getTrendColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (animation != null) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation!,
          curve: Curves.easeOutCubic,
        )),
        child: FadeTransition(
          opacity: animation!,
          child: card,
        ),
      );
    }

    return card;
  }

  Widget _buildTrendIcon() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _getTrendColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        _getTrendIcon(),
        size: 16,
        color: _getTrendColor(),
      ),
    );
  }

  IconData _getTrendIcon() {
    switch (insight.trend) {
      case TrendType.up:
        return Icons.trending_up;
      case TrendType.down:
        return Icons.trending_down;
      case TrendType.flat:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor() {
    switch (insight.trend) {
      case TrendType.up:
        return AppColors.trendUp;
      case TrendType.down:
        return AppColors.trendDown;
      case TrendType.flat:
        return AppColors.trendFlat;
    }
  }
}
