import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class ElevatedButtonCustom extends StatefulHookConsumerWidget {
  const ElevatedButtonCustom(
    this.text,
    this.onPressed,
    this.textColor,
    this.bgColor,
    this.fontSize,
    this.hasBorder, {
    super.key,
  });
  final String text;
  final Color textColor;
  final Color bgColor;
  final VoidCallback onPressed;
  final double fontSize;
  final bool hasBorder;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ElevatedButtonCustomState();
}

class _ElevatedButtonCustomState extends ConsumerState<ElevatedButtonCustom> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(12),
          border:
              widget.hasBorder
                  ? _isPressed
                      ? null
                      : const Border(
                        bottom: BorderSide(
                          color:
                              AppColors.primary, // hoặc widget.textColor nếu muốn dùng màu chữ
                          width: 3,
                          style: BorderStyle.solid,
                        ),
                      )
                  : null,
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: widget.fontSize,
            color:
                widget.hasBorder
                    ? widget.textColor
                    : _isPressed
                    ? widget.textColor.withAlpha(40)
                    : widget.textColor,
            fontWeight: FontWeight.bold,
            
          ),
        ),
      ),
    );
  }
}
