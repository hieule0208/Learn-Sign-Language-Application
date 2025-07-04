import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class AnswerChip extends StatefulHookConsumerWidget {
  final String text;
  final void Function() onPressed;
  const AnswerChip(this.text, this.onPressed, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnswerChipState();
}

class _AnswerChipState extends ConsumerState<AnswerChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.text == " " ? EdgeInsets.only(top: 10) : null,
      child: Material(
        color: AppColors.learnPrimary,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.white.withAlpha(30),
          onTap: widget.onPressed,
          child: Container(
            width: widget.text == " " ? double.infinity : null,
            padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 10),
            child:
                widget.text == " "
                    ? Center(child: Text("Space"))
                    : Text(widget.text),
          ),
        ),
      ),
    );
  }
}
