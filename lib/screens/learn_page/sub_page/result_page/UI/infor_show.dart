import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class InforShow extends StatefulHookConsumerWidget {
  final String title;
  final int? metricNumber;
  final int addedNumber;
  const InforShow(this.title, this.metricNumber, this.addedNumber, {super.key});
  @override
  ConsumerState<InforShow> createState() => _InforShowState();
}

class _InforShowState extends ConsumerState<InforShow> {
  bool _showScore = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showScore = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _showScore
              ? Row(
                  key: ValueKey('score'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.metricNumber.toString(),
                      style: TextStyle(
                        color: AppColors.learnPrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " + ${widget.addedNumber}",
                      style: TextStyle(
                        color: AppColors.watchPrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  key: ValueKey('result'),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      (widget.metricNumber! + widget.addedNumber).toString(),
                      style: TextStyle(
                        color: AppColors.learnPrimary,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
