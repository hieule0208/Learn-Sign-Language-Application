import 'package:hooks_riverpod/hooks_riverpod.dart';

final signUpEmailProvider = StateProvider<Map<String, String>>(
  (ref) => {'email': '', 'password': ''},
);
