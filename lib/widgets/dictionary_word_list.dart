import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/word_model.dart';
import 'package:how_to_use_provider/widgets/dictionary_word_list_item.dart';

class DictionaryWordList extends StatefulHookConsumerWidget {
  final List<WordModel> listWord;
  final int index;
  const DictionaryWordList(this.listWord, this.index, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DictionaryWordListState();
}

class _DictionaryWordListState extends ConsumerState<DictionaryWordList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.listWord.length,
            itemBuilder: (BuildContext context, int index){
              return DictionaraWordListItem(widget.listWord[index]);
            },
          ),
        ),
      ],
    );
  }
}
