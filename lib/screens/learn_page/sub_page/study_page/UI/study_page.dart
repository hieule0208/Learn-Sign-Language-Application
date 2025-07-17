import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';
import 'package:how_to_use_provider/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class StudyPage extends ConsumerStatefulWidget {
  final VideoPlayerController videoPlayerController;
  final DataLearnModel dataLearnModel;

  const StudyPage({
    super.key,
    required this.videoPlayerController,
    required this.dataLearnModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyPageState();
}

class _StudyPageState extends ConsumerState<StudyPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VideoPlayerWidget(
            videoPlayerController: widget.videoPlayerController,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.dataLearnModel.word.word,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),
              Text(
                widget.dataLearnModel.word.description,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSub,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButtonCustom(
                "Tiếp tục",
                () => LearnPageController(
                  ref,
                  context,
                ).onContinue(widget.dataLearnModel),
                AppColors.background,
                AppColors.primary,
                20,
                true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
