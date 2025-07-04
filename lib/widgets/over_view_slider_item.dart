import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';

class OverViewSliderItem extends StatefulHookConsumerWidget {
  final Icon icon;
  final String title;
  final String? subtitle;
  final String titleButton;
  final VoidCallback onPressed;
  final Color bgColor;
  final Color mainColor;
  const OverViewSliderItem(
    this.icon,
    this.title,
    this.subtitle,
    this.titleButton,
    this.onPressed,
    this.bgColor,
    this.mainColor, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverViewSliderItemState();
}

class _OverViewSliderItemState extends ConsumerState<OverViewSliderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: widget.bgColor, borderRadius: BorderRadius.circular(10), border: Border(top: BorderSide(color: widget.mainColor, width: 5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //icon
          Container(
            padding: EdgeInsets.only(right: 20, ),
            child: widget.icon,
          ),
          //Title and subtitle
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  widget.subtitle == null ? Container() : Text(
                    widget.subtitle!,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: AppColors.textSub,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //button
          Container(
            
            child: ElevatedButtonCustom(
              widget.titleButton,
              widget.onPressed,
              AppColors.background,
              widget.mainColor,
              16,
              true,
            ),
          ),
        ],
      ),
    );
  }
}
