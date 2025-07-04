import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class SignInOutButton extends StatefulHookConsumerWidget {
  final Icon icon;
  final String text;
  final VoidCallback onPressed;
  final Color bgColor;
  const SignInOutButton(
    this.text,
    this.onPressed,
    this.icon,
    this.bgColor, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignInOutButtonState();
}

class _SignInOutButtonState extends ConsumerState<SignInOutButton> {
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.icon,
            SizedBox(width: 15),
            Text(
              widget.text,
              style: TextStyle(
                color:
                    widget.bgColor == AppColors.secondBackground
                        ? _isPressed
                            ? Colors.black.withAlpha(40)
                            : Colors.black
                        : _isPressed
                        ? Colors.white.withAlpha(40)
                        : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
