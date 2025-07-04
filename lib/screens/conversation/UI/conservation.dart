import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Conservation extends StatefulHookConsumerWidget {
  const Conservation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConservationState();
}
class _ConservationState extends ConsumerState<Conservation> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hội thoại"),);
  }
}