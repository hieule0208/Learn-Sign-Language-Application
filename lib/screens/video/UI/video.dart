import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Video extends StatefulHookConsumerWidget {
  const Video({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoState();
}
class _VideoState extends ConsumerState<Video> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Videos"),);
  }
}