import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class DictionaraWordListItem extends StatefulHookConsumerWidget {
  final WordModel wordModel;
  const DictionaraWordListItem(this.wordModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DictionaraWordListItemState();
}

class _DictionaraWordListItemState
    extends ConsumerState<DictionaraWordListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.only(bottom: 5),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.secondBackground, width: 2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(right: 25),
            child: Icon(
              widget.wordModel.isMastered
                  ? FontAwesomeIcons.tree
                  : FontAwesomeIcons.seedling,
              size: 40,
              color: AppColors.learnPrimary,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.wordModel.word,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.wordModel.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.textSub, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 25),
            child: GestureDetector(child: Icon(FontAwesomeIcons.ellipsis)),
          ),
        ],
      ),
    );
  }
}
