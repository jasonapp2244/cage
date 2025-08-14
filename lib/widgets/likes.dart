import 'package:cage/res/components/app_color.dart';
import 'package:flutter/material.dart';

class CustomRatingBar extends StatefulWidget {
  final double initialRating;
  final int itemCount;
  final double itemSize;
  final bool allowHalfRating;
  final ValueChanged<double>? onRatingUpdate;

  const CustomRatingBar({
    super.key,
    this.initialRating = 0.0,
    this.itemCount = 5,
    this.itemSize = 40.0,
    this.allowHalfRating = true,
    this.onRatingUpdate,
  });

  @override
  _CustomRatingBarState createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  double _currentRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.itemCount, (index) {
        double rating = index + 1.0;
        double halfRating = rating - 0.5;

        return GestureDetector(
          onTap: () => _updateRating(rating),
          onPanUpdate: (details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.globalToLocal(details.globalPosition);
            final size = renderBox.size.width;
            final newRating = (position.dx / size * widget.itemCount).clamp(
              0.0,
              widget.itemCount.toDouble(),
            );
            if (widget.allowHalfRating) {
              _updateRating(newRating);
            } else {
              _updateRating(newRating.ceilToDouble());
            }
          },
          child: SizedBox(
            width: widget.itemSize,
            height: widget.itemSize,
            child: Stack(
              children: [
                Icon(
                  Icons.star_border,
                  color: AppColor.white.withValues(alpha: 0.5),
                  size: widget.itemSize,
                ),
                if (_currentRating >= rating)
                  Icon(
                    Icons.star,
                    color: AppColor.white,
                    size: widget.itemSize,
                  ),
                if (widget.allowHalfRating &&
                    _currentRating >= halfRating &&
                    _currentRating < rating)
                  Icon(
                    Icons.star_half,
                    color: AppColor.white,
                    size: widget.itemSize,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _updateRating(double newRating) {
    setState(() {
      _currentRating = newRating;
    });
    if (widget.onRatingUpdate != null) {
      widget.onRatingUpdate!(_currentRating);
    }
  }
}
