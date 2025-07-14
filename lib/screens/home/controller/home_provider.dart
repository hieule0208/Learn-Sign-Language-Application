import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider kiểm tra tình trạng Internet thật sự
final internetStatusStreamProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>();

  // Hàm kiểm tra có thật sự kết nối được Internet
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // Lắng nghe thay đổi mạng (WiFi, Mobile, None,...)
  final subscription = Connectivity().onConnectivityChanged.listen((_) async {
    final online = await hasInternet();
    controller.add(online);
  });

  // Kiểm tra ngay lúc khởi tạo
  hasInternet().then((online) => controller.add(online));

  // Dọn dẹp
  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});