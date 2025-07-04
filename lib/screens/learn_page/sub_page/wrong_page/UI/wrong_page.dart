import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WrongPage extends StatefulHookConsumerWidget {
  const WrongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WrongPageState();
}

class _WrongPageState extends ConsumerState<WrongPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Sai r con gà"),),);
  }
}
