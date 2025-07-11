import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class OverViewInfoCard extends StatefulHookConsumerWidget {
  final Icon icon;
  final String points;
  final String title;
  final String titleMetric1;
  final String titleMetric2;
  final String metric1;
  final String metric2;
  final int index;
  final int selectedIndex;
  final VoidCallback voidCallback;
  final Color selectedColor;
  final Color unselectedColor;
  const OverViewInfoCard(
    this.icon,
    this.points,
    this.title,
    this.titleMetric1,
    this.titleMetric2,
    this.metric1,
    this.metric2,
    this.index,
    this.voidCallback,
    this.selectedIndex,
    this.selectedColor,
    this.unselectedColor,
    {super.key}
  );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OverViewInfoCardState();
}

class _OverViewInfoCardState extends ConsumerState<OverViewInfoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.index == widget.selectedIndex;

    return GestureDetector(
      onTap: () {
        widget.voidCallback();
      },
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600), // Thời gian chuyển đổi
        curve: Curves.easeInOut, // Đường cong mượt mà
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? _isPressed
                  ? Colors.grey.withAlpha(20)
                  : widget.selectedColor
              : _isPressed
                  ? Colors.grey.withAlpha(20)
                  : widget.unselectedColor,
          borderRadius: BorderRadius.circular(10),
          
        ),
        // Thêm hiệu ứng scale khi selected
        transform: Matrix4.identity()
          ..scale(isSelected ? 1.0 : 1.0), // Phóng to 5% khi selected
        transformAlignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(margin: const EdgeInsets.only(right: 25), child: widget.icon),
            // Info
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    isSelected
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                '${widget.metric1}  ${widget.titleMetric1}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${widget.metric2}  ${widget.titleMetric2}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            // Points
            Container(
              padding: const EdgeInsets.only(top: 2),
              margin: const EdgeInsets.only(left: 25),
              child: Text(
                '${widget.points} điểm',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}