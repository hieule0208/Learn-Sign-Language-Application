
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/singleton_classes/app_singleton.dart';
import 'package:how_to_use_provider/screens/home/UI/home.dart';
import 'package:how_to_use_provider/screens/introduce/UI/introduce.dart';
import 'package:how_to_use_provider/screens/login/UI/login.dart';
import 'package:how_to_use_provider/screens/sign_up/UI/sign_up.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppSingleton().loadFromStorage();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  void requestStoragePermission() async {
    // Check if the platform is not web, as web has no permissions
    if (!kIsWeb) {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Request camera permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AppSingleton().isLogin;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gestura",
      initialRoute: isLoggedIn ? "/home" : "/",
      routes: {
        "/": (context) => Introduce(),
        "/sign_up": (context) => SignUp(),
        // "/choose_level":(context) => ChooseLevel(),
        "/login": (context) => Login(),
        "/home": (context) => Home(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Montserrat'),
          bodyMedium: TextStyle(fontFamily: 'Montserrat'),
          bodySmall: TextStyle(fontFamily: 'Montserrat'),
          headlineLarge: TextStyle(fontFamily: 'Montserrat'),
          headlineMedium: TextStyle(fontFamily: 'Montserrat'),
          headlineSmall: TextStyle(fontFamily: 'Montserrat'),
          titleLarge: TextStyle(fontFamily: 'Montserrat'),
          titleMedium: TextStyle(fontFamily: 'Montserrat'),
          titleSmall: TextStyle(fontFamily: 'Montserrat'),
          labelLarge: TextStyle(fontFamily: 'Montserrat'),
          labelMedium: TextStyle(fontFamily: 'Montserrat'),
          labelSmall: TextStyle(fontFamily: 'Montserrat'),
        ).apply(
          fontFamily: 'Montserrat', // Áp dụng font Montserrat cho toàn bộ Text
        ),
        primarySwatch: Colors.blue,
      ),
    );
  }
}
