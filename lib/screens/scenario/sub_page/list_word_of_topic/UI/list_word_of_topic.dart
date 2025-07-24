import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/screens/scenario/controller/scenario_provider.dart';
import 'package:how_to_use_provider/screens/scenario/sub_page/list_word_of_topic/Controller/list_word_of_topic_controller.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/dictionary_word_list_item.dart';
import 'package:how_to_use_provider/widgets/elevated_button_custom.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';

class ListWordOfTopic extends StatefulHookConsumerWidget {
  const ListWordOfTopic({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListWordOfTopicState();
}

class _ListWordOfTopicState extends ConsumerState<ListWordOfTopic> {
  @override
  Widget build(BuildContext context) {
    final listWordData = ref.watch(topicWordDataProvider);
    final topicChosen = ref.watch(chosenTopicProvider);
    return listWordData.when(
      data: (listWordData) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.background,
            toolbarHeight: 50,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                //Overview
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CircularProgressBar
                    Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          child: CircularProgressIndicator(
                            value:
                                topicChosen!.numberOfLearnedWord /
                                topicChosen.numberOfWord,
                            backgroundColor: Colors.grey[300],
                            color: AppColors.primary,
                            strokeWidth: 10,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          child: Center(
                            child: Text(
                              maxLines: 2,
                              "${(topicChosen.numberOfLearnedWord / topicChosen.numberOfWord * 100).toInt()}%",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Info
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //title
                          Text(
                            maxLines: 2,
                            topicChosen.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(height: 10),
                          //metric
                          Text(
                            "${topicChosen.numberOfLearnedWord} / ${topicChosen.numberOfWord} từ và cụm từ",
                          ),
                          SizedBox(height: 10),
                          //button
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                              shape: WidgetStateProperty.all<
                                RoundedRectangleBorder
                              >(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: AppColors.secondBackground,
                                    width: 2,
                                  ),
                                ),
                              ),
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.check,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Đánh dấu tất cả đã biết",
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                //List word
                Expanded(
                  child: ListView.builder(
                    itemCount: listWordData.length,
                    itemBuilder: (context, index) {
                      return DictionaraWordListItem(listWordData[index]);
                    },
                  ),
                ),
                //Button
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 25,
              right: 25,
              bottom: 25,
            ),
            child: ElevatedButtonCustom(
              ListWordOfTopicController().titleButton(topicChosen),
              () => ListWordOfTopicController().routeToLearnPage(context),
              AppColors.background,
              AppColors.primary,
              20,
              true,
            ),
          ),
        );
      },
      error: (error, stack) => Center(child: Text('Lỗi: $error')),
      loading:
          () => const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: LoadingState(
                imagePath: 'lib/assets/image/gestura_logo.png',
                size: 150,
              ),
            ),
          ),
    );
  }
}
