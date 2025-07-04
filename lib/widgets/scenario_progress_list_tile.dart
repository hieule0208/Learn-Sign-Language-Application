import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/topic_model.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class ScenarioProgressListTile extends StatefulHookConsumerWidget {
  final TopicModel topic;
  final VoidCallback? continueLearn;
  final VoidCallback goDetailTopic;

  const ScenarioProgressListTile(
    this.topic,
    this.goDetailTopic, {
    this.continueLearn, // named & optional
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScenarioProgressListTileState();
}

class _ScenarioProgressListTileState
    extends ConsumerState<ScenarioProgressListTile> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.goDetailTopic,
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                color: _isPressed ? AppColors.primary.withOpacity(0.9) : AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.topic.numberOfLearnedWord /
                                  widget.topic.numberOfWord ==
                              1
                          ? Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Icon(FontAwesomeIcons.check, color: AppColors.primary),
                          )
                          : Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  backgroundColor: AppColors.textSub,
                                  value:
                                      widget.topic.numberOfLearnedWord /
                                      widget.topic.numberOfWord,
                                  strokeWidth: 4,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  "${(widget.topic.numberOfLearnedWord / widget.topic.numberOfWord * 100).floor()}%",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      SizedBox(width: 20),
                      Container(
                        margin: EdgeInsets.only(right: 50),
                        child: Text(
                          widget.topic.name,
                          style: TextStyle(
                            color: AppColors.secondBackground,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _isPressed ? 0.1 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          widget.topic.hasStartedLearn && !widget.topic.isCompleted
              ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, right: 20),
                    child: ElevatedButton(
                      onPressed: () => widget.continueLearn,
                      child: Text(
                        "Tiếp tục",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            return AppColors.background;
                          },
                        ),
                        overlayColor: WidgetStateProperty.resolveWith<Color>((
                          Set<WidgetState> states,
                        ) {
                          return AppColors.secondBackground;
                        }),
                      ),
                    ),
                  ),
                ],
              )
              : Container(),
        ],
      ),
    );
  }
}
